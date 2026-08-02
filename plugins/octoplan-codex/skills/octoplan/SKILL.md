---
name: octoplan
description: Use only when a Codex user explicitly invokes $octoplan or explicitly asks to plan, replan, or flesh out an Octopad work stream or task, create a Blueprint for a multi-stream effort, or resume an approved Octoplan run. Do not use for general Octopad actions, organization connection, onboarding, or task execution without an approved Octoplan run. Requires connected Octopad MCP tools.
---
Version: 4.1.0

# Octoplan for Codex

## Purpose

Turn an Octopad work stream into a verified, execution-ready graph. Planning never executes it. After consent, a fenced supervisor reconciles Octopad with native Codex sessions. A dedicated parent exists only when remaining complexity justifies its handoff cost.

Planning runs on `gpt-5.6-sol` at `xhigh` or justified `max`. Task, review, and supervisor routes are separate.

Read [references/planning.md](references/planning.md) completely before planning, replanning, or fleshing out work. Read [references/codex-runtime.md](references/codex-runtime.md) completely before routing or asking for execution consent. After a clear execution yes, or when asked to resume a run, read [references/codex-supervision.md](references/codex-supervision.md) completely before any execution action.

## Phase contract

1. Return the scoping brief as the whole reply and wait for later confirmation before any full-plan write.
2. Planning writes only Octopad planning artifacts. It never implements work or creates execution sessions.
3. A completed plan ends with the runtime's execution-consent question and waits. Execution consent never covers protected actions or human gates.
4. Octopad is authoritative. Only the current fenced supervisor launches successors; it stays inline unless the saved policy justifies a dedicated parent.
5. A plan without the environment-bound `octoplan-supervision-v2` contract is not executable under 4.1.0. Replan it; never infer a native project target or migrate consent.

## Replanning

A reduced rebalance may add, remove, or materially rewrite at most two tasks only when result, scope, material cost, risk, and success stay unchanged. Every saved plan change needs a new reviewed hash, consent, and run. Anything larger needs a full planning pass.

## Close

Before consent, report the verified plan and ask the execution question. During execution, report only meaningful progress, failures, human gates, and the final verified outcome. Never describe session creation as task completion.

## Changing this skill

Edit and release [sudolab-co/octopad-skills](https://github.com/sudolab-co/octopad-skills), never an installed copy.
