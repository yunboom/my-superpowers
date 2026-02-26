---
name: system-design
description: Use when you need to understand the current project's microservice architecture, domain boundaries, and inter-service dependencies before making high-level design decisions
---

# System Architecture Discovery

## Overview

Discover and document the current project's microservice architecture and domain boundaries. Provides structured context for high-level design decisions.

**Core principle:** Automated architecture discovery through project introspection — analyze code, configs, and infrastructure to build a comprehensive system map.

## The Process

### Step 0: Load Extension (Optional)
Attempt to invoke the `superpowers:system-design-extension` skill using the Skill tool:
- **If the skill exists:** Parse its content for two optional sections:
  - `## Scope` — A list of service/repository names. If present, **only scan these directories** in subsequent steps.
  - `## Context` — A list of `- {service-name}: {description}` entries. If present, **append these descriptions** to the corresponding services in the architecture summary output.
- **If the skill does not exist:** Skip this step and proceed with full workspace scanning (default behavior).

### Step 1: Explore Project Structure
Scan the workspace for architecture indicators:
If a Scope was loaded in Step 0, only scan the listed service directories. Otherwise, scan the entire workspace.
- Repository structure (mono-repo vs. multi-repo)
- Service directories and their contents
- Build files (go.mod, pom.xml, package.json, Cargo.toml, etc.)
- Docker/container files (Dockerfile, docker-compose.yml)
- Kubernetes manifests (deployment.yaml, service.yaml)
- Infrastructure-as-code (terraform, pulumi, etc.)

### Step 2: Identify Services
For each service found:
- Name and location
- Tech stack (language, framework, runtime)
- Entry points (main files, server startup)
- Exposed ports and protocols

### Step 3: Analyze Domain Boundaries
Infer domain boundaries from:
- Package/module structure within services
- API definitions (OpenAPI/Swagger, protobuf, GraphQL schemas)
- Event definitions (Kafka topics, RabbitMQ exchanges, event schemas)
- Shared libraries and common modules
- Database schemas and ownership

### Step 4: Map Dependencies
Discover inter-service dependencies:
- API calls (HTTP/gRPC client configurations)
- Message queue producers/consumers
- Shared database connections
- Cache dependencies
- External service integrations

### Step 5: Output Architecture Summary

If Context entries were loaded in Step 0, merge them into the corresponding service descriptions in the Services section below.

Output structured text in the following format:

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

## When NOT to Use

- Single-service projects (skip directly to detailed design)
- When architecture documentation already exists and is up-to-date (read it instead)

## Integration

**Called by:** `superpowers:generating-hld` as REQUIRED SUB-SKILL
**OPTIONAL EXTENSION:** superpowers:system-design-extension (scope constraints and additional context)
