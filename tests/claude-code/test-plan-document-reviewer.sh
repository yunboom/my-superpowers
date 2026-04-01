#!/usr/bin/env bash
# Integration Test: Plan Document Reviewer
# Verifies the plan-document-reviewer-prompt catches real issues in flawed plans
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "========================================"
echo " Integration Test: Plan Document Reviewer"
echo "========================================"
echo ""
echo "This test verifies the plan document reviewer by:"
echo "  1. Creating a spec and a flawed plan"
echo "  2. Running the plan document reviewer"
echo "  3. Verifying the reviewer catches intentional issues"
echo ""

TEST_PROJECT=$(create_test_project)
echo "Test project: $TEST_PROJECT"
trap "cleanup_test_project $TEST_PROJECT" EXIT

mkdir -p "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/auth"

# 创建参考 spec
cat > "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/auth/design.md" <<'EOF'
# Auth System Design

## Requirements

1. Users can register with email and password
2. Users can log in and receive a JWT token
3. Protected routes require valid JWT
4. Tokens expire after 24 hours
5. Support password reset via email
EOF

# 创建一个有意引入缺陷的 plan.md
# 故意引入的问题：
#   1. TODO 占位符
#   2. "similar to above" 没有实际内容
#   3. 缺少 verification 步骤
#   4. 一个 task 缺少 checkbox 语法
cat > "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/auth/plan.md" <<'EOF'
# Auth System Implementation Plan

## Chunk 1: User Registration & Login

### Task 1: Create User Model

- [ ] Create `src/models/user.ts`
- [ ] Add email and password fields
- [ ] Add password hashing on save
- [ ] TODO: Add validation logic here

**Verification:** Run unit tests

### Task 2: Create Login Route

Steps are similar to above, refer to Task 1 for details.

**Verification:** TODO

### Task 3: Add JWT Middleware

- [ ] Create `src/middleware/auth.ts`
- [ ] Validate JWT on protected routes
- [ ] Return 401 on invalid token

(Note: password reset flow will be handled later)
EOF

OUTPUT_FILE="$TEST_PROJECT/reviewer-output.txt"

PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

PROMPT="You are testing the plan document reviewer.

Read the plan-document-reviewer-prompt.md file at: $PLUGIN_DIR/skills/writing-plans/plan-document-reviewer-prompt.md

Then review Chunk 1 of the plan at: $TEST_PROJECT/docs/specs/2026-01-01-REQ-001/auth/plan.md
Using the spec at: $TEST_PROJECT/docs/specs/2026-01-01-REQ-001/auth/design.md

Follow the reviewer prompt exactly. Output the review in the format it specifies."

echo "Running plan document reviewer..."
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

# Test 1: 发现 TODO 占位符
echo "Test 1: Reviewer found TODO placeholders..."
if grep -qi "TODO" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified TODO markers"
else
    echo "  [FAIL] Reviewer did not identify TODO markers"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 2: 发现 "similar to above" 问题
echo "Test 2: Reviewer found 'similar to above' incomplete task..."
if grep -qiE "similar|incomplete|missing content|no actual|placeholder" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified incomplete task content"
else
    echo "  [FAIL] Reviewer did not identify 'similar to above' issue"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 3: 发现缺少 verification 步骤
echo "Test 3: Reviewer found missing verification step..."
if grep -qiE "verification|verify|TODO.*verif|verif.*TODO" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified missing/incomplete verification"
else
    echo "  [FAIL] Reviewer did not identify missing verification"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 4: 发现 spec 未覆盖（password reset 被推迟）
echo "Test 4: Reviewer found spec requirement not covered (password reset)..."
if grep -qiE "password reset|reset.*later|not covered|missing.*reset|scope" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified uncovered spec requirement"
else
    echo "  [FAIL] Reviewer did not flag missing password reset coverage"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 5: 输出格式包含 Status 字段
echo "Test 5: Review output has correct format..."
if grep -qiE "Status.*Issues Found|Issues Found|❌" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer correctly marked as Issues Found"
elif grep -qiE "Status.*Approved|✅ Approved" "$OUTPUT_FILE" && ! grep -qiE "Issues Found|❌" "$OUTPUT_FILE"; then
    echo "  [FAIL] Reviewer incorrectly approved a flawed plan"
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
    echo "Plan document reviewer correctly caught all intentional issues."
    exit 0
else
    echo "STATUS: FAILED ($FAILED tests failed)"
    echo ""
    echo "Output saved to: $OUTPUT_FILE"
    exit 1
fi
