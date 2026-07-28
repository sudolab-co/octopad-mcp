---
name: octoplan
description: Use when a Codex user invokes Octoplan for a named work stream, asks to plan or replan an Octopad work stream, says Blueprint for a multi-stream effort, or asks to flesh out an Octoplan task. Requires connected Octopad MCP tools.
---
Version: 1.3.1

# Octoplan for Codex

## Purpose

Turn an Octopad work stream into a verified sequence of self-contained tasks. Planning never starts execution. After the plan is saved and reviewed, ask for explicit approval; only then may Codex execute it by creating model-routed independent sessions.

Read [references/planning.md](references/planning.md) completely before planning, replanning, or fleshing out a task. Read [references/codex-runtime.md](references/codex-runtime.md) completely before recommending models, asking to launch execution, or orchestrating an approved plan.

## Hard boundaries

1. A planning pass writes only Octopad tasks, Decisions, Questions, tracker logic, and Blueprint pages. It never implements a planned task.
2. Never create an executor session during planning or merely because a plan is complete.
3. End a completed plan with the execution-consent question from the Codex runtime reference and wait.
4. A clear affirmative answer authorizes execution of the current saved plan only. It does not authorize protected external actions, human gates, or materially expanded scope.
5. After approval, keep one orchestration owner. It follows Octopad dependencies and creates a fresh independent Codex task for each executable top-level task. Executor tasks never create successors.
6. Apply the exact saved model and reasoning effort. Never silently substitute a cheaper or different configuration.
7. Run tasks in parallel only when the saved plan explicitly proves them independent and the complete group passes preflight.
8. Octopad holds scope, state, dependencies, routing, review, and verification. Handoffs are pointers, never copied plans.

## Codex-specific result

The planning session becomes the orchestration session only after approval. It resolves the next ready task or explicitly parallel group, claims the work in Octopad, creates the required worktree or local sessions, waits for their results, verifies the durable task state, and advances until the plan finishes or reaches a real stop.

No Kickstart skill or Branch command exists. Fresh `create_thread` tasks replace both.

## Replanning

Execution may repair plan hygiene without widening the promised result. If discovery adds work, changes material scope, changes risk, or invalidates the definition of success, pause execution, replan, show the revised plan, and request execution approval again.

## Close

Before approval, report the planned state and ask the execution-consent question. During approved execution, report only meaningful progress, failures, human gates, and the final verified outcome. Never describe thread creation as task completion.

## Changing this skill

This skill is distributed from [sudolab-co/octopad-skills](https://github.com/sudolab-co/octopad-skills). Edit and release it there; never edit an installed copy.
