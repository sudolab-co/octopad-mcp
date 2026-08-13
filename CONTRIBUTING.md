# Contributing

This public repository contains direct MCP setup guides and optional skill distributions. Keep each pull request narrow and state which surface it changes.

## Choose the scope

- **Connection docs:** `README.md`, `INSTALL.md` and `docs/clients/`.
- **Claude Octoplan:** `.claude-plugin/` and `plugins/octoplan-claude/`.
- **Codex Octoplan:** `.agents/` and `plugins/octoplan-codex/`.
- **Product documentation for Claude Code:** `.claude-plugin/` and `plugins/manage-product-documentation-claude/`.
- **Product documentation for Codex:** `.agents/` and `plugins/manage-product-documentation/`.
- **Shared release records:** `CHANGELOG.md` and repository-level validation.

Each Octoplan plugin is a separate public contract. The two product-documentation plugins distribute one shared contract. Do not change several unrelated contracts unless the pull request clearly covers them.

## Skill contract changes ship with a version bump

For an independently versioned distribution such as Octoplan, three surfaces move together. The paired product-documentation distributions follow the synchronized rule below. Change a required surface without the others and the repo lies about itself:

1. **That distribution's skill `Version:` line**, at the top of its `SKILL.md`.
2. **That distribution's plugin `version`**, in `plugins/<plugin>/.claude-plugin/plugin.json` for Claude or `plugins/<plugin>/.codex-plugin/plugin.json` for Codex. Same number.
3. **`CHANGELOG.md`**, a new entry under that skill, dated, saying what changed in plain language.

An identity migration that changes no skill behavior keeps the existing skill versions. Document it in the connection guides. Do not invent a skill release.

Repository maintainers publish tags and releases after review. Existing Claude Octoplan releases use `octoplan-vX.Y.Z`; future ones use `octoplan-claude-vX.Y.Z`. Product-documentation releases use `manage-product-documentation-claude-vX.Y.Z` and `manage-product-documentation-codex-vX.Y.Z`. Codex Octoplan releases use `octoplan-codex-vX.Y.Z`.

## Which number moves

Use semantic versioning against each distribution's public contract:

- **Major** (`2.0.0`): an incompatible contract change. Use it when an existing saved plan needs migration or replanning.
- **Minor** (`1.1.0`): backward-compatible functionality or guidance. Existing saved plans and prompts remain valid.
- **Patch** (`1.0.1`): a backward-compatible bug fix or clarification that adds no new capability.

When in doubt, ask whether existing valid inputs need editing or migration. If yes, the change is major. A different internal path is not major when the public contract stays compatible.

## Keep the distributions separate

A Claude-only Octoplan change may edit Claude files, its changelog entry and shared docs about that change. A Codex-only Octoplan change follows the same rule.

Do not copy behavior between distributions without checking each contract. Describe both runtimes accurately in shared docs. Test both paths when an edit touches both.

The two `manage-product-documentation` distributions have one synchronized release version and one shared AI-neutral contract. Their skill `Version:` lines, both plugin manifest versions, `SKILL.md`, `documentation-model.md`, `artifact-shapes.md`, and `lifecycle-playbooks.md` must move together and remain byte-identical where shared. Any behavior or runtime-packaging change bumps the synchronized version in both distributions and creates one shared changelog entry. Publish the Claude and Codex tags with that same version.

## The Octopad contract is not yours to change

Skills that write Tasks through Octopad's MCP server must follow the server contract. The server rejects Tasks that break these rules. Do not change them here:

- Descriptions need literal **Why** and **What** sections. Top-level tasks also need **Done when**. Valid headers are `**Why**`, `## Why`, or `Why:` at line start.
- `impact` (1 to 5) and `impact_rationale` are required creation parameters on every task, subtasks included.
- Subtasks are created with `parent_task_id` and need only Why + What.
- Dependency edges require a rationale when added.

An incompatible Octopad contract change needs a major skill version. A backward-compatible server addition follows the same minor-or-patch test above.

## Write for a first-time reader

- Use short, familiar words and active voice.
- Put actions in the order the reader must take them.
- Explain a technical term the first time it appears.
- Prefer one concrete instruction to a broad summary.
- Cut internal approvals, private paths and team-only rules from public guidance.
- Cut every word that does not help the reader act.

## Before opening a pull request

- The skill's YAML `name:` still matches its folder name. Its `description:` still carries the phrases that trigger it.
- No secret, private path, private infrastructure detail or internal conversation went in.
- Any claim about a third-party product is either sourced or cut.
- A Codex release requires explicit authority before execution. It creates no executor during planning and applies saved model and effort values without substitution.
- Run `sh scripts/validate-repository.sh` from the repository root.
- Explain the user-visible change and any migration in the pull request.
