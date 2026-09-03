# Contributing

This public repository contains direct MCP setup guides and optional skill distributions. Keep each pull request narrow and state which surface it changes.

## Choose the scope

- **Connection docs:** `README.md`, `INSTALL.md` and `docs/clients/`.
- **Claude Octoplan:** `.claude-plugin/` and `plugins/octoplan-claude/`.
- **Codex Octoplan:** `.agents/` and `plugins/octoplan-codex/`.
- **Product documentation for Claude Code:** `.claude-plugin/` and `plugins/manage-product-documentation-claude/`.
- **Product documentation for Codex:** `.agents/` and `plugins/manage-product-documentation-codex/`.
- **Meeting to Octopad:** `.claude-plugin/` and `plugins/meeting-to-octopad/`.
- **Shared release records:** `CHANGELOG.md` and repository-level validation.

The two Octoplan plugins distribute one shared contract to two runtimes, as do the two product-documentation plugins. Do not change several unrelated contracts unless the pull request clearly covers them.

## One skill, one name

A distribution's folder name, its plugin `name`, and its release tag prefix are the same string. A skill that ships to more than one AI runtime carries that runtime in the name; a skill that ships to one runtime does not. Release titles read `<Display Name> <version>`, nothing else.

| Folder | Plugin name | Tag prefix | Release title |
|---|---|---|---|
| `plugins/octoplan-claude/` | `octoplan-claude` | `octoplan-claude-v` | `Octoplan for Claude Code X.Y.Z` |
| `plugins/octoplan-codex/` | `octoplan-codex` | `octoplan-codex-v` | `Octoplan for Codex X.Y.Z` |
| `plugins/manage-product-documentation-claude/` | `manage-product-documentation` | `manage-product-documentation-claude-v` | `Manage Product Documentation X.Y.Z (Claude Code)` |
| `plugins/manage-product-documentation-codex/` | `manage-product-documentation` | `manage-product-documentation-codex-v` | `Manage Product Documentation X.Y.Z (Codex)` |
| `plugins/meeting-to-octopad/` | `meeting-to-octopad` | `meeting-to-octopad-v` | `Meeting to Octopad X.Y.Z` |

The product-documentation plugin name carries no runtime suffix because each marketplace manifest already selects one runtime and the two entries never appear in the same list. Its folder and tag still carry the suffix, because both live in one repository where the names must not collide. `scripts/validate-repository.sh` enforces the folder-to-plugin-name half of this rule; tags and release titles are the publisher's to get right.

## Skill contract changes ship with a version bump

For an independently versioned distribution such as Octoplan, three surfaces move together. The paired product-documentation distributions follow the synchronized rule below. Change a required surface without the others and the repo lies about itself:

1. **That distribution's skill `Version:` line**, at the top of its `SKILL.md`.
2. **That distribution's plugin `version`**, in `plugins/<plugin>/.claude-plugin/plugin.json` for Claude or `plugins/<plugin>/.codex-plugin/plugin.json` for Codex. Same number.
3. **`CHANGELOG.md`**, a new entry under that skill, dated, saying what changed in plain language.

An identity migration that changes no skill behavior keeps the existing skill versions. Document it in the connection guides. Do not invent a skill release.

Repository maintainers publish tags and releases after review, using the prefixes in the table above. Tags published before a distribution's version reset keep their original prefix and number: they are the record of what those release pages already serve, and renaming them would break the link between a release and what it shipped. Retired prefixes, kept for history only: `octoplan-vX.Y.Z` and `octoplan-autopilot-vX.Y.Z`.

## Which number moves

Every version is [semantic versioning](https://semver.org): `MAJOR.MINOR.PATCH`.

- **MAJOR — it breaks what already works.** A saved plan, a stored continuation block, or an existing prompt must be edited or migrated before it runs again. Reset MINOR and PATCH to zero.
- **MINOR — it adds behavior and breaks nothing.** A new rule, a new step, a widened instruction. Everything already saved keeps working untouched. Reset PATCH to zero.
- **PATCH — it fixes or clarifies, with no behavior change.**

The test is compatibility, never size and never how many runtimes a change reaches. A change both runtimes see is still MINOR when nothing saved needs editing; it simply moves both distributions together, because they share one contract. A change one runtime sees is MAJOR when it breaks that runtime's saved state.

Octoplan restarted at `1.0.0` on both runtimes when they adopted one shared contract, so the numbers mean the same thing on both sides. Changelog entries from before that reset keep their original numbers under each distribution's pre-reset heading.

Do not confuse the release version with a plan-contract generation. Codex Octoplan stamps saved plans with a contract generation (`Octoplan 18 plan contract`) that says which plans a supervisor may still execute. That identifier is runtime state and is not renumbered by a release. Changing it is a `P` bump with a migration, never a side effect of versioning.

## Keep the distributions separate

A Claude-only Octoplan change may edit Claude files, its changelog entry and shared docs about that change. A Codex-only Octoplan change follows the same rule. A change to the contract both share moves both.

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
