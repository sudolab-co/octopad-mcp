---
name: octoplan
description: Use when a Codex user invokes Octoplan for a named work stream, asks to plan or replan an Octopad work stream, says Blueprint for a multi-stream effort, or asks to flesh out an Octoplan task. Requires connected Octopad MCP tools.
---
Version: 1.6.1

# Octoplan for Codex

## Purpose

Turn an Octopad work stream into a verified sequence of execution-ready tasks with authoritative pointers. Planning never starts execution. On every full planning pass, return a scoping brief as the whole reply and wait for the user's confirmation before saving any planning artifact; only the reduced event-driven rebalance defined below is exempt. After the confirmed plan is saved and reviewed, ask for explicit approval; only then may Codex execute it by creating model-routed independent sessions.

A full plan or targeted replan runs on `gpt-5.6-sol` with `xhigh` or `max` effort. Use `max` only when verified scope, risk, or ambiguity warrants it. The planner setting is separate from the saved execution route for each task.

Read [references/planning.md](references/planning.md) completely before planning, replanning, or fleshing out a task. Read [references/codex-runtime.md](references/codex-runtime.md) completely before recommending models or asking to launch execution. After a clear execution yes, read [references/codex-relay.md](references/codex-relay.md) completely before creating the first task or resuming an approved run.

## Hard boundaries

1. Except for the reduced event-driven rebalance defined below, before locking a Decision, drafting a Blueprint or design page, or writing a task or tracker change, return the complete scoping brief defined in the planning reference as the whole reply and wait for a later user response. A prior launch prompt or tracker note never satisfies this gate. A partial reply never silently accepts an unanswered point; follow the one-reask Question-and-placeholder rule in the planning reference.
2. After that confirmation, a planning pass writes only Octopad tasks, Decisions, Questions, tracker logic, and Blueprint pages. It never implements a planned task.
3. Never create an executor session during planning or merely because a plan is complete.
4. End a completed plan with the execution-consent question from the Codex runtime reference and wait.
5. A clear affirmative answer authorizes execution of the current saved plan only. It does not authorize protected external actions, human gates, or materially expanded scope.
6. After approval, the planning session launches only the first ready task or explicitly parallel group. Continuation then travels with the work: a `Review: skip` executor owns durable completion and the next launch; a `Review: required` executor creates one fresh routed reviewer, which owns the correction loop, durable completion, and the next launch after PASS.
7. Apply the exact saved model and reasoning effort. Never silently substitute a cheaper or different configuration.
8. Run tasks in parallel only when the saved plan explicitly proves them independent and the complete group passes preflight.
9. Octopad holds scope, state, dependencies, routing, review, and verification. Handoffs are pointers, never copied plans.

## Codex-specific result

After approval, the planning session resolves, claims, and creates the first ready task or explicitly parallel group. Each completing executor or reviewer then re-reads Octopad, claims the next ready task or group with concurrency guards, creates its fresh worktree or local sessions, persists their identifiers, and returns. `Next` and dependency edges carry this relay; no new field is required in existing plans.

No Kickstart skill or Branch command exists. Fresh `create_thread` tasks replace both.

## Replanning

Execution may rebalance at most two added or materially rewritten tasks without rerunning the scoping brief only when the approved result, scope, cost, risk, and definition of success stay unchanged. Mechanical renumbering and dependency or Next-line repairs do not count toward that limit. Pure plan-hygiene repairs may continue under the existing execution approval; adding, removing, or materially rewriting executable work requires showing the revision and receiving fresh execution approval before execution continues. Three or more added or materially rewritten tasks, moved scope, changed material cost or risk, or an invalidated definition of success require a fresh full planning pass: pause execution, return a new scoping brief and wait, then save and review the revised plan and request execution approval again.

## Close

Before approval, report the planned state and ask the execution-consent question. During approved execution, report only meaningful progress, failures, human gates, and the final verified outcome. Never describe thread creation as task completion.

## Changing this skill

This skill is distributed from [sudolab-co/octopad-skills](https://github.com/sudolab-co/octopad-skills). Edit and release it there; never edit an installed copy.
