# Compact artifact shapes

Use these as adaptable shapes, not forms that must be filled. Omit irrelevant sections. Preserve the product's existing vocabulary and page conventions.

## Product Map

```markdown
# Product Map

## Product foundation
- Purpose: <confirmed statement or Unknown>
- Intended users: <confirmed statement or Unknown>
- Current evidence: <source and last verified time>

## Systems
| System | Responsibility | State | Product Spec | Active work |
|---|---|---|---|---|

## Architecture
- Canonical Architecture Map: <repository link, provisional Octopad fallback, or Not established>

## Cross-system relationships
- <only important relationships>

## Gaps and stale areas
- <explicit gap, evidence needed, and related documentation-debt work>
```

## Product Spec

```markdown
# <System name> — Product Spec

## Purpose and boundary
<User need, responsibility, and what is outside the system.>

## Released behavior
<Current production truth only.>

## Proposed or approved changes
<Give each item its own proposed, approved, implemented, or merged state and link it to its Decision or work.>

## Rules and edge cases
<Only behavior people must understand. Link a Behavioral Contract when needed.>

## Connections
- Product Map: <link>
- Architecture Map: <link or relevant section>
- Decisions: <links>
- Work stream and Tasks: <links>
- User documentation: <links>

## Verification
- Evidence: <source>
- Source revision or release: <exact value or Unknown>
- Last verified: <time or Unknown>
- Freshness: <current | stale | unverified>
- Known gaps: <gaps or None found>
```

Do not mix proposed behavior into the released section. Put lifecycle state on each material claim or change, not on the Product Spec as a whole. A Product Spec may contain items in several states when they remain visibly separated.

## Behavioral Contract

```markdown
# <Behavior> — Behavioral Contract

## Scope
<Boundary and actors.>

## Inputs and preconditions
<Exact conditions.>

## Outputs and effects
<Observable behavior.>

## Invariants and failure behavior
<Rules, edge cases, and failure semantics.>

## Compatibility or migration
<Only when applicable.>

## Enforcement and evidence
- Tests, types, schemas, lint, or CI: <links>
- Source revision or release: <exact value>
- Last verified: <time>
```

## Architecture Map

```markdown
# Architecture Map

## Components and boundaries
<Major runtime or deployable components only.>

## Data and external services
<Stable stores, flows, and external dependencies.>

## Canonical code and enforcement
<Repository locations and executable contracts, without a file inventory.>

## Release model
<How released state is actually established.>

## Related product systems
<Links to Product Specs and targeted Engineering References.>

## Verification
- Source revision: <exact value>
- Last verified: <time>
- Gaps: <explicit unknowns>
```

## Documentation-debt Task

Keep one bounded Task for related gaps. Give its description literal `Why`, `What`, and `Done when` sections. Provide `impact` from 1 to 5 and `impact_rationale`. For a subtask, use `parent_task_id`; for every dependency edge, include its rationale. State why the missing or stale knowledge matters, what evidence or repair is needed, and what proves completion. Link the affected pages, repository locations, PRs, releases, and Decisions. Do not copy the Task's status into those pages.
