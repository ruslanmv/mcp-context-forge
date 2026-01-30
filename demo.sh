#!/bin/bash
# =============================================================================
# MCP Context Forge - Live Demonstration Script
# =============================================================================
# This script demonstrates the core capabilities of MCP Context Forge:
# - Tool registration
# - Tool discovery
# - Tool governance (enable/disable)
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
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}  $1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
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

print_command() {
    echo -e "${CYAN}$ $1${NC}"
}

wait_for_enter() {
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
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

    print_step "Registering sample tools..."
    echo ""

    # Tool 1: Search Database
    print_info "Registering 'search_database' tool..."
    print_command "curl -X POST ${BASE_URL}/tools -H 'Content-Type: application/json' -d '{\"tool\": {...}}'"

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
        print_success "Tool 'search_database' registered (ID: ${tool1_id})"
    else
        print_error "Failed to register 'search_database'"
        echo "$response1" | jq . 2>/dev/null || echo "$response1"
    fi
    echo ""

    # Tool 2: Send Notification
    print_info "Registering 'send_notification' tool..."
    print_command "curl -X POST ${BASE_URL}/tools -H 'Content-Type: application/json' -d '{\"tool\": {...}}'"

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
        print_success "Tool 'send_notification' registered (ID: ${NOTIFICATION_TOOL_ID})"
    else
        print_error "Failed to register 'send_notification'"
        echo "$response2" | jq . 2>/dev/null || echo "$response2"
    fi
    echo ""

    # Tool 3: Generate Report
    print_info "Registering 'generate_report' tool..."
    print_command "curl -X POST ${BASE_URL}/tools -H 'Content-Type: application/json' -d '{\"tool\": {...}}'"

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
        print_success "Tool 'generate_report' registered (ID: ${tool3_id})"
    else
        print_error "Failed to register 'generate_report'"
        echo "$response3" | jq . 2>/dev/null || echo "$response3"
    fi
    echo ""

    print_success "All sample tools registered successfully!"
}

# Discover tools
discover_tools() {
    print_header "Part 2: Tool Discovery"

    print_step "Listing all available tools..."
    print_command "curl -s ${BASE_URL}/tools | jq '.[] | {name, description, enabled}'"
    echo ""

    local tools=$(curl -s ${AUTH_HEADER} "${BASE_URL}/tools")
    echo "$tools" | jq '.[] | {name, description, enabled}' 2>/dev/null || echo "$tools"

    echo ""
    print_success "AI clients discover tools through this same endpoint"
    print_info "Each tool includes name, description, and inputSchema for AI reasoning"
}

# Demonstrate tool governance
demonstrate_governance() {
    print_header "Part 3: Tool Governance"

    # Get the notification tool ID if not already set
    # Note: The API slugifies tool names (underscores become dashes)
    if [ -z "$NOTIFICATION_TOOL_ID" ] || [ "$NOTIFICATION_TOOL_ID" == "null" ]; then
        local tools=$(curl -s ${AUTH_HEADER} "${BASE_URL}/tools?include_inactive=true")
        NOTIFICATION_TOOL_ID=$(echo "$tools" | jq -r '.[] | select(.name == "send-notification") | .id' 2>/dev/null)
    fi

    if [ -z "$NOTIFICATION_TOOL_ID" ] || [ "$NOTIFICATION_TOOL_ID" == "null" ]; then
        print_error "Could not find 'send_notification' tool. Skipping governance demo."
        return 1
    fi

    print_step "Disabling 'send_notification' tool..."
    print_command "curl -X POST '${BASE_URL}/tools/${NOTIFICATION_TOOL_ID}/state?activate=false'"
    echo ""

    local disable_response=$(curl -s ${AUTH_HEADER} -X POST "${BASE_URL}/tools/${NOTIFICATION_TOOL_ID}/state?activate=false")
    echo "$disable_response" | jq '{status, message}' 2>/dev/null || echo "$disable_response"

    echo ""
    print_info "Now let's verify the tool is no longer visible to clients..."
    print_command "curl -s ${BASE_URL}/tools | jq '.[] | .name'"
    echo ""

    local active_tools=$(curl -s ${AUTH_HEADER} "${BASE_URL}/tools")
    echo "$active_tools" | jq '.[] | .name' 2>/dev/null || echo "$active_tools"

    echo ""
    print_success "Notice: 'send-notification' is no longer in the list!"
    print_info "This demonstrates centralized governance - disable once, affects all AI clients"

    wait_for_enter

    # Re-enable the tool
    print_step "Re-enabling 'send_notification' tool..."
    print_command "curl -X POST '${BASE_URL}/tools/${NOTIFICATION_TOOL_ID}/state?activate=true'"
    echo ""

    local enable_response=$(curl -s ${AUTH_HEADER} -X POST "${BASE_URL}/tools/${NOTIFICATION_TOOL_ID}/state?activate=true")
    echo "$enable_response" | jq '{status, message}' 2>/dev/null || echo "$enable_response"

    echo ""
    print_info "Verifying tool is back in the list..."
    print_command "curl -s ${BASE_URL}/tools | jq '.[] | .name'"
    echo ""

    local all_tools=$(curl -s ${AUTH_HEADER} "${BASE_URL}/tools")
    echo "$all_tools" | jq '.[] | .name' 2>/dev/null || echo "$all_tools"

    echo ""
    print_success "Tool 'send-notification' is available again!"
}

# Show Admin UI info
show_admin_ui_info() {
    print_header "Part 4: Admin UI"

    print_info "The Admin UI is available at:"
    echo ""
    echo -e "    ${BOLD}${BASE_URL}/admin${NC}"
    echo ""
    print_info "Features:"
    echo "    - Dashboard with tool/resource/prompt counts"
    echo "    - Tool management (CRUD operations)"
    echo "    - Real-time activity monitoring"
    echo "    - Log viewer with filtering"
    echo ""
    print_info "API Documentation is available at:"
    echo ""
    echo -e "    ${BOLD}${BASE_URL}/docs${NC}"
    echo ""
}

# Summary
show_summary() {
    print_header "Demo Summary"

    echo "This demonstration showed:"
    echo ""
    echo "  1. ${BOLD}Tool Registration${NC}"
    echo "     - Register tools with name, description, and inputSchema"
    echo "     - Tools become immediately discoverable"
    echo ""
    echo "  2. ${BOLD}Tool Discovery${NC}"
    echo "     - AI clients query /tools to discover available tools"
    echo "     - Each tool includes schema for AI reasoning"
    echo ""
    echo "  3. ${BOLD}Tool Governance${NC}"
    echo "     - Disable tools centrally without touching AI clients"
    echo "     - Re-enable tools instantly when ready"
    echo "     - No deployment or restart required"
    echo ""
    echo "  4. ${BOLD}Admin UI${NC}"
    echo "     - Web-based management at ${BASE_URL}/admin"
    echo "     - API documentation at ${BASE_URL}/docs"
    echo ""
    print_success "Demo completed successfully!"
}

# Main execution
main() {
    print_header "MCP Context Forge - Live Demonstration"

    echo "This script demonstrates the core capabilities of MCP Context Forge:"
    echo "  - Tool registration"
    echo "  - Tool discovery"
    echo "  - Tool governance (enable/disable)"
    echo ""
    echo "Server URL: ${BASE_URL}"
    echo ""

    # Pre-flight checks
    check_jq
    check_server

    wait_for_enter

    # Clean up existing demo tools
    cleanup_demo_tools

    # Run demo
    register_tools
    wait_for_enter

    discover_tools
    wait_for_enter

    demonstrate_governance

    show_admin_ui_info
    wait_for_enter

    show_summary
}

# Run main function
main "$@"
