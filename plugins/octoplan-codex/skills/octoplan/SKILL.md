---
name: octoplan
description: Use only when a Codex user explicitly invokes $octoplan, asks Octoplan to turn an idea into a governed Octopad plan, or explicitly asks to plan, replan, flesh out, or resume a governed work stream or task. Do not use for generic Octopad actions, onboarding, or unapproved execution.
---
Version: 10.2.0

# Octoplan for Codex

Turn a new idea or existing Octopad stream into a verified graph, then supervise explicitly authorized agent execution. Planning never implements the deliverable. A new idea needs no stream or contract and stays non-authoritative until sealed. Every actor receives organization, workspace, and task, then enters Octopad through the session entrypoint. The supported saved contract is exactly `octoplan-supervision-v6` plus `octoplan-fingerprint-v3`, one canonical Delivery mode record, and native creation schema v3. Any other saved contract is unsupported and must be replanned before use.

Octopad is the governed blackboard for bounded decision-relevant context, the durable plan and ledger, evidence, and activity history; native Codex is evidence about sessions. Keep both operations concrete and use only capabilities available in the active session.

## Loading order

Read [references/planning.md](references/planning.md) completely for planning or replanning. Once a complete scoping brief exists, read [references/octoplan-contract-v3.md](references/octoplan-contract-v3.md) before review, feasibility, persistence, fingerprinting, or consent. Read [references/codex-runtime.md](references/codex-runtime.md) plus the contract before routing or consent. Read [references/codex-supervision.md](references/codex-supervision.md) plus the contract before launch or resume. References are one level deep and are not interchangeable.

## Role packs

Load only the matching compact pack from `roles/`: planner, plan-reviewer, supervisor, executor, reviewer, specialist-reviewer, recovery, or follow-up.

Only a native Codex session exposing the required orchestration capability may be supervisor, execution reviewer, or successor launcher. One fresh read-only Codex subagent using `plan-reviewer` may return pre-run plan and activation review evidence; it needs no run or task identity, is not an Octoplan actor, and cannot persist, claim, or launch.

## Seven invariants

- Default to **Review before delivery**. Use **Autonomous delivery** from the first message when the user explicitly delegates end-to-end delivery in any natural language; the contract determines whether that one instruction unambiguously covers planning, launch, and in-envelope replanning.
- Ground every triggered high-risk invariant in the contract's feasibility matrix before Plan PASS; missing primitives, sources, boundaries, prerequisites, or available verifiers cannot become prose PASS.
- Use a two-stage runway: prove project, native creation/reconciliation, entrypoint, review, and authority substrate before a candidate write, then prove the drafted graph's sources, adapters, write shapes, prerequisites, and verifiers before persistence. Relocate the untouched brief first when project identity is wrong.
- Keep every native Octoplan session in the planning session's saved Codex project. Local and worktree sessions may differ inside that project; a cross-project or project/projectless substitution stops before creation.
- Only the fenced supervisor launches execution successors; the pre-run read-only reviewer is the sole non-actor exception. A material incident uses a fresh planner without execution authority, and a replacement repeats equality, fingerprint, feasibility, adoption, and conformance without transferring PASS.
- Roles bind their native capability profile and immutable context packet; child incidents return to the supervisor. Tasks are independently deliverable results; probes, connections, logins, and inspections are internal steps.
- The Delivery mode never authorizes a protected action; every consequential human occurrence remains separately specified, fingerprinted, and gated.
- Apply active instruction precedence, let local or service policy narrow authority only, resolve people from current roles, retrieve bounded context, and abstract only external adapters with GitHub conditional.

Keep opaque identifiers out of visible prose/titles; use the supervisor grammar, readable names, and required native links, keep exact IDs internal, and publish the six-field handoff before attention-requiring waits/pauses and in the final recap.

## Changing this skill

Edit and release [sudolab-co/octopad-mcp](https://github.com/sudolab-co/octopad-mcp), never an installed copy.
