# Gemini CLI

Add Octopad as a user-level remote Streamable HTTP MCP server:

```bash
gemini mcp add --transport http octopad https://mcp.octopad.app/mcp --scope user
gemini mcp list
```

Complete OAuth in the browser when prompted. In Gemini CLI, use `/mcp` to confirm that Octopad's tools are connected, then ask Octopad to start a session.

Gemini CLI support in this repository covers the direct MCP connection only. This repository does not ship a Gemini extension.

Source: [Gemini CLI MCP documentation](https://geminicli.com/docs/tools/mcp-server/)
