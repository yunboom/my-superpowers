# 变更 SOP

## 背景

[requirements.md](requirements.md)

## 文件变更规则

1. **只变更项目根目录下的文件**（`skills/`、`commands/`、`agents/`、`hooks/` 等），**不变更 `.cursor/` 目录下的内容**
2. `.cursor/` 目录下的文件由 Cursor IDE 自动同步或手动处理，不在常规变更范围内
3. 尽可能的不修改my-superpowers原有内容，除非有必要（如：需要调整目录名称等等）
4. 新增内容可参考my-superpowers现有逻辑，他是最好的老师
5. 修改或创建markdown内容时，需要同步修改或新增.zh-CH.md

## 变更历史

- 2026-02-15: 初始创建产研流程扩展（5 新 skill + 3 修改 skill + 3 command + 6 agent 文件 + 19 中文翻译）
- 2026-02-26: system-design 新增 extension 钩子 + 示例 system-design-extension skill
- 2026-02-26: 设计方案和 coding 阶段 skill 新增 std 规范 skill 扫描加载机制 + testing.md 集成测试新增 Docker 中间件环境提示
- 2026-02-26: using-xspec skill 增加双工作流路由逻辑，同时描述工作流 A（自由想法）和工作流 B（PRD 驱动），含路由规则表和更新后的决策流程图
