# generating-design skill 前后端模板分离

## 背景

当前 `generating-design` skill 的 `design-template.md` 是纯后端视角（DB设计、缓存设计、消息队列、接口设计、部署设计等），无法适用于前端项目。需要：
1. 将现有模板标记为后端专用
2. 新增前端模板（基于团队 TRD 模板）
3. skill 自动检测项目类型，选用对应模板

## 文件变更

| 操作 | 文件 | 说明 |
|------|------|------|
| 重命名 | `design-template.md` → `design-template-backend.md` | 内容不变 |
| 新建 | `design-template-frontend.md` | 基于团队 TRD 模板 |
| 修改 | `SKILL.md` | 新增检测逻辑 + 条件分支 |
| 修改 | `SKILL.zh-CN.md` | 同步中文版 |
| 更新 | `docs/sop/变更sop.md` | 记录变更 |

## 项目类型检测逻辑

新增步骤插入在"加载上下文"之后、"加载规范 Skills"之前。

检测项目工作目录根目录的特征文件：

**前端项目信号**（任一命中即为前端）：
- `package.json` 存在且包含前端框架依赖（react / vue / next / nuxt / angular / svelte）
- 或存在 `vite.config.*` / `next.config.*` / `nuxt.config.*` 等配置文件

**后端项目信号**（任一命中即为后端）：
- `go.mod`
- `pom.xml` / `build.gradle`
- `requirements.txt` / `pyproject.toml`
- `Cargo.toml`

**无法确定** → 询问用户

## 头脑风暴维度分化

### 后端维度（保持现有）

- API 设计（端点、契约、版本控制）
- 数据模型（表、索引、迁移）
- 核心逻辑（算法、状态机、业务规则）
- 依赖项（外部服务、库、基础设施）
- 错误处理（故障模式、重试策略、熔断器）
- 可观测性（指标、日志、告警）
- 测试策略（单元测试、集成测试、边界用例）
- 发布计划（Feature Flag、灰度发布、回滚方案）

### 前端维度（新增）

- 页面与路由设计（新增/改动页面、路由参数、权限控制）
- 组件设计（通用 Components、Props 接口、复用策略）
- 状态与数据流（全局状态管理、数据流向）
- 接口对接策略（API 调用列表、错误处理、loading 状态）
- 性能优化（动画、虚拟列表、懒加载、代码分割）
- 国际化与埋点（i18n key、业务埋点）
- 兼容性与响应式（浏览器兼容、移动端适配）
- 测试策略（单元测试、E2E 测试、视觉回归）

## 模板选择

Step 4（生成设计文档）根据检测到的项目类型：
- 前端项目 → `design-template-frontend.md`
- 后端项目 → `design-template-backend.md`

## 流程不变

整体流程（确定路径 → 加载上下文 → 检测项目类型 → 识别技术需求并调研 → 技术头脑风暴 → 生成文档 → 用户确认 → 提示下一步）保持不变，仅在检测、维度和模板三处做条件分支。
