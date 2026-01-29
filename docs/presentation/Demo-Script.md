# Demo Script: MCP Context Forge Live Demonstration

**Duration:** 5 minutes
**Prerequisites:** MCP Context Forge running with sample tools registered

---

## Pre-Demo Setup (Before Presentation)

### 1. Start MCP Context Forge

```bash
# Option A: PyPI installation
pip install mcp-contextforge-gateway
mcpgateway serve

# Option B: Docker
docker run -p 4444:4444 \
  -e MCPGATEWAY_UI_ENABLED=true \
  -e AUTH_REQUIRED=false \
  ghcr.io/ibm/mcp-context-forge:latest

# Option C: From source
make dev
```

### 2. Register Sample Tools

```bash
# Set base URL
export MCPGATEWAY_URL="http://localhost:4444"

# Register a sample search tool
curl -X POST "$MCPGATEWAY_URL/tools" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "search_database",
    "description": "Search the enterprise database for records matching a query",
    "inputSchema": {
      "type": "object",
      "properties": {
        "query": {"type": "string", "description": "Search query"},
        "limit": {"type": "integer", "description": "Maximum results", "default": 10}
      },
      "required": ["query"]
    }
  }'

# Register a notification tool
curl -X POST "$MCPGATEWAY_URL/tools" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "send_notification",
    "description": "Send a notification to specified recipients",
    "inputSchema": {
      "type": "object",
      "properties": {
        "recipients": {"type": "array", "items": {"type": "string"}},
        "message": {"type": "string"},
        "priority": {"type": "string", "enum": ["low", "normal", "high"]}
      },
      "required": ["recipients", "message"]
    }
  }'

# Register a document tool
curl -X POST "$MCPGATEWAY_URL/tools" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "generate_report",
    "description": "Generate a formatted report from provided data",
    "inputSchema": {
      "type": "object",
      "properties": {
        "title": {"type": "string"},
        "data": {"type": "object"},
        "format": {"type": "string", "enum": ["pdf", "html", "markdown"]}
      },
      "required": ["title", "data"]
    }
  }'
```

### 3. Browser Tabs Prepared

- **Tab 1:** Admin UI at `http://localhost:4444/ui`
- **Tab 2:** API docs at `http://localhost:4444/docs`
- **Tab 3:** Terminal for curl commands

---

## Demo Flow (5 Minutes)

### Part 1: Admin UI Overview (1 minute)

**What to Show:**
- Main dashboard with tool/resource/prompt counts
- Navigation menu

**Script:**

> Let me show you the MCP Context Forge Admin UI.
>
> [Navigate to localhost:4444/ui]
>
> This is our central dashboard. You can see at a glance how many tools, resources, and prompts are registered in the system.
>
> The navigation on the left provides access to each entity type—servers, tools, resources, prompts—as well as gateways for federation and logs for troubleshooting.
>
> Let's look at the tools we have registered.

**Click:** Tools menu item

> Here we see all registered tools. Each tool has a name, description, and current status—active or inactive.
>
> Notice the actions column—we can view details, edit, or toggle the active state for any tool.

---

### Part 2: Tool Discovery via API (2 minutes)

**What to Show:**
- API endpoint for listing tools
- JSON response structure

**Script:**

> Now let's see how an AI client would discover these tools.
>
> [Switch to terminal]
>
> When an AI client connects to Context Forge, it uses the standard MCP protocol to list available tools. Let me show you the HTTP equivalent.

**Execute:**
```bash
curl -s http://localhost:4444/tools | jq '.'
```

> This returns all active tools in MCP-compliant format. Each tool includes its name, description, and input schema—everything an AI needs to understand how to use it.
>
> Notice the inputSchema for each tool. This follows JSON Schema format, so the AI knows exactly what parameters are required and their types.

**Execute:**
```bash
curl -s http://localhost:4444/tools | jq '.[] | {name, description}'
```

> Let me simplify that view. We have three tools: search_database, send_notification, and generate_report.
>
> An AI agent can discover these tools, understand their purpose from the description, and invoke them with properly structured parameters.

---

### Part 3: Tool Governance - Disable a Tool (1.5 minutes)

**What to Show:**
- Disabling a tool in the UI
- Immediate effect on API response

**Script:**

> Now here's where governance becomes powerful.
>
> Imagine we discover an issue with the send_notification tool—maybe there's a bug, or we need to do maintenance.
>
> [Switch to Admin UI - Tools page]
>
> I'll disable this tool by clicking the toggle.

**Click:** Toggle for send_notification tool to inactive

> Notice it's now marked as inactive. This change is immediate—no deployment, no restart, no code changes.
>
> Let's verify from the API.

**Execute:**
```bash
curl -s http://localhost:4444/tools | jq '.[] | {name, description}'
```

> See? The send_notification tool no longer appears. Any AI client that queries for available tools will not see it.
>
> This is centralized governance in action. One toggle in the admin UI, and the tool is hidden from all AI systems across your organization.

---

### Part 4: Re-enable and Verify (30 seconds)

**Script:**

> Of course, once the issue is resolved, we can re-enable just as easily.

**Click:** Toggle for send_notification tool back to active

> And if we query again...

**Execute:**
```bash
curl -s http://localhost:4444/tools | jq '.[] | .name'
```

> All three tools are available again.
>
> This entire workflow—discover, disable, re-enable—happened without touching any AI client code or configuration. That's the power of centralized tool governance.

**[Return to presentation slides]**

---

## Extended Demo Options (If Time Permits)

### Federation Demo (Additional 2-3 minutes)

**Setup Required:**
- Second Context Forge instance on port 4445
- Different tools registered on second instance

**Commands:**
```bash
# Register second instance as a gateway
curl -X POST "http://localhost:4444/gateways" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "regional-gateway",
    "url": "http://localhost:4445/sse",
    "transport": "sse"
  }'

# Refresh to pull tools from federated gateway
curl -X POST "http://localhost:4444/gateways/{gateway_id}/refresh"

# Show aggregated tools
curl -s http://localhost:4444/tools | jq '.[] | .name'
```

**Script:**

> Let me show federation. I have a second Context Forge instance running that represents a regional gateway with its own tools.
>
> I'll register it as a peer gateway...
>
> Now when I list tools, I see tools from both gateways—the local ones and the federated ones—all discoverable through a single endpoint.

---

### Tool Invocation Demo (Additional 2 minutes)

**Commands:**
```bash
# Invoke a tool
curl -X POST "http://localhost:4444/tools/invoke" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "search_database",
      "arguments": {
        "query": "enterprise customers",
        "limit": 5
      }
    }
  }'
```

**Script:**

> Let me show an actual tool invocation. This is how an AI would call a tool through Context Forge.
>
> The request uses JSON-RPC 2.0 format as specified by MCP. We specify the tool name and arguments.
>
> [Execute command]
>
> The response includes the result from the tool, plus metadata like execution time and request ID for tracing.

---

## Backup Commands

If demo environment has issues, use these to recover:

```bash
# Check if service is running
curl http://localhost:4444/health

# View logs
docker logs mcp-context-forge

# Restart service
docker restart mcp-context-forge

# Or for local development
make dev
```

---

## Demo Environment Variables

```bash
# Development settings for demo
export HOST=0.0.0.0
export PORT=4444
export DATABASE_URL=sqlite:///./demo.db
export MCPGATEWAY_UI_ENABLED=true
export AUTH_REQUIRED=false
export LOG_LEVEL=INFO
export RELOAD=false
```

---

## Post-Demo Cleanup

```bash
# Remove demo database
rm -f demo.db

# Stop containers
docker stop mcp-context-forge

# Or for development
# Ctrl+C in terminal running the server
```

---

## Troubleshooting

### Service Won't Start
```bash
# Check port availability
lsof -i :4444

# Check Python environment
which python
python --version  # Should be 3.11+
```

### Database Issues
```bash
# Reset database
rm -f mcp.db
mcpgateway serve  # Will recreate
```

### UI Not Loading
```bash
# Verify UI is enabled
curl http://localhost:4444/health | jq '.features.ui_enabled'
```

### API Returns 401
```bash
# Disable auth for demo if needed
export AUTH_REQUIRED=false
# Restart service
```
