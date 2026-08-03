# Claude Code

Add Octopad as a remote Streamable HTTP MCP server:

```bash
claude mcp add --transport http octopad https://mcp.octopad.app/mcp
```

Open Claude Code and run `/mcp`. Authenticate Octopad when prompted, complete sign-in or account creation in the browser, then confirm that the server is connected.

The optional Octoplan skill is a separate install. Do not install it unless the user asks for Octoplan. See [INSTALL.md](../../INSTALL.md#optional-octoplan-skills).

Source: [Anthropic Claude Code MCP documentation](https://docs.anthropic.com/en/docs/claude-code/mcp)
