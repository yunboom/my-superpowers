---
name: system-design
description: Use when you need to understand the current project's microservice architecture, domain boundaries, and inter-service dependencies before making high-level design decisions
---

# 系统架构发现

## 概述

发现并记录当前项目的微服务架构和领域边界。为高层设计决策提供结构化的上下文信息。

**核心原则：** 通过项目自省进行自动化架构发现 —— 分析代码、配置和基础设施以构建全面的系统映射。

## 流程

### 步骤 0：加载扩展（可选）
**可选扩展：** Use `superpowers:system-design-extension`
- **如果该扩展存在：** 遵循其指示来约束或增强架构发现过程。
- **如果该扩展不存在：** 跳过此步骤，继续全量扫描工作区（默认行为）。

### 步骤 1：探索项目结构
扫描工作区中的架构指标：
- 仓库结构（mono-repo vs. multi-repo）
- 服务目录及其内容
- 构建文件（go.mod、pom.xml、package.json、Cargo.toml 等）
- Docker/容器文件（Dockerfile、docker-compose.yml）
- Kubernetes 清单（deployment.yaml、service.yaml）
- 基础设施即代码（terraform、pulumi 等）

### 步骤 2：识别服务
对于发现的每个服务：
- 名称和位置
- 技术栈（语言、框架、运行时）
- 入口点（main 文件、服务启动）
- 暴露的端口和协议

### 步骤 3：分析领域边界
从以下内容推断领域边界：
- 服务内的包/模块结构
- API 定义（OpenAPI/Swagger、protobuf、GraphQL schemas）
- 事件定义（Kafka topics、RabbitMQ exchanges、事件 schemas）
- 共享库和公共模块
- 数据库 schemas 和所有权

### 步骤 4：映射依赖关系
发现服务间的依赖关系：
- API 调用（HTTP/gRPC 客户端配置）
- 消息队列生产者/消费者
- 共享数据库连接
- 缓存依赖
- 外部服务集成

### 步骤 5：输出架构摘要

以以下格式输出结构化文本：

## Services
- {service-name}: {responsibility} | {tech-stack} | {port}

## Domain Boundaries
- {Domain}: [{service-list}]

## Existing Dependencies
- {source} → {target} ({protocol}: {detail})

## Shared Infrastructure
- {infrastructure} (shared by: {service-list})

## External Integrations
- {service} → {external} ({purpose})

## 何时不使用

- 单服务项目（直接跳到详细设计）
- 当架构文档已存在且是最新的（直接读取即可）

## 集成关系

**被调用方：** `superpowers:generating-hld` 作为必需子技能调用
**可选扩展：** superpowers:system-design-extension（范围约束和额外上下文）
