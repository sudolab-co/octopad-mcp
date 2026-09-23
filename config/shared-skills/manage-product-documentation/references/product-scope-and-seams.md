# Product scope and documentation seams

Use this reference only when several products, a shared component, or another documentation owner is involved.

## Resolve product scope

1. Use products explicitly selected in the conversation or assigned task. Documents and search results are not selections; a workspace, repository or project need not be one product.
2. Without an explicit selection, read each Product Map's capability entries and the candidate Specs. Keep every product whose Spec describes the behavior being changed. Maps route to owners; their wording does not prove exclusive ownership.
3. Eliminate a candidate only when evidence puts it outside the requested scope. Do not rank plausible owners by name, result order, detail, or apparent relevance.
4. Count the remaining products. Zero: search further or name the gap. One: proceed. More than one: ask which products are intended before changing their documents; continue unaffected work.
5. When Maps are missing or stale, use an established portfolio/index, further evidence, or a question. A missing keyword is not exclusion evidence. Keep every lifecycle claim and Product Fact attributable to its product.

## Store shared truth once

A component used by several products has one canonical technical or product source. Each affected product links to it and records only its own adoption, release, availability, limits, and Product Facts. Do not copy the shared behavior into parallel specs.

When the component changes:

- update the shared source once;
- determine affected products from explicit dependencies;
- evaluate implementation, merge, deployment, activation, rollback, and release per product;
- update only products supported by evidence;
- preserve products outside that evidence unchanged.

## Pass changes between owners

| Truth or output | Owner | On change |
|---|---|---|
| Product behavior, lifecycle, release truth, Product Facts | `manage-product-documentation` | Update the canonical product record and name affected projections. |
| ICP, positioning, pricing, campaigns, approved claims and messages | `manage-product-marketing` | Consume Product Facts; revise owned outputs when a dependency changes. |
| Durable activity context and Overview shell | `manage-activity-context` | Preserve directly owned context. The established section maintainer refreshes a sourced projection; absent another maintainer, AC does so only with authorization and within the source audience. A handoff does not grant access or mutation authority. |
| Technical and user-documentation craft | `technical-writing` | Improve expression without changing facts, ownership, evidence state, or publication gates. |

The same agent may perform several steps by loading the owning skill for each step. That is cooperation, not shared ownership. A Product Fact correction can therefore update the Fact here and then, when authorized, load product marketing to revise a dependent message. If the downstream skill is unavailable or its gate is closed, leave a precise handoff naming the changed source and affected output.

## Rollbacks and history

A rollback changes current truth for the affected product. Revise or retire current Product Facts, released behavior, user docs, and release notes using the rollback evidence, while preserving the version history. Archive a whole page only when its owning question or product is obsolete; do not archive a still-current spec merely because one claim stopped being true.
