# ChatGPT desktop app and Codex CLI

The ChatGPT desktop app and Codex CLI share MCP configuration for the same Codex host.

## ChatGPT desktop app

1. Open **Settings**, then **MCP servers**.
2. Select **Add server**.
3. Name it `octopad`, choose **Streamable HTTP**, and enter `https://mcp.octopad.app/mcp`.
4. Save, select **Authenticate**, and complete sign-in or account creation in the browser.
5. Restart when prompted. In a Codex task, use `/mcp` to confirm that Octopad is connected.

## Codex CLI

```bash
codex mcp add octopad --url https://mcp.octopad.app/mcp
codex mcp login octopad
codex mcp list
```

Start a new Codex task after authentication, then ask Octopad to start a session.

## Official ChatGPT plugin

The official Octopad plugin is the simplest option for ChatGPT Work. Use direct MCP when you need Octopad in Codex or want a package-level tool or contract update before the next reviewed plugin release. Server-only compatible fixes reach both paths when deployed.

Source: [OpenAI MCP documentation](https://learn.chatgpt.com/docs/extend/mcp)
