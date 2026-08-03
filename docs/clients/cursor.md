# Cursor

Add this server through **Cursor Settings > Tools & MCPs > New MCP Server**, or place it in the global `~/.cursor/mcp.json` file:

```json
{
  "mcpServers": {
    "octopad": {
      "url": "https://mcp.octopad.app/mcp"
    }
  }
}
```

For a project-only connection, use `.cursor/mcp.json` in that repository instead. Project servers require approval in Cursor.

When Octopad shows **Needs authentication**, select **Connect** and complete sign-in or account creation in the browser. Confirm the server is enabled before asking Cursor to use Octopad.

Source: [Cursor MCP documentation](https://cursor.com/docs/mcp)
