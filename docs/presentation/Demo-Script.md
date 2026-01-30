# Demo Script: MCP Context Forge Live Demonstration

**Duration:** 10-15 minutes (interactive, self-paced)
**Script:** `demo.sh` (automated terminal demonstration)
**Prerequisites:** MCP Context Forge server running

---

## Overview

The `demo.sh` script provides a complete, interactive terminal demonstration with:
- ASCII architecture diagrams
- Full curl commands displayed (not truncated)
- Storytelling narratives explaining each concept
- Step-by-step progression with "Press Enter to continue"

This document explains what the presenter should say and highlight at each stage.

---

## Pre-Demo Setup

### 1. Start MCP Context Forge Server

Open **Terminal 1** and start the server:

```bash
# Option A: From source (recommended for demo)
make dev

# Option B: PyPI installation
pip install mcp-contextforge-gateway
mcpgateway serve --port 4444

# Option C: Docker
docker run -p 4444:4444 \
  -e MCPGATEWAY_UI_ENABLED=true \
  ghcr.io/ibm/mcp-context-forge:latest
```

### 2. Verify Server is Running

```bash
curl http://localhost:4444/health
# Should return: {"status":"healthy"}
```

### 3. Run the Demo Script

Open **Terminal 2** (full screen recommended) and run:

```bash
bash demo.sh
```

### 4. Browser Tabs (Optional)

Keep these open to show alongside the terminal:
- **Tab 1:** Admin UI at `http://localhost:4444/admin`
- **Tab 2:** API docs at `http://localhost:4444/docs`

---

## Demo Flow

The demo.sh script has 5 main parts. Below is the presenter guide for each section.

---

## Welcome Screen: MCP Architecture

**What Appears:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    MODEL CONTEXT PROTOCOL (MCP)                         │
│                         Architecture Overview                           │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐         ┌──────────────────┐         ┌──────────────────┐
│   AI CLIENT      │         │   AI CLIENT      │         │   AI CLIENT      │
│  (Claude, GPT,   │         │  (watsonx,       │         │  (Custom         │
│   Copilot)       │         │   Granite)       │         │   Agents)        │
└────────┬─────────┘         └────────┬─────────┘         └────────┬─────────┘
         │                            │                            │
         │         MCP Protocol (JSON-RPC 2.0)                     │
         │         SSE / WebSocket / HTTP                          │
         └────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                      MCP CONTEXT FORGE                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │
│  │  Registry   │  │   Gateway   │  │  Auth &     │  │  Metrics &  │    │
│  │  (Tools,    │  │   Layer     │  │  RBAC       │  │  Logging    │    │
│  │  Resources) │  │             │  │             │  │             │    │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘    │
└─────────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   MCP Server     │  │   REST API       │  │   Legacy         │
│   (Native)       │  │   (Virtualized)  │  │   System         │
└──────────────────┘  └──────────────────┘  └──────────────────┘
```

**Presenter Script:**

> "Welcome to the MCP Context Forge demonstration. Let me start by explaining the architecture.
>
> At the top, we have AI clients - this could be Claude, GPT, watsonx Granite, or any custom AI agent you build.
>
> These clients communicate using the Model Context Protocol, or MCP - an open standard using JSON-RPC 2.0 over various transports like SSE, WebSocket, or HTTP.
>
> In the middle is MCP Context Forge - our central control plane. It provides:
> - A **Registry** for tools, resources, and prompts
> - A **Gateway layer** for routing requests
> - **Authentication and RBAC** for security
> - **Metrics and logging** for observability
>
> At the bottom are the actual backend services - these can be native MCP servers, REST APIs that we virtualize, or even legacy systems.
>
> The key insight is that AI clients only need to know about Context Forge. They don't need to know about individual services."

**Press Enter to continue**

---

## Part 1: Tool Registration

**What the Script Explains:**

The script will explain that TOOLS are executable functions with:
- `name` - Unique identifier
- `description` - Human-readable explanation (helps AI understand purpose)
- `inputSchema` - JSON Schema defining parameters

**Tool 1: search_database**

The full curl command is displayed:

```bash
curl -X POST "http://localhost:4444/tools" \
  -u admin:changeme \
  -H "Content-Type: application/json" \
  -d '{
    "tool": {
      "name": "search_database",
      "description": "Search the enterprise database for records matching a query",
      "inputSchema": {
        "type": "object",
        "properties": {
          "query": {
            "type": "string",
            "description": "Search query"
          },
          "limit": {
            "type": "integer",
            "description": "Maximum results",
            "default": 10
          }
        },
        "required": ["query"]
      }
    }
  }'
```

**Presenter Script:**

> "Let's register our first tool. This is the complete curl command being executed.
>
> Notice the structure:
> - We POST to `/tools` with basic authentication
> - The body is wrapped in a `tool` key
> - The `inputSchema` uses JSON Schema to define what parameters the tool accepts
> - The `query` parameter is required, while `limit` is optional with a default of 10
>
> This schema is what AI clients will use to understand how to call this tool."

**Tool 2: send_notification**

**Presenter Script:**

> "Our second tool demonstrates more advanced JSON Schema features.
>
> Notice:
> - `recipients` is an **array** of strings - for multiple email addresses
> - `priority` uses an **enum** to restrict values to 'low', 'normal', or 'high'
>
> The AI will see these constraints and know exactly what valid inputs look like."

**Tool 3: generate_report**

**Presenter Script:**

> "The third tool shows a nested object type for complex data input.
>
> With all three tools registered, they're immediately available for discovery by any AI client connected to Context Forge."

---

## Part 2: Tool Discovery

**What Appears:**

```bash
curl -s "http://localhost:4444/tools" | jq '.[] | {name, description, enabled}'
```

Response:
```json
{
  "name": "search-database",
  "description": "Search the enterprise database for records matching a query",
  "enabled": true
}
{
  "name": "send-notification",
  "description": "Send a notification to specified recipients",
  "enabled": true
}
{
  "name": "generate-report",
  "description": "Generate a formatted report from provided data",
  "enabled": true
}
```

**Presenter Script:**

> "Now let's see how AI clients discover these tools.
>
> When an AI connects to Context Forge, it queries the `/tools` endpoint. This returns all available tools with their metadata.
>
> The AI uses this information to:
> 1. **Understand what tools exist** - from the name and description
> 2. **Choose the right tool** - based on the task at hand
> 3. **Construct valid requests** - using the inputSchema
>
> This is the foundation of the MCP protocol - dynamic, standardized tool discovery."

---

## Part 3: Tool Governance

**Scenario Setup:**

The script explains the scenario:
- You discover a bug in the `send_notification` tool
- Or you need to do maintenance
- Or security requires temporarily disabling a capability

**Disabling a Tool:**

```bash
curl -X POST "http://localhost:4444/tools/{tool_id}/state?activate=false" \
  -u admin:changeme
```

**Presenter Script:**

> "This is where centralized governance becomes powerful.
>
> Imagine we discover an issue with the send_notification tool. In a traditional setup, you'd need to:
> - Update code in every AI application
> - Deploy changes
> - Coordinate across teams
>
> With Context Forge, it's one API call. Watch what happens..."

**After Disabling - Verify:**

```bash
curl -s "http://localhost:4444/tools" | jq '.[] | .name'
```

Output:
```
"generate-report"
"search-database"
```

**Presenter Script:**

> "Notice that `send-notification` is no longer in the list.
>
> Any AI client that queries for tools right now will NOT see it. It's completely hidden from discovery.
>
> This is centralized governance in action:
> - **One API call**
> - **Immediate effect**
> - **All AI clients affected**
> - **No code changes required**"

**Re-enabling:**

```bash
curl -X POST "http://localhost:4444/tools/{tool_id}/state?activate=true" \
  -u admin:changeme
```

**Presenter Script:**

> "Once the issue is resolved, re-enabling is just as easy. The tool is immediately visible again to all clients."

---

## Part 4: MCP Server & Gateway Registration

**Architecture Layers Diagram:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CONTEXT FORGE ARCHITECTURE LAYERS                    │
└─────────────────────────────────────────────────────────────────────────┘

Layer 1: TOOLS (Individual capabilities)
════════════════════════════════════════
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ search_db    │  │ send_notif   │  │ gen_report   │
│ (REST Tool)  │  │ (REST Tool)  │  │ (REST Tool)  │
└──────────────┘  └──────────────┘  └──────────────┘

Layer 2: GATEWAYS (Federated MCP Servers)
════════════════════════════════════════════
┌─────────────────────────────────────────────────────────────────────┐
│                      MCP CONTEXT FORGE (Primary)                    │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
            ┌───────────────────┼───────────────────┐
            │                   │                   │
            ▼                   ▼                   ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│  Gateway A       │  │  Gateway B       │  │  Gateway C       │
│  (US-East)       │  │  (EU-West)       │  │  (AP-South)      │
│  - tool_a1       │  │  - tool_b1       │  │  - tool_c1       │
│  - tool_a2       │  │  - tool_b2       │  │  - tool_c2       │
└──────────────────┘  └──────────────────┘  └──────────────────┘

Layer 3: VIRTUAL SERVERS (Composed tool sets)
═══════════════════════════════════════════════
┌──────────────────────────────────────────────────────────────────┐
│  Virtual Server: "finance-tools"                                 │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐                  │
│  │ tool_a1    │  │ tool_b2    │  │ tool_c1    │  (Cherry-picked) │
│  └────────────┘  └────────────┘  └────────────┘                  │
└──────────────────────────────────────────────────────────────────┘
```

**Presenter Script:**

> "So far we've registered individual tools. But Context Forge supports three layers of organization:
>
> **Layer 1: Tools** - Individual capabilities, like we just registered.
>
> **Layer 2: Gateways** - These are federated MCP servers. You can have Context Forge instances in different regions - US-East, EU-West, Asia-Pacific - each with their own tools. They can discover each other and aggregate tools into a unified catalog.
>
> **Layer 3: Virtual Servers** - These let you compose custom tool sets. For example:
> - A 'finance-tools' server with only financial analysis tools
> - An 'hr-tools' server with only HR-related tools
> - A 'public-tools' server with safe tools for external users
>
> Each virtual server gets its own SSE endpoint, perfect for multi-tenant scenarios."

**Gateway Registration Example:**

```bash
curl -X POST "http://localhost:4444/gateways" \
  -u admin:changeme \
  -H "Content-Type: application/json" \
  -d '{
    "gateway": {
      "name": "regional-us-east",
      "url": "http://mcp-server-us-east:4445/sse",
      "transport": "sse",
      "description": "US East regional MCP server"
    }
  }'
```

**Virtual Server Example:**

```bash
curl -X POST "http://localhost:4444/servers" \
  -u admin:changeme \
  -H "Content-Type: application/json" \
  -d '{
    "server": {
      "name": "finance-analysis",
      "description": "Financial analysis tools for analysts",
      "tool_ids": ["tool_id_1", "tool_id_2", "tool_id_3"]
    }
  }'
```

---

## Part 5: Admin UI & API Documentation

**Admin UI Features Diagram:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         ADMIN UI FEATURES                               │
└─────────────────────────────────────────────────────────────────────────┘

┌────────────────┐  ┌────────────────┐  ┌────────────────┐  ┌────────────┐
│   Dashboard    │  │    Tools       │  │   Gateways     │  │    Logs    │
│                │  │                │  │                │  │            │
│  • Statistics  │  │  • List/CRUD   │  │  • Federation  │  │  • Search  │
│  • Health      │  │  • Enable/     │  │  • Health      │  │  • Filter  │
│  • Activity    │  │    Disable     │  │  • Refresh     │  │  • Export  │
└────────────────┘  └────────────────┘  └────────────────┘  └────────────┘
```

**Presenter Script:**

> "Context Forge includes a web-based Admin UI for visual management.
>
> The **Dashboard** shows statistics, health status, and recent activity.
>
> The **Tools** section lets you list, create, update, and delete tools - plus enable or disable them with a single click.
>
> The **Gateways** section manages federation with other MCP servers.
>
> The **Logs** section provides searchable, filterable logs for troubleshooting.
>
> You can access these at:
> - Admin UI: `http://localhost:4444/admin`
> - API Docs: `http://localhost:4444/docs`"

---

## Summary

The demo concludes with key takeaways:

**1. TOOL REGISTRATION**
- Register tools with name, description, and inputSchema
- Tools become immediately discoverable by AI clients
- JSON Schema defines parameter validation

**2. TOOL DISCOVERY**
- AI clients query `/tools` to discover available capabilities
- Each tool includes schema for AI reasoning
- Only enabled tools are returned (governance in action)

**3. CENTRALIZED GOVERNANCE**
- Enable/disable tools with a single API call
- Changes are immediate - no deployments needed
- Affects all AI clients simultaneously

**4. FEDERATION & VIRTUAL SERVERS**
- Register external MCP servers as gateways
- Create virtual servers for custom tool compositions
- Support multi-region, multi-tenant architectures

**5. ADMIN UI & OBSERVABILITY**
- Web-based management at `/admin`
- Full API documentation at `/docs`
- Metrics, logging, and tracing built-in

---

## Resources

**Links displayed at end of demo:**

- GitHub: https://github.com/IBM/mcp-context-forge
- Documentation: https://ibm.github.io/mcp-context-forge
- PyPI: `pip install mcp-contextforge-gateway`

---

## Troubleshooting

### Server Won't Start
```bash
# Check port availability
lsof -i :4444

# Check Python environment
python --version  # Should be 3.11+
```

### Demo Script Issues
```bash
# Set TERM if "clear" command fails
export TERM=xterm
bash demo.sh
```

### Database Issues
```bash
# Reset database
rm -f mcp.db
# Restart server
```

### API Returns 401
```bash
# Default credentials
Username: admin
Password: changeme

# Or check .env file
grep BASIC_AUTH .env
```

### jq Not Installed
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq

# RHEL/CentOS
sudo yum install jq
```

---

## Post-Demo Cleanup

```bash
# Stop the server (Ctrl+C in Terminal 1)

# Remove demo database
rm -f mcp.db

# Or if using Docker
docker stop mcp-context-forge
```
