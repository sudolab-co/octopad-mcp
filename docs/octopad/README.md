# Octopad aggregate for Codex

Release scope, 2026-09-23: **MCP connection and skills; no kernel activation**. Version **1.0.0**. This package joins the hosted Octopad connection and nine satellite skills in the existing `octopad-mcp` repository marketplace. It is not the official ChatGPT app or a public-directory submission.

## Contents and source

The runtime-neutral canon is `config/shared-skills/`. `scripts/sync-octopad.py` copies its 17 Markdown files into `plugins/octopad/skills/`. Every satellite retains its own version and evidence history. The native bootstrap `octopad-session` is a technical entrypoint, not a tenth business satellite.

| Satellite | Contract version |
|---|---|
| octopad-knowledge-evidence | 1.0.0-public-r1 |
| octopad-planning-and-work-design | 1.0.0-public-r2, first declaration |
| octopad-notepad | 1.0.1-public-r2, terminology-only patch |
| manage-activity-context | 5.0.0 |
| manage-market-intelligence | 1.3.0 |
| manage-product-documentation | 4.0.0-public-r2 |
| manage-product-marketing | 1.0.0-public-r1 |
| pmm-check | 1.0.0-public-r1 |
| technical-writing | 2.0.0 |

[Package provenance](package-provenance.json) preserves the qualified source hashes, path mapping and exact adaptations. The R2 local qualification was a composition of prior evidence and a targeted impact analysis. It did not establish production behavior, ACL enforcement, actual client installation or statistical reliability. Historical failures stay failures. Packaging changes require focused validation; they do not retroactively rerun those behavioral trials.

The manifest follows the repository's `.codex-plugin/plugin.json` convention with `.mcp.json`. This remains a supported compatibility format in the [OpenAI plugin packaging documentation](https://developers.openai.com/plugins/build/plugins). There are no hooks, embedded credentials, local service processes or paid-model test runners.

## Server dependency: one kernel

The installed package carries **no kernel text**. Version 1.0.0 leaves `methodology` unset and follows the methodology returned by the server. Client-aware routing between legacy and kernel methodologies is separate server work. Publishing this bundle does not require changing `start_session` and does not turn on kernel delivery.

The exact tested kernel is stored as [kernel-r2.md](kernel-r2.md) for the server owner. It is a frozen handoff artifact outside `plugins/octopad/`, not a runtime instruction or local fallback.

The integration target is [server PR #979](https://github.com/sudolab-co/octopad/pull/979), inspected at head `249294a58a969cd86280b1ab4a12a3ff53620433`, base `161a5e00094fd972db931c0674b2ef59dd2858fd`. On 2026-09-23 it was open and draft, with two successful checks. Its implementation embeds and serves kernel text. Its task description still describes a pointer to a plugin-local kernel. That draft is context, not an activated contract for this release. The server owner must reconcile the stale description, client detection and the final contract before kernel activation. This work changes neither `start_session` nor any backend source or deployment.

The frozen R2 kernel required for the integration handoff has SHA-256 `76bd4a21d046de7878cd21872ad3854ca2782b5d4a9859217567da666e51d98c` (18,041 bytes). The server PR explicitly requests replacing its provisional kernel before leaving draft. Its owner must compare the actual embedded bytes with that frozen input; a green packaging check does not prove this replacement. The frozen kernel still uses the historical word “module” for the three skills. Do not edit its bytes here to normalize vocabulary: any server-side wording change needs its own recorded hash and review.

| Situation in the inspected server contract | Expected methodology |
|---|---|
| Marker and allow-listed organization | Server kernel |
| Marker and another organization | V1 with precedence over conflicting plugin instructions |
| No marker and allow-listed organization | V1 with a note about an earlier kernel already received in the conversation |
| No marker and another organization | Existing V1 |

The draft remembers the marker for up to 24 hours per client identity in process memory. A restart or eviction may forget it. Omission of the marker is not a reset. A plugin removal does not erase kernel text already in a conversation. Do not infer organization eligibility from the ability to install the package.

On the inspected production connection, the exposed `start_session` schema lacked `methodology`. An existing direct connection worked, but that is **not** a test of the bundled connector or kernel selection. No kernel activation was attempted.

## Compatibility and coexistence

| Surface | Status and rule |
|---|---|
| Codex CLI and desktop | Package prepared; real install, catalogue resolution and early bootstrap loading still require separate witnesses in each host. |
| Claude Code | No aggregate is added to its marketplace. Existing `octoplan-claude`, `manage-product-documentation` and `meeting-to-octopad` remain unchanged. A future aggregate needs the common canon and a separately reviewed native bootstrap; PR #979 requests early SessionStart loading for that host. |
| Claude web, Desktop, Cowork | No skill-installation or early-loading claim from this package. |
| Standalone product-documentation | Both 1.4.0 distributions remain intact. Select the standalone or aggregate version within a client, not both. |
| Octoplan | Remains a separate plugin. Its planning/supervision authority is unchanged. |
| Personal/shared skills | Inventory same-named Notepad, product-documentation, PMM and technical-writing variants, plus old activity-context and MI routes. Do not silently shadow, rename, delete or alias them. |

Use exactly one active Octopad connector route in the target client. The bundle connects to `https://mcp.octopad.app/mcp`; do not add another direct entry for it. If a direct connector already exists, preserve its non-secret configuration and identify the exact disable/restore mechanism before changing the active selection. Do not inspect, copy or export credential stores.

The bootstrap routes to files inside its own package. It does not prove that a client's implicit skill discovery will select those files. Before activation, inspect the effective catalogue and resolve every colliding owner to one chosen variant. Preserve the old packages and business data. Never turn the internal `manage-company-context` or `update-market-intelligence` identities into automatic aliases.

## Installation rehearsal after authorization

No command in this section was executed as an installation during preparation. First choose the exact host, checkout or published revision, connector selection and skill variants to replace. Obtain authorization for those configuration and authentication effects. Do not refresh the whole marketplace as a substitute: that can reinstall unrelated configured plugins.

1. Verify the intended connector and the methodology served today. Installing the MCP-and-skills bundle does not wait for kernel routing. Kernel activation requires a separate server contract, frozen-kernel and release check; a merged PR alone is not proof of deployment.
2. Record the target client's non-secret catalogue, versions, source revisions and connector identifiers. Preserve the prior skill selections and their files. Check whether the `octopad-mcp` marketplace already points to another source; do not replace that registration silently.
3. For an authorized local rehearsal on a target where that marketplace name is free, register the reviewed checkout with `codex plugin marketplace add /absolute/path/to/reviewed/checkout`, then `codex plugin add octopad@octopad-mcp`. For an existing registration, prepare a separate target or an explicitly approved source switch before proceeding. These commands change client configuration and cache; OAuth is a separate user step through the client's secure UI.
4. Start a fresh task and invoke: **Use $octopad-session before calling Octopad, then help with my work.** Select the intended workspace. The bootstrap must be read before the first MCP call. If a session already opened, reuse it. Do not send a methodology marker or restart it for this installation.
5. Record the actually loaded bootstrap path and version, first-call arguments, served methodology identity, and all nine catalogue entries. Read the three relocated skill entrypoints and each referenced local resource. Confirm any skill used resolves inside this package rather than a personal or standalone copy.
6. Repeat the fresh-task witness in desktop and CLI if both are targeted. Test late bootstrap and V1 precedence without claiming kernel activation. Exercise V1 precedence only in an authorized test scope; this guide does not authorize access to another organization's data.

A directory scan is a packaging check, not this installation witness. Tool availability is a connection witness, not proof of loaded instructions. Retain failures and missing witnesses as such.

## Rollback

After an authorized rehearsal, remove `octopad@octopad-mcp` from the target client with `codex plugin remove octopad@octopad-mcp`, and restore the exact saved prior connector and skill selections. Removal deletes the plugin's local cache, so preserve needed source evidence first. Do not remove the shared marketplace if other plugins use it. Do not revoke account grants or alter other clients as a cleanup shortcut.

Start a fresh conversation. This release sends no marker. If a different experimental client previously sent one, under the inspected draft server contract it may remain effective for up to 24 hours after its last marked call; verify returned methodology after expiry. Do not claim an immediate V1 rollback merely because the plugin disappeared. Earlier conversations can still contain kernel text. No business pages, Notepad entries, decisions or tasks are reverted by removing the plugin; any data correction is a separate authorized change.

## Release and activation gates

The release is published through a reviewed branch and PR in `sudolab-co/octopad-mcp`, tag `octopad-v1.0.0` and release `Octopad 1.0.0`, with fresh checks of the exact revision. Source publication, client installation and kernel activation are separate outcomes. See the release page for publication state and the validation record for obtained and missing witnesses.

Installation requires approval for the named host and exact coexistence changes. Server completion and rollout belong to their separate task and owner. The public-directory submission and a Claude aggregate are outside this delivery.

## Install a published version

After the release is available and the coexistence checks above are complete, a user who explicitly chooses this bundle can install it from the repository marketplace:

```bash
codex plugin marketplace add sudolab-co/octopad-mcp --ref main
codex plugin add octopad@octopad-mcp
```

If the marketplace is already registered, reuse that registration after verifying its source revision; do not add or replace it blindly. Start a fresh task and invoke `$octopad-session`. Authenticate only through the client's secure flow when requested. Installation grants no extra Octopad access and does not activate kernel routing.
