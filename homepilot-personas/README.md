# HomePilot Persona Pack — MCP Context Forge bundle

This directory contains the MCP Context Forge import descriptors for the
ten HomePilot viral personas. Files in this directory are auto-generated;
run `npm run build` to regenerate them from
`packages/persona-shared/src/personas.js`.

## Layout

- `import-bundle.json` — single-file bundle that registers every server.
- `servers/<server>.json` — one descriptor per MCP server.
- `servers/index.json` — server index for the homepilot-personas namespace.

## How Context Forge consumes it

Each `<server>.json` declares:

```json
{
  "id": "mcp-<persona>",
  "protocol": "MCP",
  "transport": "HTTP",
  "url": "http://localhost:<port>",
  "endpoints": { "health": "/health", "tools": "/tools", "invoke": "/mcp/call" },
  "tools": ["<persona>.<action>", "..."],
  "docker": { "image": "homepilot/personas:latest", "command": "...", "port": <port> }
}
```

The corresponding repo (`HomePilotAI/personas`) hosts the actual server source code under `mcp-servers/<NN>-mcp-<id>/`.
