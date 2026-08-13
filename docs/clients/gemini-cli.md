# Gemini CLI

Add Octopad as a user-level remote Streamable HTTP MCP server:

```bash
gemini mcp add --transport http octopad https://mcp.octopad.app/mcp --scope user
gemini mcp list
```

When authorization starts in the browser:

1. Sign in or create an Octopad account.
2. Complete any required organization or membership setup.
3. Authorize Gemini CLI.

Return to Gemini CLI. Use `/mcp` to confirm that Octopad's tools are connected.

Start a new Gemini CLI session and send: **"Use Octopad. Start my onboarding."**

Gemini CLI support in this repository covers the direct MCP connection only. This repository does not ship a Gemini extension.

To revoke or remove the connection, follow [Privacy, access and removal](../../README.md#privacy-access-and-removal).

Source: [Gemini CLI MCP documentation](https://geminicli.com/docs/tools/mcp-server/)
