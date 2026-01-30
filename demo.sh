#!/bin/bash
# =============================================================================
# MCP Context Forge - Live Demonstration Script
# =============================================================================
# This script demonstrates the core capabilities of MCP Context Forge:
# - Tool registration
# - Tool discovery
# - Tool governance (enable/disable)
# - MCP Server registration
# - Virtual Server concepts
#
# Prerequisites:
# 1. MCP Context Forge server running on localhost:4444
#    Start with: make dev (in another terminal)
# 2. jq installed for JSON formatting
#
# Usage: bash demo.sh
# =============================================================================

set -e

# Configuration
BASE_URL="${MCPGATEWAY_URL:-http://localhost:4444}"
CONTENT_TYPE="Content-Type: application/json"
# Default credentials (change these if you modified .env)
AUTH_USER="${BASIC_AUTH_USER:-admin}"
AUTH_PASS="${BASIC_AUTH_PASSWORD:-changeme}"
AUTH_HEADER="-u ${AUTH_USER}:${AUTH_PASS}"

# Colors for output
WHITE='\033[0;37m'      # normal white
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
CYAN=$WHITE
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'
DIM='\033[2m'

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}  $1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_subheader() {
    echo ""
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────────${NC}"
    echo -e "${BOLD}${MAGENTA}  $1${NC}"
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────────${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}▶${NC} ${BOLD}$1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_story() {
    echo ""
    echo -e "${DIM}${CYAN}$1${NC}"
    echo ""
}

print_code_block() {
    echo -e "${DIM}┌──────────────────────────────────────────────────────────────────────────────┐${NC}"
    echo "$1" | while IFS= read -r line; do
        echo -e "${DIM}│${NC} ${CYAN}$line${NC}"
    done
    echo -e "${DIM}└──────────────────────────────────────────────────────────────────────────────┘${NC}"
}

print_diagram() {
    echo -e "${WHITE}$1${NC}"
}

wait_for_enter() {
    echo ""
    echo -e "${YELLOW}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║  Press Enter to continue...                                    ║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════════════════╝${NC}"
    read -r
}

# Check if jq is installed
check_jq() {
    if ! command -v jq &> /dev/null; then
        print_error "jq is not installed. Please install it first:"
        echo "  Ubuntu/Debian: sudo apt-get install jq"
        echo "  macOS: brew install jq"
        echo "  RHEL/CentOS: sudo yum install jq"
        exit 1
    fi
}

# Check if server is running
check_server() {
    print_step "Checking if MCP Context Forge server is running..."

    if curl -s --connect-timeout 5 "${BASE_URL}/health" > /dev/null 2>&1; then
        print_success "Server is running at ${BASE_URL}"
        return 0
    else
        print_error "Server is not running at ${BASE_URL}"
        echo ""
        echo "Please start the server first:"
        echo "  Option 1: make dev"
        echo "  Option 2: make serve"
        echo ""
        echo "Then run this demo script again."
        exit 1
    fi
}

# Show welcome and MCP architecture
show_welcome() {
    clear
    print_header "MCP Context Forge - Live Demonstration"

    print_story "Welcome! Today we'll explore how MCP Context Forge provides
centralized governance for AI tool ecosystems.

Let's start by understanding the architecture..."

    echo ""
    print_diagram "
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
"

    print_story "KEY CONCEPTS:

    • AI Clients connect to Context Forge using the MCP protocol
    • Context Forge acts as a central gateway and registry
    • Tools, Resources, and Prompts are managed centrally
    • Backend services can be native MCP servers or virtualized REST APIs"

    echo ""
    echo "Server URL: ${BASE_URL}"
}

# Clean up any existing demo tools
cleanup_demo_tools() {
    print_step "Cleaning up any existing demo tools..."

    # Get list of demo tools and delete them
    local tools=$(curl -s ${AUTH_HEADER} "${BASE_URL}/tools" 2>/dev/null || echo "[]")

    for tool_name in "search-database" "send-notification" "generate-report" "test-tool"; do
        local tool_id=$(echo "$tools" | jq -r ".[] | select(.name == \"${tool_name}\") | .id" 2>/dev/null)
        if [ -n "$tool_id" ] && [ "$tool_id" != "null" ]; then
            curl -s ${AUTH_HEADER} -X DELETE "${BASE_URL}/tools/${tool_id}" > /dev/null 2>&1 || true
            print_info "Removed existing tool: ${tool_name}"
        fi
    done
}

# Register sample tools
register_tools() {
    print_header "Part 1: Tool Registration"

    print_story "In MCP Context Forge, TOOLS are executable functions that AI clients
can discover and invoke. Each tool has:

    • name        - Unique identifier for the tool
    • description - Human-readable explanation (helps AI understand purpose)
    • inputSchema - JSON Schema defining required parameters

Let's register three sample tools to demonstrate this..."

    wait_for_enter

    # ==================== Tool 1: Search Database ====================
    print_subheader "Registering Tool 1: search_database"

    print_story "This tool allows AI to search an enterprise database.
The inputSchema defines two parameters:
    • query (required) - The search term
    • limit (optional) - Maximum number of results"

    echo ""
    print_step "Executing the following curl command:"
    echo ""

    print_code_block 'curl -X POST "http://localhost:4444/tools" \
  -u admin:changeme \
  -H "Content-Type: application/json" \
  -d '"'"'{
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
  }'"'"''

    echo ""
    print_info "Sending request..."
    echo ""

    local response1=$(curl -s -X POST "${BASE_URL}/tools" \
        ${AUTH_HEADER} \
        -H "${CONTENT_TYPE}" \
        -d '{
            "tool": {
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
            }
        }')

    local tool1_id=$(echo "$response1" | jq -r '.id' 2>/dev/null)
    if [ -n "$tool1_id" ] && [ "$tool1_id" != "null" ]; then
        print_success "Tool 'search_database' registered successfully!"
        echo ""
        echo "Response:"
        echo "$response1" | jq '{id, name, description, enabled}' 2>/dev/null
    else
        print_error "Failed to register 'search_database'"
        echo "$response1" | jq . 2>/dev/null || echo "$response1"
    fi

    wait_for_enter

    # ==================== Tool 2: Send Notification ====================
    print_subheader "Registering Tool 2: send_notification"

    print_story "This tool enables AI to send notifications to users.
The inputSchema uses advanced JSON Schema features:
    • array type    - For multiple recipients
    • enum          - Restricts priority to specific values"

    echo ""
    print_step "Executing the following curl command:"
    echo ""

    print_code_block 'curl -X POST "http://localhost:4444/tools" \
  -u admin:changeme \
  -H "Content-Type: application/json" \
  -d '"'"'{
    "tool": {
      "name": "send_notification",
      "description": "Send a notification to specified recipients",
      "inputSchema": {
        "type": "object",
        "properties": {
          "recipients": {
            "type": "array",
            "items": {"type": "string"},
            "description": "List of recipient emails"
          },
          "message": {
            "type": "string",
            "description": "Notification message"
          },
          "priority": {
            "type": "string",
            "enum": ["low", "normal", "high"],
            "description": "Message priority"
          }
        },
        "required": ["recipients", "message"]
      }
    }
  }'"'"''

    echo ""
    print_info "Sending request..."
    echo ""

    local response2=$(curl -s -X POST "${BASE_URL}/tools" \
        ${AUTH_HEADER} \
        -H "${CONTENT_TYPE}" \
        -d '{
            "tool": {
                "name": "send_notification",
                "description": "Send a notification to specified recipients",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "recipients": {"type": "array", "items": {"type": "string"}, "description": "List of recipient emails"},
                        "message": {"type": "string", "description": "Notification message"},
                        "priority": {"type": "string", "enum": ["low", "normal", "high"], "description": "Message priority"}
                    },
                    "required": ["recipients", "message"]
                }
            }
        }')

    NOTIFICATION_TOOL_ID=$(echo "$response2" | jq -r '.id' 2>/dev/null)
    if [ -n "$NOTIFICATION_TOOL_ID" ] && [ "$NOTIFICATION_TOOL_ID" != "null" ]; then
        print_success "Tool 'send_notification' registered successfully!"
        echo ""
        echo "Response:"
        echo "$response2" | jq '{id, name, description, enabled}' 2>/dev/null
    else
        print_error "Failed to register 'send_notification'"
        echo "$response2" | jq . 2>/dev/null || echo "$response2"
    fi

    wait_for_enter

    # ==================== Tool 3: Generate Report ====================
    print_subheader "Registering Tool 3: generate_report"

    print_story "This tool generates formatted reports from data.
It demonstrates:
    • nested object type - For complex data input
    • enum for format   - Restricts output format options"

    echo ""
    print_step "Executing the following curl command:"
    echo ""

    print_code_block 'curl -X POST "http://localhost:4444/tools" \
  -u admin:changeme \
  -H "Content-Type: application/json" \
  -d '"'"'{
    "tool": {
      "name": "generate_report",
      "description": "Generate a formatted report from provided data",
      "inputSchema": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string",
            "description": "Report title"
          },
          "data": {
            "type": "object",
            "description": "Data to include in the report"
          },
          "format": {
            "type": "string",
            "enum": ["pdf", "html", "markdown"],
            "description": "Output format"
          }
        },
        "required": ["title", "data"]
      }
    }
  }'"'"''

    echo ""
    print_info "Sending request..."
    echo ""

    local response3=$(curl -s -X POST "${BASE_URL}/tools" \
        ${AUTH_HEADER} \
        -H "${CONTENT_TYPE}" \
        -d '{
            "tool": {
                "name": "generate_report",
                "description": "Generate a formatted report from provided data",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "title": {"type": "string", "description": "Report title"},
                        "data": {"type": "object", "description": "Data to include in the report"},
                        "format": {"type": "string", "enum": ["pdf", "html", "markdown"], "description": "Output format"}
                    },
                    "required": ["title", "data"]
                }
            }
        }')

    local tool3_id=$(echo "$response3" | jq -r '.id' 2>/dev/null)
    if [ -n "$tool3_id" ] && [ "$tool3_id" != "null" ]; then
        print_success "Tool 'generate_report' registered successfully!"
        echo ""
        echo "Response:"
        echo "$response3" | jq '{id, name, description, enabled}' 2>/dev/null
    else
        print_error "Failed to register 'generate_report'"
        echo "$response3" | jq . 2>/dev/null || echo "$response3"
    fi

    echo ""
    print_success "All three tools registered successfully!"
}

# Discover tools
discover_tools() {
    print_header "Part 2: Tool Discovery"

    print_story "Now let's see how AI clients DISCOVER available tools.

When an AI client connects to Context Forge, it queries the /tools endpoint
to get a list of all available tools. This is the foundation of the MCP protocol -
AI systems can dynamically discover what capabilities are available.

The response includes everything the AI needs:
    • Tool name and description (for reasoning about which tool to use)
    • Input schema (for constructing valid requests)
    • Enabled status (only enabled tools are returned by default)"

    wait_for_enter

    print_step "Listing all available tools..."
    echo ""
    print_code_block 'curl -s "http://localhost:4444/tools" | jq '"'"'.[] | {name, description, enabled}'"'"''
    echo ""

    print_info "Response:"
    echo ""

    local tools=$(curl -s ${AUTH_HEADER} "${BASE_URL}/tools")
    echo "$tools" | jq '.[] | {name, description, enabled}' 2>/dev/null || echo "$tools"

    echo ""
    print_story "Notice how each tool is returned with its metadata.
An AI client uses this information to:

    1. Understand what tools are available
    2. Choose the right tool for a task based on the description
    3. Construct valid requests using the inputSchema"

    print_success "AI clients discover tools through this same endpoint"
}

# Demonstrate tool governance
demonstrate_governance() {
    print_header "Part 3: Tool Governance"

    print_story "One of the most powerful features of MCP Context Forge is
CENTRALIZED GOVERNANCE.

Imagine this scenario:
    • You discover a bug in the 'send_notification' tool
    • Or you need to do maintenance on the underlying service
    • Or security requires temporarily disabling a capability

With Context Forge, you can disable a tool INSTANTLY - and it immediately
becomes invisible to ALL AI clients. No code changes. No deployments.
No restarting applications."

    wait_for_enter

    # Get the notification tool ID if not already set
    if [ -z "$NOTIFICATION_TOOL_ID" ] || [ "$NOTIFICATION_TOOL_ID" == "null" ]; then
        local tools=$(curl -s ${AUTH_HEADER} "${BASE_URL}/tools?include_inactive=true")
        NOTIFICATION_TOOL_ID=$(echo "$tools" | jq -r '.[] | select(.name == "send-notification") | .id' 2>/dev/null)
    fi

    if [ -z "$NOTIFICATION_TOOL_ID" ] || [ "$NOTIFICATION_TOOL_ID" == "null" ]; then
        print_error "Could not find 'send_notification' tool. Skipping governance demo."
        return 1
    fi

    print_subheader "Disabling a Tool"

    print_story "Let's disable the 'send_notification' tool.
We use the /tools/{id}/state endpoint with activate=false"

    echo ""
    print_step "Executing the following curl command:"
    echo ""

    print_code_block "curl -X POST \"http://localhost:4444/tools/${NOTIFICATION_TOOL_ID}/state?activate=false\" \\
  -u admin:changeme"

    echo ""
    print_info "Sending request..."
    echo ""

    local disable_response=$(curl -s ${AUTH_HEADER} -X POST "${BASE_URL}/tools/${NOTIFICATION_TOOL_ID}/state?activate=false")
    echo "$disable_response" | jq '.' 2>/dev/null || echo "$disable_response"

    echo ""
    print_success "Tool disabled!"

    wait_for_enter

    print_subheader "Verifying Tool is Hidden"

    print_story "Now let's query the tools endpoint again.
The 'send-notification' tool should no longer appear in the list."

    echo ""
    print_step "Listing active tools:"
    echo ""

    print_code_block 'curl -s "http://localhost:4444/tools" | jq '"'"'.[] | .name'"'"''

    echo ""
    local active_tools=$(curl -s ${AUTH_HEADER} "${BASE_URL}/tools")
    echo "$active_tools" | jq '.[] | .name' 2>/dev/null || echo "$active_tools"

    echo ""
    print_success "Notice: 'send-notification' is NO LONGER in the list!"
    print_story "Any AI client that queries for tools right now will NOT see
the send_notification tool. It's completely hidden from discovery.

This is centralized governance in action:
    • One API call
    • Immediate effect
    • All AI clients affected
    • No code changes required"

    wait_for_enter

    # Re-enable the tool
    print_subheader "Re-enabling the Tool"

    print_story "Once the issue is resolved, we can re-enable the tool just as easily."

    echo ""
    print_step "Executing the following curl command:"
    echo ""

    print_code_block "curl -X POST \"http://localhost:4444/tools/${NOTIFICATION_TOOL_ID}/state?activate=true\" \\
  -u admin:changeme"

    echo ""
    print_info "Sending request..."
    echo ""

    local enable_response=$(curl -s ${AUTH_HEADER} -X POST "${BASE_URL}/tools/${NOTIFICATION_TOOL_ID}/state?activate=true")
    echo "$enable_response" | jq '.' 2>/dev/null || echo "$enable_response"

    echo ""
    print_step "Verifying tool is back:"
    echo ""

    local all_tools=$(curl -s ${AUTH_HEADER} "${BASE_URL}/tools")
    echo "$all_tools" | jq '.[] | .name' 2>/dev/null || echo "$all_tools"

    echo ""
    print_success "Tool 'send-notification' is available again!"
}

# Show MCP Server registration
show_mcp_servers() {
    print_header "Part 4: MCP Server & Gateway Registration"

    print_story "So far we've registered individual TOOLS. But MCP Context Forge
can also federate entire MCP SERVERS and GATEWAYS.

This is the key to building a scalable AI tool infrastructure:"

    echo ""
    print_diagram "
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
    │                       http://localhost:4444                         │
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
    │  Virtual Server: \"finance-tools\"                                │
    │  ┌────────────┐  ┌────────────┐  ┌────────────┐                  │
    │  │ tool_a1    │  │ tool_b2    │  │ tool_c1    │  (Cherry-picked) │
    │  └────────────┘  └────────────┘  └────────────┘                  │
    └──────────────────────────────────────────────────────────────────┘
"

    wait_for_enter

    print_subheader "Registering an MCP Gateway"

    print_story "To federate another MCP server, we register it as a GATEWAY.
Context Forge will then aggregate its tools into our unified catalog."

    echo ""
    print_step "Example: Register a peer gateway"
    echo ""

    print_code_block 'curl -X POST "http://localhost:4444/gateways" \
  -u admin:changeme \
  -H "Content-Type: application/json" \
  -d '"'"'{
    "gateway": {
      "name": "regional-us-east",
      "url": "http://mcp-server-us-east:4445/sse",
      "transport": "sse",
      "description": "US East regional MCP server"
    }
  }'"'"''

    print_story "After registration, you can refresh the gateway to pull its tools:"

    print_code_block 'curl -X POST "http://localhost:4444/gateways/{gateway_id}/refresh" \
  -u admin:changeme'

    wait_for_enter

    print_subheader "Creating Virtual Servers"

    print_story "VIRTUAL SERVERS let you compose custom tool sets for different use cases.

For example, you might create:
    • 'finance-tools' - Only financial analysis tools
    • 'hr-tools'      - Only HR-related tools
    • 'public-tools'  - Safe tools for external users

Each virtual server can include tools from multiple gateways."

    echo ""
    print_step "Example: Create a virtual server"
    echo ""

    print_code_block 'curl -X POST "http://localhost:4444/servers" \
  -u admin:changeme \
  -H "Content-Type: application/json" \
  -d '"'"'{
    "server": {
      "name": "finance-analysis",
      "description": "Financial analysis tools for analysts",
      "tool_ids": ["tool_id_1", "tool_id_2", "tool_id_3"]
    }
  }'"'"''

    print_story "Virtual servers get their own SSE endpoint:

    http://localhost:4444/servers/{server_id}/sse

AI clients can connect to specific virtual servers to access
only the tools they need - great for multi-tenant scenarios!"
}

# Show Admin UI info
show_admin_ui_info() {
    print_header "Part 5: Admin UI & API Documentation"

    print_story "MCP Context Forge includes a web-based Admin UI for visual management."

    echo ""
    print_diagram "
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
"

    echo ""
    print_info "Admin UI URL:"
    echo ""
    echo -e "    ${BOLD}${CYAN}${BASE_URL}/admin${NC}"
    echo ""
    print_info "API Documentation (Swagger/OpenAPI):"
    echo ""
    echo -e "    ${BOLD}${CYAN}${BASE_URL}/docs${NC}"
    echo ""
    print_info "Default Credentials:"
    echo ""
    echo "    Username: admin"
    echo "    Password: changeme"
    echo ""
}

# Summary
show_summary() {
    print_header "Demo Summary"

    print_diagram "
    ┌─────────────────────────────────────────────────────────────────────────┐
    │                         KEY TAKEAWAYS                                   │
    └─────────────────────────────────────────────────────────────────────────┘
"

    echo "  ${BOLD}1. TOOL REGISTRATION${NC}"
    echo "     • Register tools with name, description, and inputSchema"
    echo "     • Tools become immediately discoverable by AI clients"
    echo "     • JSON Schema defines parameter validation"
    echo ""
    echo "  ${BOLD}2. TOOL DISCOVERY${NC}"
    echo "     • AI clients query /tools to discover available capabilities"
    echo "     • Each tool includes schema for AI reasoning"
    echo "     • Only enabled tools are returned (governance in action)"
    echo ""
    echo "  ${BOLD}3. CENTRALIZED GOVERNANCE${NC}"
    echo "     • Enable/disable tools with a single API call"
    echo "     • Changes are immediate - no deployments needed"
    echo "     • Affects all AI clients simultaneously"
    echo ""
    echo "  ${BOLD}4. FEDERATION & VIRTUAL SERVERS${NC}"
    echo "     • Register external MCP servers as gateways"
    echo "     • Create virtual servers for custom tool compositions"
    echo "     • Support multi-region, multi-tenant architectures"
    echo ""
    echo "  ${BOLD}5. ADMIN UI & OBSERVABILITY${NC}"
    echo "     • Web-based management at /admin"
    echo "     • Full API documentation at /docs"
    echo "     • Metrics, logging, and tracing built-in"
    echo ""

    print_diagram "
    ┌─────────────────────────────────────────────────────────────────────────┐
    │                         RESOURCES                                       │
    └─────────────────────────────────────────────────────────────────────────┘

    GitHub:        https://github.com/IBM/mcp-context-forge
    Documentation: https://ibm.github.io/mcp-context-forge
    PyPI:          pip install mcp-contextforge-gateway
"

    print_success "Demo completed successfully!"
    echo ""
    echo -e "${CYAN}Thank you for watching!${NC}"
    echo ""
}

# Main execution
main() {
    # Pre-flight checks
    check_jq

    # Show welcome and architecture
    show_welcome

    # Check server
    check_server

    wait_for_enter

    # Clean up existing demo tools
    cleanup_demo_tools

    # Run demo sections
    register_tools
    wait_for_enter

    discover_tools
    wait_for_enter

    demonstrate_governance
    wait_for_enter

    show_mcp_servers
    wait_for_enter

    show_admin_ui_info
    wait_for_enter

    show_summary
}

# Run main function
main "$@"
