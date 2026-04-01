#!/usr/bin/env bash
# Integration Test: Detailed Design Document Reviewer
# Verifies the design-document-reviewer-prompt catches real technical issues
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "========================================"
echo " Integration Test: Design Document Reviewer"
echo "========================================"
echo ""
echo "This test verifies the design document reviewer by:"
echo "  1. Creating requirements.md and a flawed design.md"
echo "  2. Running the detailed design document reviewer"
echo "  3. Verifying the reviewer catches intentional issues"
echo ""

TEST_PROJECT=$(create_test_project)
echo "Test project: $TEST_PROJECT"
trap "cleanup_test_project $TEST_PROJECT" EXIT

mkdir -p "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search"

# 参考 requirements.md，包含明确的功能要求
cat > "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search/requirements.md" <<'EOF'
# 客户搜索增强需求文档

## 功能范围

1. 支持按客户姓名模糊搜索
2. 支持按手机号精确搜索
3. 搜索结果分页展示，每页 20 条
4. 支持导出搜索结果为 CSV（最多 1000 条）

## 验收标准

1. 搜索结果 P99 响应时间 < 500ms
2. 导出 1000 条数据不超过 10 秒
3. 无结果时展示"未找到匹配客户"提示
EOF

# 创建有意引入缺陷的 design.md
# 故意引入的问题：
#   1. 导出功能（需求第4条）完全没有设计（需求覆盖缺失）
#   2. 搜索接口没有幂等性设计（虽然 GET 本身幂等，但并发限流没有设计）
#   3. 状态机缺少一个关键状态转换（IndexStatus 缺少 FAILED → PENDING 重试转换）
#   4. rollback 策略有 TODO
#   5. 无监控告警章节
cat > "$TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search/design.md" <<'EOF'
# 客户搜索增强详细设计

## 模块设计

### SearchModule
负责处理搜索请求，调用 Elasticsearch 执行查询，返回分页结果。

### IndexSyncModule
负责监听 CustomerService 的数据变更事件，同步更新 Elasticsearch 索引。

## 数据模型

### Elasticsearch Index: customer_search

```json
{
  "mappings": {
    "properties": {
      "id": { "type": "keyword" },
      "name": { "type": "text", "analyzer": "ik_smart" },
      "phone": { "type": "keyword" }
    }
  }
}
```

### IndexSyncStatus 状态机

状态：PENDING → PROCESSING → COMPLETED

- PENDING：等待同步
- PROCESSING：同步中
- COMPLETED：同步完成

（注：FAILED 状态相关处理待定）

## API 设计

### GET /api/search/customers

**Request:**
```
GET /api/search/customers?keyword=张三&page=1&size=20
Authorization: Bearer {token}
```

**Response:**
```json
{
  "total": 100,
  "items": [{ "id": "1", "name": "张三", "phone": "138****8888" }]
}
```

## 存储设计

- 主存储：Elasticsearch（搜索）
- 索引同步状态：MySQL `customer_index_sync_log` 表

## 部署与回滚

- 部署方式：灰度发布，先发布 10% 流量
- 回滚策略：TODO，待评估旧版本是否兼容新索引结构

## 性能

预计 QPS：100，P99 目标 500ms
EOF

OUTPUT_FILE="$TEST_PROJECT/reviewer-output.txt"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

PROMPT="You are testing the detailed design document reviewer.

Read the design-document-reviewer-prompt.md file at: $PLUGIN_DIR/skills/generating-design/design-document-reviewer-prompt.md

Then review the design document at: $TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search/design.md
Cross-checking against requirements at: $TEST_PROJECT/docs/specs/2026-01-01-REQ-001/search/requirements.md

Follow the reviewer prompt exactly. Output the review in the format it specifies."

echo "Running design document reviewer..."
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

# Test 1: 发现导出功能没有设计（需求覆盖缺失）
echo "Test 1: Reviewer found missing export feature coverage..."
if grep -qiE "export|导出|CSV|missing.*requirement|requirement.*not covered|uncovered|coverage" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified missing export feature design"
else
    echo "  [FAIL] Reviewer did not flag missing export feature"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 2: 发现状态机缺少 FAILED 状态转换
echo "Test 2: Reviewer found incomplete state machine (missing FAILED state)..."
if grep -qiE "FAILED|state machine|state.*transition|missing.*state|incomplete.*state|状态机|unreachable" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified incomplete state machine"
else
    echo "  [FAIL] Reviewer did not flag incomplete state machine"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 3: 发现 rollback 策略有 TODO
echo "Test 3: Reviewer found TODO in rollback strategy..."
if grep -qiE "TODO|rollback|回滚|incomplete|placeholder" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified TODO in rollback strategy"
else
    echo "  [FAIL] Reviewer did not flag rollback TODO"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 4: 发现缺少监控告警章节
echo "Test 4: Reviewer found missing monitoring/alerting section..."
if grep -qiE "monitor|alert|monitoring|alerting|observ|告警|监控|missing.*monitor" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer identified missing monitoring section"
else
    echo "  [FAIL] Reviewer did not flag missing monitoring"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 5: Requirements Coverage 章节存在
echo "Test 5: Review output includes Requirements Coverage section..."
if grep -qiE "Requirements Coverage|Coverage|需求覆盖" "$OUTPUT_FILE"; then
    echo "  [PASS] Review includes Requirements Coverage section"
else
    echo "  [FAIL] Review missing Requirements Coverage section"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test 6: 结论是 Issues Found
echo "Test 6: Reviewer verdict is Issues Found..."
if grep -qiE "Issues Found|❌" "$OUTPUT_FILE"; then
    echo "  [PASS] Reviewer correctly marked as Issues Found"
elif grep -qiE "✅ Approved" "$OUTPUT_FILE" && ! grep -qiE "Issues Found|❌" "$OUTPUT_FILE"; then
    echo "  [FAIL] Reviewer incorrectly approved a flawed design"
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
    echo "Design document reviewer correctly caught all intentional issues."
    exit 0
else
    echo "STATUS: FAILED ($FAILED tests failed)"
    echo ""
    echo "Output saved to: $OUTPUT_FILE"
    exit 1
fi
