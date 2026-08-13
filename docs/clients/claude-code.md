# Claude Code

Add Octopad as a remote Streamable HTTP MCP server:

```bash
claude mcp add --transport http --scope user octopad https://mcp.octopad.app/mcp
```

Open Claude Code and run `/mcp`. When authentication starts in the browser:

1. Sign in or create an Octopad account.
2. Complete any required organization or membership setup.
3. Authorize Claude Code.

Return to Claude Code and confirm that the server is connected.

Start a new Claude Code session and send: **"Use Octopad. Start my onboarding."**

The `user` scope makes Octopad available across your projects. Use `local` or `project` scope only when you want a narrower connection.

The optional `manage-product-documentation` and `octoplan-claude` skills are separate installs. Do not install either unless the user asks for it. See [INSTALL.md](../../INSTALL.md#optional-skills).

To revoke or remove the connection, follow [Privacy, access and removal](../../README.md#privacy-access-and-removal).

Source: [Anthropic Claude Code MCP documentation](https://code.claude.com/docs/en/mcp)
