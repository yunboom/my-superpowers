# generating-design 前后端模板分离 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 让 generating-design skill 自动检测前后端项目类型，使用对应的设计模板和头脑风暴维度。

**Architecture:** 在现有 SKILL.md 流程中插入项目类型检测步骤，Step 3 研究触发条件和 Step 4 头脑风暴维度按项目类型条件分支，Step 5 生成文档时按类型选择模板。

**Tech Stack:** Markdown skill files, design templates

---

### Task 1: 重命名后端模板

**Files:**
- Rename: `skills/generating-design/design-template.md` → `skills/generating-design/design-template-backend.md`

**Step 1: 执行重命名**

```bash
cd /Users/mayunpeng/GolandProjects/my-superpowers
git mv skills/generating-design/design-template.md skills/generating-design/design-template-backend.md
```

**Step 2: 提交**

```bash
git add skills/generating-design/design-template-backend.md
git commit -m "refactor(generating-design): rename design-template.md to design-template-backend.md"
```

---

### Task 2: 创建前端模板

**Files:**
- Create: `skills/generating-design/design-template-frontend.md`

**Step 1: 创建前端模板文件**

内容基于团队 TRD 模板（`/Users/mayunpeng/Downloads/TRD_template.md`），保持原始结构不变：

```markdown
# [需求名称] 技术需求文档（TRD）

## 1. 需求概述

### 1.1 背景
[从 PRD 提取并精简：业务背景、用户痛点、为什么要做这个需求]

### 1.2 目标
[从 PRD 提取并精简：业务目标、技术目标、可量化的指标]

### 1.3 范围
[从 PRD 提取并精简：包含哪些功能、不包含哪些功能、边界条件]

---

## 2. 功能需求拆解

### 2.1 技术任务
- 任务 1：[任务名称和描述]
- 任务 2：[任务名称和描述]

---

## 3. 方案概览

**整体的技术设计图（整体架构图、核心流程图、关键决策和对比）**

[根据 TRD 进行设计补充]

---

## 4. 依赖与前置条件

### 4.1 设计和交互
- **Figma URL：** [从 PRD 提取链接]

### 4.2 Git 仓库和开发分支
** 罗列 git repo 和 branch，但开发是在用户指定的项目路径和当前分支 **
- **Git repo：** [仓库地址]
- **Branch：** feature/[功能名]

### 4.3 权限与风控
- **页面权限：** [登录要求、角色权限]
- **模块权限：** [功能模块的细粒度权限控制]

### 4.4 国际化（i18n）
- **新增翻译 key：** [从 PRD 提取]
  - `key.name.1`: [英文]
  - `key.name.2`: [英文]

### 4.5 业务埋点
- **埋点文档链接：** [从 PRD 提取链接]

---

## 5. 技术方案设计

### 5.1 技术栈/依赖管理
**新增依赖：**
- `package-name@version` - [选择理由、用途]

### 5.2 页面与路由
**新增页面：**
- `/path/to/page` - [页面说明、路由参数、权限控制]

**改动页面：**
- `/existing/page` - [改动内容、影响范围]

### 5.3 状态与数据流
**说明：** Zustand/Redux/Mobx 等全局状态管理

### 5.4 通用 Components、Hooks、Utils

#### 组件 1：ComponentName
- **功能描述：** [组件功能]
- **Props 接口：**
(typescript interface)
- **使用案例：**
(tsx example)

#### Hook 1：useHookName
- **功能描述：** [Hook 功能]
- **使用案例：**
(tsx example)

### 5.5 接口调用策略
**API 列表：**
- `GET /api/endpoint` - [接口说明、请求/响应格式、错误处理]

### 5.6 性能和监控

#### 5.6.1 性能优化
**说明：** 项目如存在动画、定时任务、虚拟列表，滚动加载，拖拽功能，实时预览、大表单校验等功能

#### 5.6.2 性能指标
**说明：** 性能相关的指标补齐，包括 Client 和 Server 端
- **Client 端：** [指标补充]
- **Server 端：** [指标补充]

---

## 6. 跨组协作依赖

**说明：** 依赖其他组的哪些事项

---

## 7. 影响和风险评估

### 7.1 影响模块
- 直接影响：[页面/组件列表]
- 间接影响：[功能列表]

### 7.2 需求风险

| 风险类型 | 风险描述 | 风险等级 | 应对措施 |
|----------|----------|----------|----------|
| 进度风险 | 依赖阻塞 | 中 | 提前沟通 |

---

## 8. 测试方案

[无需填写，开发人员手动补充]

---

## 9. 部署方案

### 9.1 AB/灰度方案

[无需填写，开发人员手动补充]

### 9.2 回滚方案
[无需填写，开发人员手动补充]
```

**Step 2: 提交**

```bash
git add skills/generating-design/design-template-frontend.md
git commit -m "feat(generating-design): add frontend design template (TRD)"
```

---

### Task 3: 更新 SKILL.md — 新增项目类型检测 + 条件分支

**Files:**
- Modify: `skills/generating-design/SKILL.md`

**变更要点：**

1. **description 更新**：移除 "microservice" 措辞，改为通用描述（覆盖前后端）
2. **Overview 更新**：同步通用化措辞
3. **新增 "Step 3: Detect Project Type"**：插入在"Load Standard Skills"之前
4. **Step 3（原"识别技术需求并调研"）重编号为 Step 4**，新增前端研究触发条件和示例
5. **Step 4（原"技术头脑风暴"）重编号为 Step 5**，新增前端维度条件分支
6. **Step 5（原"生成设计文档"）重编号为 Step 6**，按项目类型选择模板
7. **Step 6/7 重编号为 Step 7/8**

**Step 1: 应用以下变更到 SKILL.md**

a) **Frontmatter description** 改为:
```
description: Use when you need to create a detailed technical design for a specific service or frontend application, with automated deep-research capability for technical uncertainties and new technologies
```

b) **Overview** 第一句改为:
```
Conduct detailed technical design for a specified service or frontend application.
```

c) **在 "Step 2: Load Context" 之后、"Load Standard Skills (std)" 之前**插入新步骤:

```markdown
### Step 3: Detect Project Type

Detect the project type by scanning the **working directory root** for characteristic files:

**Frontend signals** (any match → frontend):
- `package.json` exists AND contains frontend framework dependencies (`react`, `vue`, `next`, `nuxt`, `angular`, `svelte`)
- OR config files exist: `vite.config.*`, `next.config.*`, `nuxt.config.*`

**Backend signals** (any match → backend):
- `go.mod`
- `pom.xml` / `build.gradle`
- `requirements.txt` / `pyproject.toml`
- `Cargo.toml`

**Cannot determine** → ask the user.

Announce the detected type: "Detected project type: **frontend/backend**."
```

d) **原 "Step 2: Identify Technical Needs and Research"** 重编号为 **Step 4**，并在研究触发条件和分析说明中增加前端分支:

在"First, analyze requirements..."段落之后添加前端分支：

```markdown
**For backend projects:**
- Identify middleware that could enable the feature (e.g., Redis for caching/locking, Elasticsearch for full-text search, Kafka for event-driven flows)
- Identify architectural patterns needed (e.g., data consistency, distributed transactions, CQRS, eventual consistency)

**For frontend projects:**
- Identify UI library/component framework needs (e.g., design system, component library selection)
- Identify state management and data flow patterns (e.g., global store, server state caching, real-time sync)
- Identify performance-critical rendering concerns (e.g., virtualization, code splitting, SSR/SSG)
```

在 HARD-GATE 的 mandatory research triggers 中增加前端条件：

```markdown
**Backend triggers:**
1. **Middleware selection** — choosing between or introducing middleware (Redis, Elasticsearch, Kafka, RabbitMQ, etc.)
2. **Architecture pattern decisions** — distributed transactions, data consistency, CQRS, event sourcing, saga pattern, etc.

**Frontend triggers:**
3. **UI framework/library selection** — choosing between component libraries, design systems, or UI frameworks
4. **State management decisions** — choosing between state management approaches (Redux, Zustand, Jotai, server state with React Query, etc.)

**Common triggers (both):**
5. **New technology introduction** — any middleware, framework, protocol, or library not currently used in the project
6. **Performance-critical design** — high-throughput, low-latency, large-scale data processing, or complex rendering optimization
```

e) **原 "Step 3: Technical Brainstorming"** 重编号为 **Step 5**，技术维度改为条件分支:

```markdown
**For backend projects**, cover these technical dimensions:
- API design (endpoints, contracts, versioning)
- Data model (tables, indexes, migrations)
- Core logic (algorithms, state machines, business rules)
- Dependencies (external services, libraries, infrastructure)
- Error handling (failure modes, retry strategies, circuit breakers)
- Observability (metrics, logging, alerting)
- Testing strategy (unit, integration, edge cases)
- Rollout plan (feature flags, gradual rollout, rollback)

**For frontend projects**, cover these technical dimensions:
- Page & routing design (new/modified pages, route params, access control)
- Component design (shared components, Props interfaces, reuse strategy)
- State & data flow (global state management, data flow direction)
- API integration strategy (API call list, error handling, loading states)
- Performance optimization (animations, virtual lists, lazy loading, code splitting)
- i18n & analytics (translation keys, business event tracking)
- Compatibility & responsiveness (browser compatibility, mobile adaptation)
- Testing strategy (unit tests, E2E tests, visual regression)
```

f) **原 "Step 4: Generate Design Document"** 重编号为 **Step 6**，模板选择改为条件:

```markdown
### Step 6: Generate Design Document
- **For backend projects:** use `design-template-backend.md` in this skill's directory
- **For frontend projects:** use `design-template-frontend.md` in this skill's directory
- Output content in Chinese, technical terms in English
- Save to `docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/design.md`
```

g) **Step 5/6 重编号为 Step 7/8**

**Step 2: 提交**

```bash
git add skills/generating-design/SKILL.md
git commit -m "feat(generating-design): add project type detection and frontend/backend branching"
```

---

### Task 4: 更新 SKILL.zh-CN.md — 同步中文版

**Files:**
- Modify: `skills/generating-design/SKILL.zh-CN.md`

**Step 1: 同步所有 Task 3 的变更到中文版**

变更与 Task 3 完全对应，内容翻译为中文（技术术语保持英文）。关键翻译点：
- "Detect Project Type" → "检测项目类型"
- "Frontend signals" → "前端项目信号"
- "Backend signals" → "后端项目信号"
- "Cannot determine → ask the user" → "无法确定 → 询问用户"
- 前端维度翻译与设计文档中一致
- 步骤编号同步修正

**Step 2: 提交**

```bash
git add skills/generating-design/SKILL.zh-CN.md
git commit -m "feat(generating-design): sync zh-CN version with frontend/backend branching"
```

---

### Task 5: 更新变更 SOP

**Files:**
- Modify: `docs/sop/变更sop.md`

**Step 1: 在变更历史末尾追加一行**

```markdown
- 2026-03-02: generating-design skill 新增前后端项目类型自动检测，design-template 拆分为 backend/frontend 两个模板，头脑风暴维度按项目类型区分
```

**Step 2: 提交**

```bash
git add docs/sop/变更sop.md
git commit -m "docs(sop): record generating-design frontend/backend split change"
```
