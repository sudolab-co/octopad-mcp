---
name: octoplan
description: Use only when a Codex user explicitly invokes $octoplan or explicitly asks to plan, replan, flesh out, or resume a governed Octopad work stream or task. Do not use for generic Octopad actions, onboarding, or unapproved execution.
---
Version: 10.1.0

# Octoplan for Codex

Plan an Octopad work stream into a verified graph, then supervise only its explicitly authorized agent-owned execution. Planning never implements the deliverable. Every generated actor gets a packet with organization, workspace, and task, enters its Octopad context through the session entrypoint, and follows its lifecycle. This skill owns orchestration, not the tool protocol. The supported saved contract is exactly `octoplan-supervision-v6` plus `octoplan-fingerprint-v3`, one canonical Delivery mode record, and native creation schema v3. Any other saved contract is unsupported and must be replanned before use.

Octopad is the governed blackboard for bounded decision-relevant context, the durable plan and ledger, evidence, and activity history; native Codex is evidence about sessions. Keep both operations concrete and use only capabilities available in the active session.

## Loading order

Read [references/planning.md](references/planning.md) completely for planning or replanning. Once a complete scoping brief exists, read [references/octoplan-contract-v3.md](references/octoplan-contract-v3.md) before review, feasibility, persistence, fingerprinting, or consent. Read [references/codex-runtime.md](references/codex-runtime.md) plus the contract before routing or consent. Read [references/codex-supervision.md](references/codex-supervision.md) plus the contract before launch or resume. References are one level deep and are not interchangeable.

## Role packs

Load only the matching compact pack from `roles/`: planner, supervisor, executor, reviewer, specialist-reviewer, recovery, or follow-up.

Only a native Codex session exposing the required orchestration capability may be supervisor, reviewer, or successor launcher. An analytical delegate may propose bounded reasoning but cannot impersonate a native actor or launch a session.

## Seven invariants

- Default to **Review before delivery**. Use **Autonomous delivery** from the first message when the user explicitly delegates end-to-end delivery in any natural language; the contract determines whether that one instruction unambiguously covers planning, launch, and in-envelope replanning.
- Ground every triggered high-risk invariant in the contract's feasibility matrix before Plan PASS; missing primitives, sources, boundaries, prerequisites, or available verifiers cannot become prose PASS.
- Before any Octopad planning write, prove the execution runway. If the current task lacks the exact saved project identity required for native actors, relocate the untouched brief into that project and restart the preflight there; never discover this after ledger reconstruction.
- Keep every native Octoplan session in the planning session's saved Codex project. Local and worktree sessions may differ inside that project; a cross-project or project/projectless substitution stops before creation.
- Only the fenced supervisor launches successors; a material incident uses a fresh planner without execution authority, and a replacement run repeats equality, fingerprint, feasibility, adoption, and conformance checks without transferring PASS.
- Roles bind their native capability profile and immutable context packet; child incidents return to the supervisor. Tasks are independently deliverable results; probes, connections, logins, and inspections are internal steps.
- The Delivery mode never authorizes a protected action; every consequential human occurrence remains separately specified, fingerprinted, and gated.
- Apply active instruction precedence, let local or service policy narrow authority only, resolve people from current roles, retrieve bounded context, and abstract only external adapters with GitHub conditional.

Keep opaque identifiers out of visible prose/titles; use the supervisor grammar, readable names, and required native links, keep exact IDs internal, and publish the six-field handoff before attention-requiring waits/pauses and in the final recap.

## Changing this skill

Edit and release [sudolab-co/octopad-mcp](https://github.com/sudolab-co/octopad-mcp), never an installed copy.
