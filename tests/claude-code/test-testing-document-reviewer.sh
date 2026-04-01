#!/usr/bin/env bash
# Integration Test: Testing Document Reviewer
# Verifies the testing-document-reviewer-prompt catches real issues in flawed testing.md
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "========================================"
echo " Integration Test: Testing Document Reviewer"
echo "========================================"
echo ""
echo "This test verifies the testing document reviewer by:"
echo "  1. Creating a design doc and a flawed testing.md"
echo "  2. Running the testing document reviewer"
echo "  3. Verifying the reviewer catches intentional issues"
echo ""

TEST_PROJECT=$(create_test_project)
echo "Test project: $TEST_PROJECT"
trap "cleanup_test_project $TEST_PROJECT" EXIT

mkdir -p "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/auth"

# 参考 design.md，包含 5 个功能点
cat > "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/auth/design.md" <<'EOF'
# Auth System Design

## Functional Requirements

1. User Registration: POST /api/register with email + password → 201 + user object
2. User Login: POST /api/login with credentials → 200 + JWT token
3. Protected Routes: GET /api/profile requires valid JWT → 200 or 401
4. Token Expiry: Tokens expire after 24 hours → 401 after expiry
5. Password Reset: POST /api/reset-password with email → sends reset email
EOF

# 创建有意引入缺陷的 testing.md
# 故意引入的问题：
#   1. TC-03 缺少 curl 命令中的请求 body（不可执行）
#   2. TC-04 用 sleep 替代条件等待（不稳定）
#   3. 功能点 5（Password Reset）完全没有测试用例（漏测）
#   4. TC-02 的 expected result 主观模糊（"should be fast"）
#   5. TC-05 依赖 TC-04 的副作用（顺序依赖）
cat > "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/auth/testing.md" <<'EOF'
# Auth System Testing

## Environment Setup

Start the server with `npm start`.

## Test Cases

### TC-01: User Registration Success
**Type:** API
**Steps:**
1. Send POST /api/register with body `{"email":"test@example.com","password":"password123"}`
2. Verify response status is 201
3. Verify response body contains `id` and `email` fields

**Expected Result:** 201 status, user object in response body

---

### TC-02: User Login Success
**Type:** API
**Steps:**
1. First register a user (run TC-01)
2. Send POST /api/login with credentials
3. Verify response is fast and contains token

**Expected Result:** Login should be fast. Token returned.

---

### TC-03: Protected Route Requires Auth
**Type:** API
**Steps:**
1. Send GET /api/profile
2. Verify the result

**Expected Result:** 401 Unauthorized

---

### TC-04: Token Expiry
**Type:** API
**Steps:**
1. Login to get a token
2. `sleep 86400` to wait for token to expire
3. Send GET /api/profile with expired token
4. Verify 401 response

**Expected Result:** 401 after token expires

---

### TC-05: Verify Profile With Valid Token
**Type:** API
**Steps:**
1. Use the token from TC-04 before it expires
2. Send GET /api/profile with Authorization header
3. Verify 200 response

**Expected Result:** 200 with user profile data
EOF

OUTPUT_FILE="$TEST_PROJECT/reviewer-output.txt"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

PROMPT="You are testing the testing document reviewer.

Read the testing-document-reviewer-prompt.md file at: $PLUGIN_DIR/skills/writing-plans/testing-document-reviewer-prompt.md

Then review the testing document at: $TEST_PROJECT/docs/specs/2026-01-01-REQ-001/auth/testing.md
Using the design document at: $TEST_PROJECT/docs/specs/2026-01-01-REQ-001/auth/design.md

Follow the reviewer prompt exactly. Output the review in the format it specifies."

echo "Running testing document reviewer..."
echo ""
cd "$TEST_PROJECT"
timeout 120 claude -p "$PROMPT" \
    --plugin-dir "$PLUGIN_DIR" \
    --permission-mode bypassPermissions \
    2>&1 | tee "$OUTPUT_FILE" || true

echo ""
echo "=== Verification Tests ==="
echo ""

FAILED=0

# Test 1: 发现 TC-03 缺少 curl body / 不可执行的步骤
echo "Test 1: Reviewer found non-executable step (TC-03 missing curl details)..."
if grep -qiE "TC-03|verify the result|not executable|missing.*body|incomplete.*step|how to verify" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified non-executable test step"
else
    echo "  [FAIL] Reviewer did not identify TC-03 executability issue"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 2: 发现 sleep 导致的不稳定性问题
echo "Test 2: Reviewer found sleep-based wait instability (TC-04)..."
if grep -qiE "sleep|flak|unstable|fixed wait|condition.based|waitFor" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified sleep/flakiness issue"
else
    echo "  [FAIL] Reviewer did not flag sleep-based instability"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 3: 发现 Password Reset 功能点未被测试
echo "Test 3: Reviewer found Password Reset not covered..."
if grep -qiE "password reset|reset.*not covered|missing.*reset|uncovered|no test.*reset|functional point" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified missing password reset test coverage"
else
    echo "  [FAIL] Reviewer did not flag missing password reset coverage"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 4: 发现 TC-02 expected result 模糊
echo "Test 4: Reviewer found vague expected result (TC-02 'should be fast')..."
if grep -qiE "fast|subjective|vague|specific|TC-02|not verifiable" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified vague expected result"
else
    echo "  [FAIL] Reviewer did not flag vague expected result"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 5: 发现 TC-05 依赖 TC-04 的顺序
echo "Test 5: Reviewer found ordering dependency (TC-05 depends on TC-04)..."
if grep -qiE "TC-05|order|depend|independent|TC-04.*TC-05|side effect" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified test ordering dependency"
else
    echo "  [FAIL] Reviewer did not flag TC-05 ordering dependency"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 6: 输出包含 Coverage Check 章节
echo "Test 6: Review output includes Coverage Check section..."
if grep -qiE "Coverage Check|coverage" "$OUTPUT_FILE"; then
    echo "  [PASS] Review includes Coverage Check section"
else
    echo "  [FAIL] Review missing Coverage Check section"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 7: 结论是 Issues Found 而非 Approved
echo "Test 7: Reviewer verdict is Issues Found..."
if grep -qiE "Issues Found|❌" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer correctly marked as Issues Found"
elif grep -qiE "✅ Approved" "$OUTPUT_FILE" && ! grep -qiE "Issues Found|❌" "$OUTPUT_FILE"; then
    echo "  [FAIL] Reviewer incorrectly approved a flawed testing document"
    FAILED=$((FAILED + 1))
else
    echo "  [PASS] Reviewer identified problems (format variant)"
fi
echo ""

echo "========================================"
echo " Test Summary"
echo "========================================"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "STATUS: PASSED"
    echo "Testing document reviewer correctly caught all intentional issues."
    exit 0
else
    echo "STATUS: FAILED ($FAILED tests failed)"
    echo ""
    echo "Output saved to: $OUTPUT_FILE"
    exit 1
fi
