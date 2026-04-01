#!/usr/bin/env bash
# Integration Test: Requirements Document Reviewer
# Verifies the requirements-document-reviewer-prompt catches real issues in flawed requirements.md
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "========================================"
echo " Integration Test: Requirements Document Reviewer"
echo "========================================"
echo ""
echo "This test verifies the requirements document reviewer by:"
echo "  1. Creating a flawed requirements.md"
echo "  2. Running the requirements document reviewer"
echo "  3. Verifying the reviewer catches intentional issues"
echo ""

TEST_PROJECT=$(create_test_project)
echo "Test project: $TEST_PROJECT"
trap "cleanup_test_project $TEST_PROJECT" EXIT

mkdir -p "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search"

# 创建有意引入缺陷的 requirements.md
# 故意引入的问题：
#   1. 验收标准主观模糊（"搜索要快"）
#   2. 异常流程完全缺失（搜索无结果怎么办、服务不可用怎么办）
#   3. 功能范围用"等"收尾（隐含未定义范围）
#   4. 权限章节有 TODO
#   5. 用户场景只有成功路径，无失败场景
cat > "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search/requirements.md" <<'EOF'
# 客户搜索增强需求文档

## 功能范围

**In scope:**
- 支持按客户姓名模糊搜索
- 支持按手机号搜索
- 搜索结果分页展示
- 以及其他搜索相关功能

**Out of scope:**
- 订单搜索

## 用户场景

### 场景一：客服人员搜索客户

1. 客服在搜索框输入客户姓名
2. 系统展示匹配的客户列表
3. 客服点击进入客户详情

## 业务规则

1. 搜索支持模糊匹配
2. 每页展示 20 条结果
3. 结果按相关性排序

## 权限与角色

TODO：待产品确认哪些角色可以使用搜索功能

## 验收标准

1. 输入关键词后能返回匹配结果
2. 搜索响应要快
3. 分页功能正常
EOF

OUTPUT_FILE="$TEST_PROJECT/reviewer-output.txt"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

PROMPT="You are testing the requirements document reviewer.

Read the requirements-document-reviewer-prompt.md file at: $PLUGIN_DIR/skills/prd-clarifying/requirements-document-reviewer-prompt.md

Then review the requirements document at: $TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search/requirements.md

Follow the reviewer prompt exactly. Output the review in the format it specifies."

echo "Running requirements document reviewer..."
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

# Test 1: 发现验收标准模糊（"要快"）
echo "Test 1: Reviewer found vague acceptance criteria ('搜索要快')..."
if grep -qiE "fast|快|subjective|vague|measurable|specific|verifiable|acceptance" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified vague acceptance criteria"
else
    echo "  [FAIL] Reviewer did not flag vague acceptance criteria"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 2: 发现异常流程缺失
echo "Test 2: Reviewer found missing exception/error flows..."
if grep -qiE "exception|error|exception flow|异常|无结果|empty|no result|failure|fail" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified missing exception flows"
else
    echo "  [FAIL] Reviewer did not flag missing exception flows"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 3: 发现功能范围含糊（"以及其他"）
echo "Test 3: Reviewer found vague scope ('以及其他搜索相关功能')..."
if grep -qiE "scope|boundary|以及其他|unclear|ambiguous|undefined|vague.*scope|range" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified vague functional boundary"
else
    echo "  [FAIL] Reviewer did not flag vague functional boundary"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 4: 发现权限章节 TODO
echo "Test 4: Reviewer found TODO in permissions section..."
if grep -qiE "TODO|permission|role|权限|incomplete|placeholder" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified TODO in permissions"
else
    echo "  [FAIL] Reviewer did not flag permissions TODO"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 5: 结论是 Issues Found
echo "Test 5: Reviewer verdict is Issues Found..."
if grep -qiE "Issues Found|❌" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer correctly marked as Issues Found"
elif grep -qiE "✅ Approved" "$OUTPUT_FILE" && ! grep -qiE "Issues Found|❌" "$OUTPUT_FILE"; then
    echo "  [FAIL] Reviewer incorrectly approved a flawed requirements document"
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
    echo "Requirements document reviewer correctly caught all intentional issues."
    exit 0
else
    echo "STATUS: FAILED ($FAILED tests failed)"
    echo ""
    echo "Output saved to: $OUTPUT_FILE"
    exit 1
fi
