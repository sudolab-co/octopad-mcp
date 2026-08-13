# Cursor

Open **Customize** in Cursor's sidebar and manage MCP servers there, or place this server in the global `~/.cursor/mcp.json` file:

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

When Cursor asks you to authenticate:

1. Sign in or create an Octopad account in the browser.
2. Complete any required organization or membership setup.
3. Authorize Cursor.

Return to Cursor and confirm that the server is enabled.

Start a new Cursor conversation and send: **"Use Octopad. Start my onboarding."**

To revoke or remove the connection, follow [Privacy, access and removal](../../README.md#privacy-access-and-removal).

Source: [Cursor MCP documentation](https://cursor.com/docs/mcp)
