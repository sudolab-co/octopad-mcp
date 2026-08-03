---
name: octoplan
description: Use only when a Codex user explicitly invokes $octoplan or explicitly asks to plan, replan, or flesh out an Octopad work stream or task, create a Blueprint for a multi-stream effort, or resume an approved Octoplan run. Do not use for general Octopad actions, organization connection, onboarding, or task execution without an approved Octoplan run. Requires connected Octopad MCP tools.
---
Version: 6.0.0

# Octoplan for Codex

## Purpose

Turn an Octopad work stream into a verified, execution-ready graph, then carry its agent-owned work end to end. Planning never implements the deliverable. After consent, a fenced supervisor reconciles Octopad, native Codex sessions, and supported external events. It may insert bounded repairs and record non-blocking follow-ups without turning local runtime discoveries into full replans. A dedicated parent exists only when remaining complexity justifies its handoff cost.

Planning runs on `gpt-5.6-sol` at `xhigh` or justified `max`. Task, review, and supervisor routes are separate.

Read [references/planning.md](references/planning.md) completely before planning, replanning, or fleshing out work. Read [references/codex-runtime.md](references/codex-runtime.md) completely before routing or asking for execution consent. After a clear execution yes, or when asked to resume a run, read [references/codex-supervision.md](references/codex-supervision.md) completely before any execution action.

## Phase contract

1. Return the scoping brief as the whole reply and wait for later confirmation before any full-plan write.
2. Planning writes only Octopad planning artifacts. It never implements work or creates execution sessions.
3. A completed plan records its reviewed hash in the Plan manifest and ledger, asks for execution consent, and waits. Execution consent never covers protected actions or human gates.
4. Octopad is authoritative. Only the current fenced supervisor launches successors; it stays inline unless the saved policy justifies a dedicated parent.
5. A plan without the environment-bound `octoplan-supervision-v4` contract is not executable under 6.0.0. Replan it; never infer a native project target, repair authority, validation mode, fingerprint, or consent.
6. The supervisor continues while any safe agent-owned task is ready. An open PR, CI wait, human review, merge, migration application, or deployment gate stops only the branch it gates, not unrelated ready work.

## Replanning

Classify discoveries before changing the plan. A bounded repair stays inside one approved task's result, scope, risk, and acceptance and runs under the saved repair envelope without a new plan hash. A non-blocking follow-up is recorded outside the active participant set and does not run in the current plan. Anything changing the approved result, scope, material cost, risk, success, architecture, route bounds, or protected actions needs a reviewed replan and consent.

## Close

Before consent, report the reviewed plan and ask the execution question. During execution, report only meaningful progress, failures, and human gates. The supervisor always owns the last user-facing message: it reports delivered artifacts, reviews and checks, human actions remaining, repairs and rejection loops, problems and resolutions, follow-ups, unresolved risks, and automatically collected actual session and external-event-wake counts. Never describe session creation as task completion or create a reporting-only session.

## User-facing output

Opaque identifiers are internal data, not visible prose. In any reply shown to the user, never print a raw UUID, session/client/host/run/attempt ID, owner token, SHA-256 value, or Git commit hash as text or inline code. Use the entity's human-readable title, name, role, branch, or commit subject instead. When pointing to a Codex session, use a readable Markdown label and the native deep link `[<title or role>](codex://threads/<thread-id>)`; keep the real thread ID only in the link destination. The exact reviewed plan hash remains in the Plan manifest, ledger, and consent binding, but is not printed in the reply. This presentation rule does not change internal ledger fields, tool arguments, exact commands, or required Markdown link destinations. Agent-to-agent prompts and internal coordination records must retain the identifiers needed for correlation; sanitize only a copy shown to the user. An opaque identifier may appear in a required Markdown link destination only; never emit it as a bare URL or visible link label. This rule does not apply to PR numbers, migration numbers, task numbers, or `#N` ranks.

## Changing this skill

Edit and release [sudolab-co/octopad-skills](https://github.com/sudolab-co/octopad-skills), never an installed copy.
