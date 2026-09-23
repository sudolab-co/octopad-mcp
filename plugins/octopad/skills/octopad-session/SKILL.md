---
name: octopad-session
description: Initialize the Octopad plugin before the first Octopad tool call in a new conversation. Use when the user asks to use or connect Octopad, start onboarding, or begin work with this plugin. Respects the served methodology and routes to the bundled skills; it is not an additional business skill.
---
Version: 1.0.0

# Start an Octopad plugin session

Read this bootstrap before any Octopad tool call. Installing the plugin does not prove that this skill loaded early. The supported entry is an explicit user invocation of `$octopad-session` in a fresh conversation.

1. Use the Octopad MCP connector bundled with this plugin. Establish the requested workspace from the user and available context. Do not pick a different organization to obtain a methodology, change authentication, install another connector or bypass an access refusal.
2. Call `start_session` only when a session is needed, using its normal exposed workspace and agent arguments. Leave `methodology` unset. This release does not request an experimental kernel or change session selection; client-aware methodology routing belongs to the server.
3. If a session already exists, reuse it. Do not call `start_session` again, end a session or restart it merely to change methodology.
4. Read the returned methodology before acting. The server owns kernel delivery; this plugin contains no kernel text or local fallback. An installed skill or plugin version is not evidence that the kernel was received, nor that the server delivered the qualified revision.
5. Follow the server's workspace-specific methodology and precedence. V1 wins over conflicting satellite instructions when V1 is served. Do not treat the satellite catalogue as authority to replace it or carry a methodology across organizations. Follow an explicit re-brief precedence note only for methodology actually received in the same workspace scope.
6. Load only the satellite needed for the user's request, using the files in this plugin below. Confirm the selected file's actual path before using it; do not silently select a same-named personal or standalone variant. If this cannot be established, leave that conflicting route unresolved and explain what is missing. Loading a skill never widens scope, permissions or publication authority.

## Bundled satellite routes

These are nine business skills. This bootstrap is technical; Octoplan is separate.

| Request | Skill file |
|---|---|
| Record or retrieve knowledge, evidence, pages or files | [octopad-knowledge-evidence](../octopad-knowledge-evidence/SKILL.md) |
| Shape tasks, dependencies, streams or goals | [octopad-planning-and-work-design](../octopad-planning-and-work-design/SKILL.md) |
| Use an org-wide Notepad actually present in orientation | [octopad-notepad](../octopad-notepad/SKILL.md) |
| Maintain activity context and authorized Overview projections | [manage-activity-context](../manage-activity-context/SKILL.md) |
| Capture, research or synthesize external evidence | [manage-market-intelligence](../manage-market-intelligence/SKILL.md) |
| Maintain product behavior and documentation truth | [manage-product-documentation](../manage-product-documentation/SKILL.md) |
| Maintain marketing choices and their records | [manage-product-marketing](../manage-product-marketing/SKILL.md) |
| Diagnose or review marketing when useful | [pmm-check](../pmm-check/SKILL.md) |
| Improve technical and user writing without changing its facts | [technical-writing](../technical-writing/SKILL.md) |

Follow each loaded skill's references and the methodology's routing limits. Invoke Octoplan only under its own trigger and authorization, from its separate installed plugin. Do not install it as a side effect.
