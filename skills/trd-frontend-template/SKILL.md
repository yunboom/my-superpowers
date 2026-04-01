---
name: trd-frontend-template
description: Returns the frontend TRD (Technical Requirements Document) design template. Use when generating a detailed design document for a frontend project.
---

# Frontend TRD Template

Return the following template for use in frontend project design documents.

---

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
```typescript
interface ComponentProps {
  // Props 定义
}
```
- **使用案例：**
```tsx
<ComponentName prop1="value" />
```

#### Hook 1：useHookName
- **功能描述：** [Hook 功能]
- **使用案例：**
```tsx
const { data, loading } = useHookName();
```

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
