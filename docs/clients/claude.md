# Claude and Claude Desktop

Remote custom connectors are configured in Claude's connector settings. Claude Desktop does not load a remote connector from `claude_desktop_config.json`.

1. Open **Customize > Connectors** in Claude or Claude Desktop.
2. On a Team or Enterprise workspace, an Owner or Primary Owner must first use **Organization settings > Connectors**.
3. Select **+ > Add custom connector**.
4. Name it `Octopad` and enter `https://mcp.octopad.app/mcp`.
5. Select **Connect**, then sign in or create an Octopad account in the browser.
6. Complete any required organization or membership setup.
7. Authorize Claude, return to the conversation, and enable the Octopad tools.
8. Start a new conversation and send: **"Use Octopad. Start my onboarding."**

Anthropic makes remote custom connectors available on Free, Pro, Max, Team, and Enterprise plans. Free accounts can add one custom connector. Workspace policy can restrict who may add one.

To revoke or remove the connection, follow [Privacy, access and removal](../../README.md#privacy-access-and-removal).

Source: [Anthropic remote custom connector guide](https://support.claude.com/en/articles/11175166-get-started-with-custom-connectors-using-remote-mcp)
