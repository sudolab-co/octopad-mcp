# Octoplan User-Facing Identifiers and Session Links Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Octoplan's Codex-facing replies hide opaque UUIDs and hashes while giving every referenced Codex session a readable clickable deep link.

**Architecture:** Keep UUIDs, hashes, and other opaque identifiers in the internal ledger, agent-to-agent prompts, tool arguments, exact commands, and required Markdown link destinations, but prohibit them as visible user-facing prose or link labels. Add the rule to the Codex skill, planning/runtime consent guidance, and supervision guidance; use the repository validator as the regression test. Do not change Octopad's task graph, PR/migration/task numbering, or the Claude distribution.

**Tech Stack:** Markdown skill instructions, POSIX shell validator, JSON plugin manifest, Git.

## Global Constraints

- Base the work on `origin/main` `5.0.0`.
- Scope is `plugins/octoplan-codex`; do not edit `plugins/octoplan`.
- Visible replies must not print raw UUIDs, session/client/host/run/attempt IDs, owner tokens, SHA-256 values, or Git commit hashes.
- Internal ledger records, agent-to-agent prompts, tool calls, exact commands, and required Markdown link destinations may retain opaque identifiers; bare URLs may not.
- A Codex session reference uses `[readable title or role](codex://threads/<thread-id>)`; the raw thread ID is never the visible label or surrounding prose.
- PR numbers, migration numbers, task numbers, and `#N` Octoplan ranks are not covered by this rule.
- Bump the Codex distribution from `5.0.0` to `5.1.0` in the skill, manifest, and changelog.

### Task 1: Add the failing validator contract

**Files:**
- Modify: `scripts/validate-octoplan-codex.sh`
- Test: `scripts/validate-octoplan-codex.sh`

- [x] **Step 1: Update the validator's base-contract checks to `5.1.0` and `octoplan-supervision-v3`**
- [x] **Step 2: Add assertions for the user-facing identifier rule, the `codex://threads/<thread-id>` link shape, and the explicit numbering exclusions**
- [x] **Step 3: Run `sh scripts/validate-octoplan-codex.sh` and confirm it fails because the new guidance is not present yet**

### Task 2: Implement the user-facing output policy

**Files:**
- Modify: `plugins/octoplan-codex/skills/octoplan/SKILL.md`
- Modify: `plugins/octoplan-codex/skills/octoplan/references/planning.md`
- Modify: `plugins/octoplan-codex/skills/octoplan/references/codex-runtime.md`
- Modify: `plugins/octoplan-codex/skills/octoplan/references/codex-supervision.md`

- [x] **Step 1: Add one shared visible-output rule to the skill and supervision guidance**
- [x] **Step 2: Change planning and execution-consent wording so the exact hash remains recorded and bound internally without being printed in the user-facing reply**
- [x] **Step 3: Preserve all internal identifier requirements and explicitly exclude PR, migration, task, and `#N` numbering**
- [x] **Step 4: Run the validator and confirm it passes**

### Task 3: Version and verify the release metadata

**Files:**
- Modify: `plugins/octoplan-codex/.codex-plugin/plugin.json`
- Modify: `CHANGELOG.md`

- [x] **Step 1: Set the plugin version to `5.1.0` and add a dated changelog entry describing hidden opaque identifiers and Codex session deep links**
- [x] **Step 2: Run `sh scripts/validate-octoplan-codex.sh` and inspect `git diff --check`**
- [x] **Step 3: Re-read all changed files, confirm only the Codex distribution changed, and report the exact verification results**
