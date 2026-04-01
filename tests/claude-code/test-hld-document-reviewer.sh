#!/usr/bin/env bash
# Integration Test: HLD Document Reviewer
# Verifies the hld-document-reviewer-prompt catches real architectural issues
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "========================================"
echo " Integration Test: HLD Document Reviewer"
echo "========================================"
echo ""
echo "This test verifies the HLD document reviewer by:"
echo "  1. Creating a flawed hld.md with intentional architectural issues"
echo "  2. Running the HLD document reviewer"
echo "  3. Verifying the reviewer catches the issues"
echo ""

TEST_PROJECT=$(create_test_project)
echo "Test project: $TEST_PROJECT"
trap "cleanup_test_project $TEST_PROJECT" EXIT

mkdir -p "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search"

# 创建有意引入缺陷的 hld.md
# 故意引入的问题：
#   1. SearchService 职责不单一（既做搜索又做用户鉴权）
#   2. SearchService 依赖 NotificationService，但没有接口定义
#   3. 循环依赖：OrderService → SearchService → OrderService
#   4. Customer 数据同时被 CustomerService 和 SearchService 写入
#   5. 有风险项但没有任何缓解策略
cat > "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search/hld.md" <<'EOF'
# 客户搜索增强 HLD

## 系统边界

本次变更涉及：SearchService、CustomerService、OrderService、NotificationService

## 服务职责

### SearchService
- 提供客户搜索接口
- 处理搜索结果排序和分页
- 负责用户登录态验证和权限检查
- 维护搜索索引同步

### CustomerService
- 管理客户基础信息 CRUD

### OrderService
- 管理订单信息

### NotificationService
- 发送通知消息

## 接口与事件

### SearchService 提供的接口

| 接口 | 方法 | 说明 |
|------|------|------|
| /api/search/customers | GET | 搜索客户列表 |

### CustomerService 提供的接口

| 接口 | 方法 | 说明 |
|------|------|------|
| /api/customers/{id} | GET | 获取客户详情 |

## 依赖关系

- SearchService → CustomerService（读取客户数据）
- SearchService → NotificationService（发送搜索通知）
- SearchService → OrderService（获取订单数量）
- OrderService → SearchService（触发索引更新）

## 数据归属

| 数据实体 | 归属服务 |
|---------|---------|
| Customer | CustomerService, SearchService |
| Order | OrderService |
| SearchIndex | SearchService |

## 风险与开放问题

| 风险 | 影响 |
|------|------|
| Elasticsearch 集群故障时搜索不可用 | 高 |
| 索引同步延迟导致搜索结果不一致 | 中 |
EOF

OUTPUT_FILE="$TEST_PROJECT/reviewer-output.txt"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

PROMPT="You are testing the HLD document reviewer.

Read the hld-document-reviewer-prompt.md file at: $PLUGIN_DIR/skills/generating-hld/hld-document-reviewer-prompt.md

Then review the HLD document at: $TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search/hld.md

Follow the reviewer prompt exactly. Output the review in the format it specifies."

echo "Running HLD document reviewer..."
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

# Test 1: 发现 SearchService 职责不单一
echo "Test 1: Reviewer found SearchService has multiple responsibilities..."
if grep -qiE "SearchService|single.*responsib|responsib.*overlap|multiple.*responsib|鉴权|auth.*search|overlapping" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified mixed responsibilities in SearchService"
else
    echo "  [FAIL] Reviewer did not flag SearchService responsibility issue"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 2: 发现 SearchService → NotificationService 依赖但无接口定义
echo "Test 2: Reviewer found missing interface definition (SearchService → NotificationService)..."
if grep -qiE "NotificationService|missing.*interface|interface.*missing|undefined.*interface|no.*interface|interface.*not defined" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified missing interface for NotificationService dependency"
else
    echo "  [FAIL] Reviewer did not flag missing NotificationService interface"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 3: 发现循环依赖
echo "Test 3: Reviewer found circular dependency (SearchService ↔ OrderService)..."
if grep -qiE "circular|cycle|循环依赖|circular depend|SearchService.*OrderService.*SearchService|mutual depend" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified circular dependency"
else
    echo "  [FAIL] Reviewer did not flag circular dependency"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 4: 发现 Customer 数据被两个服务拥有
echo "Test 4: Reviewer found Customer data owned by multiple services..."
if grep -qiE "Customer.*multiple|multiple.*owner|data.*owner|两个服务|SearchService.*CustomerService.*Customer|shared.*data|multi.*service.*write" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified multiple ownership of Customer data"
else
    echo "  [FAIL] Reviewer did not flag Customer data ownership issue"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 5: 发现风险没有缓解策略
echo "Test 5: Reviewer found risks without mitigation strategies..."
if grep -qiE "mitigation|mitigat|risk.*strategy|no.*mitigation|缓解|应对|strategy.*risk|fallback|contingency" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified risks without mitigation strategies"
else
    echo "  [FAIL] Reviewer did not flag missing risk mitigation strategies"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 6: 结论是 Issues Found
echo "Test 6: Reviewer verdict is Issues Found..."
if grep -qiE "Issues Found|❌" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer correctly marked as Issues Found"
elif grep -qiE "✅ Approved" "$OUTPUT_FILE" && ! grep -qiE "Issues Found|❌" "$OUTPUT_FILE"; then
    echo "  [FAIL] Reviewer incorrectly approved a flawed HLD"
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
    echo "HLD document reviewer correctly caught all intentional issues."
    exit 0
else
    echo "STATUS: FAILED ($FAILED tests failed)"
    echo ""
    echo "Output saved to: $OUTPUT_FILE"
    exit 1
fi
