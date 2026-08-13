# Codex in the ChatGPT desktop app and Codex CLI

The ChatGPT desktop app and Codex CLI share MCP configuration for the same Codex host.

This guide is for Codex. For regular ChatGPT conversations, use the official Octopad app instead. This is the supported customer-facing ChatGPT plugin. Find it in the current [ChatGPT directory](https://chatgpt.com/plugins).

## ChatGPT desktop app

1. Open **Settings**, then **MCP servers**.
2. Select **Add server**.
3. Name it `octopad`, choose **Streamable HTTP**, and enter `https://mcp.octopad.app/mcp`.
4. Save, select **Authenticate**, then sign in or create an Octopad account in the browser.
5. Complete any required organization or membership setup, then authorize Codex.
6. Restart when prompted. In a Codex task, use `/mcp` to confirm that Octopad is connected.
7. Start a new Codex task and send: **"Use Octopad. Start my onboarding."**

## Codex CLI

```bash
codex mcp add octopad --url https://mcp.octopad.app/mcp
codex mcp login octopad
```

In the browser:

1. Sign in or create an Octopad account.
2. Complete any required organization or membership setup.
3. Authorize Codex.

Return to the terminal and verify the connection:

```bash
codex mcp list
```

Start a new Codex task and send: **"Use Octopad. Start my onboarding."**

## Optional Codex skills

The `manage-product-documentation` and `octoplan-codex` plugins are separate from the MCP connection. Do not install either unless the user asks for it. See [INSTALL.md](../../INSTALL.md#optional-skills).

## Why this differs from the ChatGPT app

The official Octopad app serves regular ChatGPT conversations. The direct MCP connection on this page serves Codex. Both connect to Octopad. You install them in different parts of ChatGPT.

To revoke or remove the connection, follow [Privacy, access and removal](../../README.md#privacy-access-and-removal).

Source: [OpenAI MCP documentation](https://learn.chatgpt.com/docs/extend/mcp)
