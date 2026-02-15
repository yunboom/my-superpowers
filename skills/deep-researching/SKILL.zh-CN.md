---
name: deep-researching
description: Use when encountering technical uncertainty or new technologies not present in the project during design, to conduct automated web research via sub-agents
---

# 深度技术调研

## 概述

通过派发 web-search sub-agent 进行针对性的技术调研。当识别出多个调研主题时，并行派发多个 sub-agent —— 每个主题一个。

**核心原则：** 并行 sub-agent 派发进行针对性调研 —— 确定问题、派发搜索者、汇总发现。

## 何时触发

1. **技术不确定性** —— 未知的性能上限、兼容性约束、未文档化的行为
2. **项目中不存在的新技术/方案** —— 团队尚未使用过的不熟悉的中间件、框架、协议、库

## 流程

### 步骤 1：拟定调研问题
针对每个不确定领域，创建具体的、可搜索的问题：
- ❌ "Is Redis good?"（太笼统）
- ✅ "Redis vs. Memcached for session storage: performance comparison with 10K concurrent connections"（具体）

### 步骤 2：路由到搜索模块
根据问题类型，确定每个 sub-agent 应加载的搜索模块：

| 问题类型 | 模块 |
|----------|------|
| 技术比较 / 最佳实践 | `general-web` |
| 已知问题 / Bug / 错误 | `github-debug` + `stackoverflow` |
| 算法 / 研究论文 | `academic-papers` |
| 中国生态 / 国内框架 | `chinese-tech` |
| 混合 / 复杂问题 | 根据需要使用多个模块 |

### 步骤 3：派发 Sub-Agent
**硬性约束：** 使用 `web-search-agent` agent 定义。

- **单一主题：** 派发 1 个 sub-agent
- **多个主题：** 并行派发 N 个 sub-agent（每个主题一个）

**每个 sub-agent 的提示模板：**

## Research Task
{specific_research_question}

## Context
{why_this_matters_for_our_design}

## Output Requirements
Return structured findings:
1. Key findings summary (2-3 sentences)
2. Approaches compared (pros/cons/applicable scenarios for each)
3. Recommended approach with justification
4. Source links for all claims

### 步骤 4：汇总结果
- 收集所有 sub-agent 的调研结果
- 综合为统一的调研摘要
- 识别共识和分歧观点
- 给出每个主题的推荐方案

### 步骤 5：返回调用方
将结构化调研报告返回给调用技能（通常是 `generating-design`）。

## 输出格式

### Topic 1: {question}
**Recommendation:** {recommended approach}
**Key Findings:**
- {finding 1}
- {finding 2}
**Alternatives Considered:**
| Approach | Pros | Cons |
|----------|------|------|
**Sources:**
- [source 1](url)
- [source 2](url)

### Topic 2: {question}
...

## 集成关系

**被调用方：** `superpowers:generating-design` 作为必需子技能调用
**依赖：** `.cursor/agents/` 中的 `web-search-agent` agent
