# Connect Octopad

This is the connection guide for AI assistants.

## Connection contract

1. Detect the current client from the runtime. Do not ask the user when the runtime already identifies itself.
2. Add the MCP connection only by default. Do not install an optional skill unless the user asks for it.
3. Use the matching client guide below. Do not invent a command or edit another client's configuration.
4. Use only this endpoint: `https://mcp.octopad.app/mcp`.
5. In the browser, have the user sign in or create an Octopad account.
6. Have the user complete any required organization or membership setup.
7. Have the user authorize the AI client where they started.
8. Return to that client and verify that it can list the Octopad server or tools. A saved configuration or completed browser screen is not enough.
9. Tell the user to start a new conversation or task in that client and send exactly: **"Use Octopad. Start my onboarding."**

Do not replace the last step with a generic instruction to "start a session." Authorization, connection and guided onboarding are separate steps.

## Choose the current client

| Current client | Follow |
|---|---|
| ChatGPT desktop app in Codex mode, or Codex CLI | [Codex](docs/clients/codex.md) |
| Claude or Claude Desktop | [Claude](docs/clients/claude.md) |
| Claude Code | [Claude Code](docs/clients/claude-code.md) |
| Cursor | [Cursor](docs/clients/cursor.md) |
| Gemini CLI | [Gemini CLI](docs/clients/gemini-cli.md) |
| Another MCP client | Add `https://mcp.octopad.app/mcp` as a remote Streamable HTTP server, then follow steps 5 to 9 above. |

If the client cannot add a remote Streamable HTTP MCP server with OAuth, explain that limit and stop. Do not substitute another method without the user's approval.

For regular ChatGPT conversations, install the official Octopad app. This is the supported customer-facing ChatGPT plugin. Open the current [ChatGPT directory](https://chatgpt.com/plugins) and search for `Octopad`. That route is separate from the direct MCP setup in this file.

## Octopad bundle

If the user explicitly asks for the `octopad` plugin, install it from **Octopad bundle** under Optional skills below. It includes an MCP connection, so do not also create the direct connection above. Before installing, list the Octopad connections and same-named skills already present, and keep one active Octopad connection per client. The [integration and rollback guide](docs/octopad/README.md) covers coexistence in detail.

## Optional skills

Skills are separate from the MCP connection. Install one only when the user explicitly asks for it.

### Keep skills up to date

**Claude Code.** A third-party marketplace does not refresh itself by default. After installing any skill from `octopad-mcp`, offer to turn automatic updates on and walk the user through it, because a skill that never refreshes silently stays on an old contract:

1. Run `/plugin`.
2. Select **Marketplaces**.
3. Select `octopad-mcp` and enable automatic updates.

Do not claim this is done until the user confirms the setting. To refresh once, by hand, run `/plugin marketplace update octopad-mcp`, `/plugin update <plugin>@octopad-mcp`, then `/reload-plugins`.

**Codex.** There is no automatic update. Refresh with `codex plugin marketplace upgrade octopad-mcp`, which refreshes the marketplace and reinstalls its configured plugins. Start a new task afterwards. Tell the user this is manual rather than implying it is automatic.

### Octopad bundle

The `octopad` plugin installs the hosted Octopad connection, nine skills, Octoplan and a technical entry skill. Octoplan plans a work stream into ordered tasks, shows the plan with every protected effect named, and supervises delivery only after the user's explicit go.

Claude Code:

```text
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install octopad@octopad-mcp
/reload-plugins
```

Codex:

```bash
codex plugin marketplace add sudolab-co/octopad-mcp --ref main
codex plugin add octopad@octopad-mcp
```

If the `octopad-mcp` marketplace was added earlier, refresh it first so it lists the bundle: `/plugin marketplace update octopad-mcp` in Claude Code, `codex plugin marketplace upgrade octopad-mcp` in Codex.

Sign in through the client's own authorization window when it asks. Then start a new conversation or task. In Codex, start with `$octopad-session`. Then follow **Keep skills up to date** above.

If Octopad was already connected by hand, such as with `claude mcp add` or `codex mcp add`, or through a Claude connector, two Octopad connections are now active. Ask the user which one to keep, and remove or disable the other only with their agreement.

### Meeting to Octopad for Claude Code

This skill turns a meeting transcript into Octopad changes: it extracts decisions, action items, updates, open questions, and goal signals, matches them against what Octopad already holds, and proposes every change in one table that you approve before anything is written.

```text
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install meeting-to-octopad@octopad-mcp
/reload-plugins
```

Then follow **Keep skills up to date** above.

### Move from the retired plugins

`octoplan-claude`, `octoplan-codex` and `manage-product-documentation` are retired. The `octopad` bundle carries the same skills, so keeping an old plugin beside it would load the same skill twice. Remove each one that is installed, then install the bundle.

Claude Code:

```text
/plugin marketplace update octopad-mcp
/plugin uninstall octoplan-claude@octopad-mcp
/plugin uninstall manage-product-documentation@octopad-mcp
/plugin install octopad@octopad-mcp
/reload-plugins
```

Codex:

```bash
codex plugin remove octoplan-codex@octopad-mcp
codex plugin remove manage-product-documentation@octopad-mcp
codex plugin marketplace upgrade octopad-mcp
codex plugin add octopad@octopad-mcp
```

Older identities follow the same path. From `octoplan-autopilot@octopad-mcp`, or from the retired `octopad-skills` marketplace, uninstall that plugin, remove the `octopad-skills` marketplace if it is present, then install the bundle as above.

Start a new conversation or task after any migration.
