---
name: system-design-extension
description: system-design skill 的扩展钩子 — 定义微服务架构发现的范围约束和额外上下文
---

# 系统设计扩展

通过定义范围约束和额外上下文，自定义 `superpowers:system-design` skill 的行为。

## Scope

- trading-service
- merchant-service

## Context

- trading-service: 负责订单交易核心流程，包含支付回调和结算
- merchant-service: 商户管理，提供商户入驻、资质审核能力
