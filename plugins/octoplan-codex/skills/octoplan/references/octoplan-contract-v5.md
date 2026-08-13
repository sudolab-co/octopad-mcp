# Octoplan v5 compatibility

Octoplan 15 reads and executes only `octoplan-plan-v5`. Preserve v1-v4, 10.x, or unknown state as history, fence or reconcile native actors, inventory live branches/PRs/documents, then materially replan from the confirmed mandate under [state-and-recovery.md](state-and-recovery.md).

Do not translate old fingerprints, PASS records, authority, readback assertions, creation intents, actor bindings, planner/supervisor ownership, or Goal state into v5. Useful source artifacts may be adopted only through the new generation's explicit manifest, lifecycle disposition, fresh planner lease, and fresh review.

Within v5, adopt a compatible installed update only at a safe boundary after fully reading it and recording the transition. A higher schema or breaking major requires material replan; an old role packet or long-lived native context never pins an actor forever.

Version 15.0 is breaking: v4 lacks mandatory planner leases, context-health admission, accepted-progress circuit breakers, delivery-artifact lifecycle, and baseline leases. Fence writers, expire planners, preserve branches/PRs as inventoried evidence, and create a fresh v5 plan; do not migrate an unfinished Goal or infer a healthy context.

Installing v15 does not change a running legacy task. Enumerate live supervisors/Goals, actors, branches, PRs, documents, and pending effects; persist a source-bound migration notice; fence affected execution; then replan under v5. If a legacy Goal is unfinished, keep v5 paused and launch nothing until its saved owner reaches a genuine terminal state; an unsupported termination needs an explicit lifecycle decision, never false completion/blocking or a competing Goal. Never assume installation propagated the correction.
