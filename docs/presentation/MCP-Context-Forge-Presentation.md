# MCP Context Forge: Enterprise AI Tool Management

## Presentation Overview

**Title:** Enterprise AI Tool Governance with Model Context Protocol and MCP Context Forge

**Presenter:** Ruslan Idelfonso Magana Vsevolodovna
**Role:** Data Scientist and AI Engineer
**Organization:** IBM Client Innovation Center Italy

**Duration:** 30 minutes + 5-minute live demo
**Target Audience:** IBM employees, enterprise architects, AI platform engineers

---

## Session Agenda

| Time | Section | Duration |
|------|---------|----------|
| 0:00 | Introduction & Context | 5 min |
| 5:00 | The Challenge: AI Tool Sprawl | 5 min |
| 10:00 | Model Context Protocol (MCP) | 5 min |
| 15:00 | MCP Context Forge Deep Dive | 8 min |
| 23:00 | Live Demo | 5 min |
| 28:00 | Key Takeaways & Q&A | 2 min |

---

# SLIDE 1 - Title Slide

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│          ENTERPRISE AI TOOL GOVERNANCE                          │
│                                                                 │
│     Model Context Protocol (MCP) & MCP Context Forge            │
│                                                                 │
│     A Production-Grade Approach to Scalable,                    │
│     Governed, Agentic AI Infrastructure                         │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│     Ruslan Idelfonso Magana Vsevolodovna                        │
│     Data Scientist & AI Engineer                                │
│     IBM Client Innovation Center Italy                          │
│                                                                 │
│                        [IBM Logo]                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 2 - Session Objectives

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     WHAT YOU WILL LEARN TODAY                                   │
│                                                                 │
│     ► Why AI systems require standardized tool interfaces       │
│                                                                 │
│     ► How Model Context Protocol (MCP) addresses this need      │
│                                                                 │
│     ► What MCP Context Forge provides as a governance layer     │
│                                                                 │
│     ► Enterprise capabilities: federation, multi-tenancy,       │
│       security, and observability                               │
│                                                                 │
│     ► Live demonstration of tool discovery and governance       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 3 - The Evolution of AI Systems

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     THE EVOLUTION OF AI SYSTEMS                                 │
│                                                                 │
│     2020-2022: Question Answering                               │
│     ┌──────────┐                                                │
│     │  Model   │ ──► Text Response                              │
│     └──────────┘                                                │
│                                                                 │
│     2023-2024: Tool-Augmented AI                                │
│     ┌──────────┐     ┌──────────┐                               │
│     │  Model   │ ──► │  Tools   │ ──► Actions                   │
│     └──────────┘     └──────────┘                               │
│                                                                 │
│     2025+: Agentic AI Ecosystems                                │
│     ┌──────────┐     ┌──────────┐     ┌──────────┐              │
│     │ Agents   │ ◄─► │ Services │ ◄─► │ Agents   │              │
│     └──────────┘     └──────────┘     └──────────┘              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 4 - The Enterprise Challenge

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     THE ENTERPRISE CHALLENGE                                    │
│                                                                 │
│     Modern AI systems depend on diverse tool ecosystems:        │
│                                                                 │
│     ┌─────────────┐  ┌─────────────┐  ┌─────────────┐           │
│     │  REST APIs  │  │  Databases  │  │   Legacy    │           │
│     │             │  │             │  │   Systems   │           │
│     └─────────────┘  └─────────────┘  └─────────────┘           │
│                                                                 │
│     ┌─────────────┐  ┌─────────────┐  ┌─────────────┐           │
│     │    gRPC     │  │  Internal   │  │   Cloud     │           │
│     │  Services   │  │  Platforms  │  │  Services   │           │
│     └─────────────┘  └─────────────┘  └─────────────┘           │
│                                                                 │
│     Each requires custom integration, auth, and error handling  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 5 - Pain Points at Scale

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     PAIN POINTS AT ENTERPRISE SCALE                             │
│                                                                 │
│     1. TOOL SPRAWL                                              │
│        No central inventory of available AI tools               │
│        Duplicate integrations across teams                      │
│                                                                 │
│     2. INCONSISTENT SECURITY                                    │
│        Each integration handles auth differently                │
│        No unified audit trail                                   │
│                                                                 │
│     3. OPERATIONAL COMPLEXITY                                   │
│        No visibility into tool usage patterns                   │
│        Difficult to enable/disable tools organization-wide      │
│                                                                 │
│     4. VENDOR LOCK-IN                                           │
│        Tight coupling between models and tools                  │
│        Expensive to switch AI providers                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 6 - Agentic AI Amplifies Complexity

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     AGENTIC AI AMPLIFIES COMPLEXITY                             │
│                                                                 │
│     Traditional AI:                                             │
│     ┌────────┐                                                  │
│     │ Human  │ ──► Model ──► Fixed Tool Set ──► Response        │
│     └────────┘                                                  │
│                                                                 │
│     Agentic AI:                                                 │
│     ┌────────┐                                                  │
│     │ Agent  │ ──► Discover Tools ──► Select Tools              │
│     └────────┘          │                  │                    │
│          ▲              ▼                  ▼                    │
│          │         ┌─────────────────────────┐                  │
│          └─────────│  Execute Autonomously   │                  │
│                    │  Coordinate with Agents │                  │
│                    └─────────────────────────┘                  │
│                                                                 │
│     Agents need DYNAMIC, GOVERNED tool discovery                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 7 - Introducing Model Context Protocol

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     INTRODUCING MODEL CONTEXT PROTOCOL (MCP)                    │
│                                                                 │
│     An open standard that defines how AI systems                │
│     interact with tools, resources, and prompts                 │
│                                                                 │
│     ┌──────────────────────────────────────────────────────┐    │
│     │                                                      │    │
│     │   AI Client  ◄──── MCP Protocol ────►  MCP Server    │    │
│     │                                                      │    │
│     │   (Claude, GPT,     JSON-RPC 2.0       (Tools,       │    │
│     │    watsonx,         SSE/WebSocket       Resources,   │    │
│     │    Custom)          HTTP                 Prompts)    │    │
│     │                                                      │    │
│     └──────────────────────────────────────────────────────┘    │
│                                                                 │
│     Key: Standardized interface, any implementation             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 8 - MCP Core Concepts

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     MCP CORE CONCEPTS                                           │
│                                                                 │
│     TOOLS                                                       │
│     ├── Executable functions with defined schemas               │
│     ├── Input validation, output typing                         │
│     └── Examples: search_database, send_email, run_query        │
│                                                                 │
│     RESOURCES                                                   │
│     ├── URI-addressable data sources                            │
│     ├── MIME-typed content, subscription support                │
│     └── Examples: file://config.json, db://users/123            │
│                                                                 │
│     PROMPTS                                                     │
│     ├── Reusable prompt templates                               │
│     ├── Jinja2 templating, versioning                           │
│     └── Examples: code_review_prompt, summary_template          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 9 - Why MCP Matters for Enterprise

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     WHY MCP MATTERS FOR ENTERPRISE                              │
│                                                                 │
│     ┌─────────────────────────────────────────────────────┐     │
│     │  DECOUPLING          │  REUSABILITY                 │     │
│     │                      │                              │     │
│     │  Models and tools    │  Build once,                 │     │
│     │  evolve              │  use across                  │     │
│     │  independently       │  all AI systems              │     │
│     └──────────────────────┴──────────────────────────────┘     │
│     ┌─────────────────────────────────────────────────────┐     │
│     │  VENDOR FLEXIBILITY  │  FUTURE-PROOF                │     │
│     │                      │                              │     │
│     │  Switch AI providers │  Ready for agentic           │     │
│     │  without rewriting   │  workflows and               │     │
│     │  integrations        │  multi-agent systems         │     │
│     └──────────────────────┴──────────────────────────────┘     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 10 - The Missing Piece: Central Governance

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     THE MISSING PIECE: CENTRAL GOVERNANCE                       │
│                                                                 │
│     MCP standardizes the interface, but enterprises need:       │
│                                                                 │
│     ┌─────────────────────────────────────────────────────┐     │
│     │                                                     │     │
│     │   ?  How do we manage dozens of MCP servers?        │     │
│     │                                                     │     │
│     │   ?  How do we enforce consistent security?         │     │
│     │                                                     │     │
│     │   ?  How do we enable/disable tools centrally?      │     │
│     │                                                     │     │
│     │   ?  How do we provide team-based access control?   │     │
│     │                                                     │     │
│     │   ?  How do we monitor and audit tool usage?        │     │
│     │                                                     │     │
│     └─────────────────────────────────────────────────────┘     │
│                                                                 │
│     This is where MCP Context Forge comes in                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 11 - Introducing MCP Context Forge

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     INTRODUCING MCP CONTEXT FORGE                               │
│                                                                 │
│     A production-grade gateway, proxy, and registry             │
│     for Model Context Protocol servers and A2A agents           │
│                                                                 │
│     ┌─────────────────────────────────────────────────────┐     │
│     │                                                     │     │
│     │   ► Gateway & Proxy Layer                           │     │
│     │   ► Federation across multiple services             │     │
│     │   ► Virtual server composition                      │     │
│     │   ► Multi-transport support (SSE, WebSocket, HTTP)  │     │
│     │   ► Admin UI for real-time management               │     │
│     │   ► Enterprise security & observability             │     │
│     │                                                     │     │
│     └─────────────────────────────────────────────────────┘     │
│                                                                 │
│     Open source: github.com/IBM/mcp-context-forge               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 12 - High-Level Architecture

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     HIGH-LEVEL ARCHITECTURE                                     │
│                                                                 │
│     ┌─────────────────────────────────────────────────────┐     │
│     │              AI Clients / Agents                    │     │
│     │    (Claude, watsonx, GPT, Custom Agents)            │     │
│     └───────────────────────┬─────────────────────────────┘     │
│                             │                                   │
│                             ▼                                   │
│     ┌─────────────────────────────────────────────────────┐     │
│     │           MCP CONTEXT FORGE                         │     │
│     │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐    │     │
│     │  │Registry │ │ Gateway │ │ Auth &  │ │ Metrics │    │     │
│     │  │         │ │  Layer  │ │ RBAC    │ │         │    │     │
│     │  └─────────┘ └─────────┘ └─────────┘ └─────────┘    │     │
│     └───────────────────────┬─────────────────────────────┘     │
│                             │                                   │
│                             ▼                                   │
│     ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐          │
│     │MCP      │  │REST     │  │gRPC     │  │Legacy   │          │
│     │Servers  │  │APIs     │  │Services │  │Systems  │          │
│     └─────────┘  └─────────┘  └─────────┘  └─────────┘          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 13 - Enterprise Capabilities

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     ENTERPRISE CAPABILITIES                                     │
│                                                                 │
│     FEDERATION                         MULTI-TENANCY            │
│     ├── Aggregate tools from           ├── Team-based access    │
│     │   multiple MCP servers           │   control              │
│     ├── Peer gateway discovery         ├── Private/Team/Global  │
│     └── Redis-backed coordination      │   resource visibility  │
│                                        └── RBAC with roles      │
│                                                                 │
│     SECURITY                           OBSERVABILITY            │
│     ├── JWT, OAuth 2.0, SSO            ├── OpenTelemetry        │
│     ├── Multiple IdP support           │   integration          │
│     │   (Okta, Keycloak, Entra ID)     ├── Prometheus metrics   │
│     └── 30+ security checks            └── Distributed tracing  │
│                                                                 │
│     VIRTUALIZATION                     PLUGIN SYSTEM            │
│     ├── REST-to-MCP translation        ├── Pre/post hooks for   │
│     ├── gRPC-to-MCP translation        │   all operations       │
│     └── Automatic schema extraction    └── PII filtering, etc.  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 14 - Tool Lifecycle Management

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     TOOL LIFECYCLE MANAGEMENT                                   │
│                                                                 │
│     ┌──────────┐     ┌──────────┐     ┌──────────┐              │
│     │          │     │          │     │          │              │
│     │ REGISTER │ ──► │  ENABLE  │ ──► │ DISCOVER │              │
│     │          │     │          │     │          │              │
│     └──────────┘     └──────────┘     └──────────┘              │
│          │                │                │                    │
│          ▼                ▼                ▼                    │
│     ┌──────────┐     ┌──────────┐     ┌──────────┐              │
│     │          │     │          │     │          │              │
│     │  VERSION │ ◄── │  INVOKE  │ ◄── │  INVOKE  │              │
│     │          │     │          │     │          │              │
│     └──────────┘     └──────────┘     └──────────┘              │
│          │                │                │                    │
│          ▼                ▼                ▼                    │
│     ┌──────────┐     ┌──────────┐     ┌──────────┐              │
│     │          │     │          │     │          │              │
│     │  AUDIT   │ ◄── │ DISABLE  │ ◄── │  RETIRE  │              │
│     │          │     │          │     │          │              │
│     └──────────┘     └──────────┘     └──────────┘              │
│                                                                 │
│     Full lifecycle visibility and control                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 15 - Security Architecture

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     SECURITY ARCHITECTURE                                       │
│                                                                 │
│     AUTHENTICATION                     AUTHORIZATION            │
│     ┌─────────────────────┐            ┌─────────────────────┐  │
│     │ ► JWT (HS256/RS256) │            │ ► RBAC with roles   │  │
│     │ ► OAuth 2.0         │            │ ► Per-resource      │  │
│     │ ► SSO/OIDC          │            │   permissions       │  │
│     │ ► Basic Auth        │            │ ► Team isolation    │  │
│     └─────────────────────┘            └─────────────────────┘  │
│                                                                 │
│     SUPPORTED IDENTITY PROVIDERS                                │
│     ┌─────────────────────────────────────────────────────┐     │
│     │  GitHub  │  Google  │  Okta  │  Keycloak  │  IBM    │     │
│     │          │          │        │            │  Verify │     │
│     ├──────────┼──────────┼────────┼────────────┼─────────┤     │
│     │  Microsoft Entra ID │  Generic OIDC      │  Custom │     │
│     └─────────────────────────────────────────────────────┘     │
│                                                                 │
│     INPUT/OUTPUT SANITIZATION, SECURITY HEADERS, TLS            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 16 - Federation & Multi-Cluster

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     FEDERATION & MULTI-CLUSTER DEPLOYMENT                       │
│                                                                 │
│              ┌─────────────────────────────┐                    │
│              │      REDIS CLUSTER          │                    │
│              │   (Coordination Layer)      │                    │
│              └──────────────┬──────────────┘                    │
│                             │                                   │
│         ┌───────────────────┼───────────────────┐               │
│         │                   │                   │               │
│         ▼                   ▼                   ▼               │
│     ┌───────────┐     ┌───────────┐     ┌───────────┐           │
│     │ Gateway A │ ◄─► │ Gateway B │ ◄─► │ Gateway C │           │
│     │ (US-East) │     │ (EU-West) │     │ (AP-South)│           │
│     └─────┬─────┘     └─────┬─────┘     └─────┬─────┘           │
│           │                 │                 │                 │
│           ▼                 ▼                 ▼                 │
│     ┌───────────┐     ┌───────────┐     ┌───────────┐           │
│     │ Local MCP │     │ Local MCP │     │ Local MCP │           │
│     │  Servers  │     │  Servers  │     │  Servers  │           │
│     └───────────┘     └───────────┘     └───────────┘           │
│                                                                 │
│     Unified tool discovery across all regions                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 17 - Plugin System

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     EXTENSIBLE PLUGIN SYSTEM                                    │
│                                                                 │
│     PRE-INVOKE HOOKS                   POST-INVOKE HOOKS        │
│     ┌─────────────────────┐            ┌─────────────────────┐  │
│     │ ► Input validation  │            │ ► Result filtering  │  │
│     │ ► Access control    │            │ ► Audit logging     │  │
│     │ ► PII detection     │            │ ► Response transform│  │
│     │ ► Rate limiting     │            │ ► Metrics capture   │  │
│     └─────────────────────┘            └─────────────────────┘  │
│                                                                 │
│     BUILT-IN PLUGINS                                            │
│     ┌─────────────────────────────────────────────────────┐     │
│     │                                                     │     │
│     │  ► PII Filter     - Detects/masks SSN, emails, etc. │     │
│     │  ► Regex Filter   - Pattern-based transformations   │     │
│     │  ► Deny List      - Block specific terms/patterns   │     │
│     │  ► Resource Filter - Size limits, domain blocking   │     │
│     │                                                     │     │
│     └─────────────────────────────────────────────────────┘     │
│                                                                 │
│     Custom plugins: Python classes with hook decorators         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 18 - Observability Stack

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     OBSERVABILITY STACK                                         │
│                                                                 │
│     ┌──────────────────────────────────────────────────────┐    │
│     │                  OpenTelemetry                       │    │
│     └───────────────────────┬──────────────────────────────┘    │
│                             │                                   │
│         ┌───────────────────┼───────────────────┐               │
│         │                   │                   │               │
│         ▼                   ▼                   ▼               │
│     ┌───────────┐     ┌───────────┐     ┌───────────┐           │
│     │  TRACES   │     │  METRICS  │     │   LOGS    │           │
│     ├───────────┤     ├───────────┤     ├───────────┤           │
│     │ Jaeger    │     │ Prometheus│     │ Structured│           │
│     │ Zipkin    │     │ Grafana   │     │ JSON      │           │
│     │ Tempo     │     │           │     │           │           │
│     │ Phoenix   │     │           │     │           │           │
│     └───────────┘     └───────────┘     └───────────┘           │
│                                                                 │
│     ► Correlation IDs for end-to-end tracing                    │
│     ► LLM-specific metrics (tokens, costs, latency)             │
│     ► Tool invocation metrics and error rates                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 19 - Deployment Options

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     FLEXIBLE DEPLOYMENT OPTIONS                                 │
│                                                                 │
│     PYPI PACKAGE                       CONTAINER IMAGES         │
│     ┌─────────────────────┐            ┌─────────────────────┐  │
│     │ pip install         │            │ ghcr.io/ibm/        │  │
│     │   mcp-contextforge- │            │   mcp-context-forge │  │
│     │   gateway           │            │                     │  │
│     │                     │            │ Multi-arch support: │  │
│     │ Quick local setup   │            │ amd64, arm64,       │  │
│     │                     │            │ ppc64le             │  │
│     └─────────────────────┘            └─────────────────────┘  │
│                                                                 │
│     KUBERNETES/OPENSHIFT               IBM CLOUD                │
│     ┌─────────────────────┐            ┌─────────────────────┐  │
│     │ Production Helm     │            │ IBM Code Engine     │  │
│     │ charts with:        │            │                     │  │
│     │ ► HPA               │            │ ► Serverless deploy │  │
│     │ ► Network policies  │            │ ► Auto-scaling      │  │
│     │ ► ServiceMonitor    │            │ ► Managed infra     │  │
│     └─────────────────────┘            └─────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 20 - Admin UI Overview

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     ADMIN UI: REAL-TIME MANAGEMENT                              │
│                                                                 │
│     ┌─────────────────────────────────────────────────────┐     │
│     │  MCP Context Forge Dashboard                        │     │
│     ├─────────────────────────────────────────────────────┤     │
│     │                                                     │     │
│     │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌────────┐  │     │
│     │  │ Servers │  │  Tools  │  │Resources│  │ Prompts│  │     │
│     │  │   12    │  │   47    │  │   23    │  │   8    │  │     │
│     │  └─────────┘  └─────────┘  └─────────┘  └────────┘  │     │
│     │                                                     │     │
│     │  ┌─────────────────────────────────────────────┐    │     │
│     │  │ Recent Activity                             │    │     │
│     │  │ ► search_database invoked (2s ago)          │    │     │
│     │  │ ► new_tool registered (5m ago)              │    │     │
│     │  │ ► gateway_b connected (10m ago)             │    │     │
│     │  └─────────────────────────────────────────────┘    │     │
│     │                                                     │     │
│     └─────────────────────────────────────────────────────┘     │
│                                                                 │
│     Built with HTMX + Alpine.js for responsive updates          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 21 - Demo Introduction

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     LIVE DEMONSTRATION                                          │
│                                                                 │
│     What we will see:                                           │
│                                                                 │
│     1. MCP Context Forge Admin UI                               │
│        └── Central dashboard for tool management                │
│                                                                 │
│     2. Tool Discovery via API                                   │
│        └── How AI clients discover available tools              │
│                                                                 │
│     3. Tool Governance in Action                                │
│        └── Enable/disable tools and observe impact              │
│                                                                 │
│     4. Federation (if time permits)                             │
│        └── Registering and aggregating peer gateways            │
│                                                                 │
│                                                                 │
│                    [SWITCH TO DEMO]                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 22 - Key Outcomes

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     KEY OUTCOMES WITH MCP CONTEXT FORGE                         │
│                                                                 │
│     ┌──────────────────────────────────────────────────────┐    │
│     │                                                      │    │
│     │  BEFORE                        AFTER                 │    │
│     │                                                      │    │
│     │  Custom integrations    ►    Standardized protocol   │    │
│     │  per tool                    for all tools           │    │
│     │                                                      │    │
│     │  Scattered security     ►    Centralized auth        │    │
│     │  configurations              and RBAC                │    │
│     │                                                      │    │
│     │  No visibility into     ►    Complete observability  │    │
│     │  tool usage                  and audit trail         │    │
│     │                                                      │    │
│     │  Vendor-locked          ►    Portable across         │    │
│     │  integrations                AI providers            │    │
│     │                                                      │    │
│     └──────────────────────────────────────────────────────┘    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 23 - Getting Started

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     GETTING STARTED                                             │
│                                                                 │
│     QUICK START (PyPI)                                          │
│     ┌─────────────────────────────────────────────────────┐     │
│     │  pip install mcp-contextforge-gateway               │     │
│     │  mcpgateway serve                                   │     │
│     └─────────────────────────────────────────────────────┘     │
│                                                                 │
│     QUICK START (Docker)                                        │
│     ┌─────────────────────────────────────────────────────┐     │
│     │  docker run -p 4444:4444                            │     │
│     │    ghcr.io/ibm/mcp-context-forge:latest             │     │
│     └─────────────────────────────────────────────────────┘     │
│                                                                 │
│     RESOURCES                                                   │
│     ► GitHub: github.com/IBM/mcp-context-forge                  │
│     ► Documentation: ibm.github.io/mcp-context-forge            │
│     ► PyPI: pypi.org/project/mcp-contextforge-gateway           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 24 - Summary

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     SUMMARY                                                     │
│                                                                 │
│     ┌─────────────────────────────────────────────────────┐     │
│     │                                                     │     │
│     │  1. MCP provides the STANDARD                       │     │
│     │     Consistent interface for AI-tool interaction    │     │
│     │                                                     │     │
│     │  2. MCP Context Forge provides the CONTROL          │     │
│     │     Centralized governance, security, federation    │     │
│     │                                                     │     │
│     │  3. Together they enable SCALE                      │     │
│     │     Production-ready agentic AI infrastructure      │     │
│     │                                                     │     │
│     └─────────────────────────────────────────────────────┘     │
│                                                                 │
│     "Tools become governed, reusable platform assets —          │
│      not one-off integrations."                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# SLIDE 25 - Thank You

## Content

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     THANK YOU                                                   │
│                                                                 │
│     Questions & Discussion                                      │
│                                                                 │
│                                                                 │
│     Ruslan Idelfonso Magana Vsevolodovna                        │
│     Data Scientist & AI Engineer                                │
│     IBM Client Innovation Center Italy                          │
│                                                                 │
│                                                                 │
│     CONNECT                                                     │
│     ► GitHub: github.com/IBM/mcp-context-forge                  │
│     ► Documentation: ibm.github.io/mcp-context-forge            │
│                                                                 │
│                                                                 │
│                        [IBM Logo]                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Appendix: Technical Specifications

### Supported Transport Protocols

| Protocol | Description | Use Case |
|----------|-------------|----------|
| HTTP/JSON-RPC | Standard HTTP with JSON-RPC 2.0 | General API access |
| SSE | Server-Sent Events | Real-time updates |
| WebSocket | Bidirectional communication | Interactive sessions |
| stdio | Standard I/O bridge | Desktop client integration |
| Streamable HTTP | Chunked transfer encoding | High-volume, low-latency |

### Database Support

| Database | Use Case |
|----------|----------|
| SQLite | Development, single-instance |
| PostgreSQL | Production, multi-instance |
| MySQL/MariaDB | Alternative production |

### Key Environment Variables

```bash
# Core
HOST=0.0.0.0
PORT=4444
DATABASE_URL=sqlite:///./mcp.db

# Authentication
JWT_SECRET_KEY=your-secret
AUTH_REQUIRED=true

# Features
MCPGATEWAY_UI_ENABLED=true
MCPGATEWAY_A2A_ENABLED=true

# Federation
REDIS_URL=redis://localhost:6379
```
