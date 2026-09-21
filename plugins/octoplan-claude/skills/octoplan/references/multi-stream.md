# Multi-stream coordination

Read this only for more than one work stream. Keep the same Brief, Plan, Delivery, authority, review, and closure semantics. Several streams add graph breadth, not another orchestration layer.

## Choose the smallest useful topology

Parallel tasks alone do not justify several streams. Keep one stream when one local success definition covers the work. Use several when independently verifiable results contribute to one common outcome and benefit from separate ownership, gates, or cadence. Give each stream its own `definition_of_success`, with the detailed proof on its canonical tasks and contract. Unrelated outcomes remain independent Plans.

Reuse a suitable goal when the streams share a destination; create no extra program object. A common native graph uses the same workspace and dependency capabilities the target actually supports. Across workspaces, use an identifiable delivered version and a receiving task that proves compatibility; never invent a cross-workspace edge, automatic wake-up, or additional human gate.

## Explain the connection with a Delivery Map

For a multi-stream Plan, maintain one **Delivery Map**: an additional explanatory common view, alongside the existing Decisions and per-stream contract pages. Name its maintainer in the Plan contract. It explains the common result and completion proof, stream responsibilities and local success conditions, interfaces, safe parallelism, integration order, and responsible actors. Link canonical IDs and applicable revisions instead of copying task specifications, progress, receipts, history, or authority.

Decisions and their linked per-stream contract pages remain authoritative; owning tasks carry executable specifications and dependency edges. An interface's executable definition lives on its owning task or linked specification. Update the Map's applicable explanation when the reviewed contract changes, preserving history through the target's supported revision mechanism or a linked historical record. A newer Map never overrides a contract. Adopt a useful legacy Blueprint as this view when needed; do not create a duplicate or force a rename on unchanged work.

## Define interfaces and integration early

For each seam, record on the owning task or specification: producer, consumer, exchanged artifact, identifiable revision, and compatibility proof. Use a hash only when needed to identify the exact bytes. One actor owns the interface definition, normally its producer; the consumer owns its compatibility evidence. Integration verifies the assembled versions and does not become a second interface writer.

Wire actual task dependencies to the produced prerequisite and explain why it is needed. Dates, priorities and supervisor memory do not express order. Resolve a dependency cycle through a stable contract milestone or regroup work that cannot be separated; never dispatch a cycle as independent work.

Name an integration owner from the start. Use integration tasks, adding a separate stream only for substantial independently managed work. Test interfaces early, then prove the final combination of exact versions. Local PASS does not prove compatibility or common completion. Local permissions do not add up to publication, deployment, acceptance, or another protected effect: integration needs existing authority covering its actual targets and effects, or only that missing delta is requested.

## Review the graph and assign owners

The Plan shows one plain-language line per step across the streams and names independent branches. Review the complete graph, local success definitions, interfaces, integration proof and effect coverage. Receipts identify the task and contract revisions reviewed. Check shared schemas, migrations, generated artifacts, wording, repositories, services and publication targets for conflicting writers; separate branches alone do not make work independent.

Default to one supervisor covering the common outcome. Use several only with disjoint write and decision boundaries, a concrete efficiency benefit, qualified native lifecycle support, and capacity left for workers and reviewers. A worker or reviewer is not another supervisor. Record exactly one active owner for each boundary in the existing stream Decisions; a common owner can be referenced by several streams. No permanent global supervisor is required.

The parent relay handles dialogue and supervisor lifecycle under its runtime profile. Each supervisor owns advancement inside its recorded boundary. Assign one existing actor as **cross-stream change coordinator** in the Plan contract and link it from the Delivery Map. This responsibility adds no permanent agent and gives no right to write another owner's deliverable.

## Advance and repair only affected work

After an accepted result, failed check, changed input or cleared dependency, each owner refreshes the ready frontier and advances safe authorized work. A stopped trial or ended actor turn does not end the mandate. Persist compact receipts on owning tasks and link long reports; the Map is not a progress board. A blocked branch stops its descendants, not independent ready work.

A changed interface, split, merge, new or removed stream, or changed dependency is a material Plan change. The designated coordinator identifies all affected producers, consumers and integration tasks, asks their owners to pause affected dispatch, and initiates bounded repair with a suitable planner. Each owner reconciles its own active actors and effects. Codex can use the original parent-planner; Claude uses the equivalent qualified planner route. The coordinator tracks targeted review and confirms the revised contract is shared before affected owners resume under the existing mandate.

Sweep the open graph for affected specifications, dependencies, gates, verifiers and outcome claims. Preserve unaffected evidence bound to its versions; recheck changed consumers and final integration. Ask only for a changed outcome, authority or user-owned consequence. Coordination or dependency order alone is not a new human gate. Never silently leave an old executable specification active beneath a new explanatory Map.

## Close local and common results separately

A stream closes when its own success definition and gates are proved, even while independent streams continue. Its supervisor may finish that boundary without claiming the common outcome complete. The integration owner closes the common result only when current assembled evidence covers every required stream and seam, with no unresolved required effect. Report supported states such as `built`, `reviewed`, `merged`, `applied`, `verified`, `released`, `accepted`, or their domain equivalents.

Use existing receipts and native logs to assess accepted local and integrated results, avoidable human restarts, dependency-ready-to-resume delay, irrelevant re-reviews, and total orchestration cost. State coverage and unknowns; add no manual metrics register or instrumentation merely to satisfy this guidance.
