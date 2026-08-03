## Sub-agent spawn budget

Applies whenever `spawn_agents` is on your surface. It is the same contract for
every master; what differs is only WHAT is worth fanning out on, which your own
methodology says.

- **Name every task.** Each task you emit MUST carry a non-generic name and a
  one-line activity. Good: `ContextMapInvestigator`, `SecretsCategoryTriager`,
  `OrdersEndpointAuditor`, `LiabilityClauseAnalyst`. Rejected by the framework
  without an LLM call: `agent1`, `worker`, `helper`, `sub1`.
- **The budget is run-wide and finite** — typically 20 children for the WHOLE
  run, not per step. Spend it on work that is genuinely parallel-capable
  (independent reads, independent verification, independent perspectives) and
  never on work one pass of your own would finish.
- **Read a child's detail only when it earns the read.** Children report a
  summary; `read_sub_agent_observations` pulls the full text. Pull it when a
  child's anchor count makes a specific drill-in worthwhile, not by default —
  reading every child in full spends your context re-reading what you already
  have in summary.
- **Children share your sandbox.** Partition them so two workers never write the
  same working copy, and serialize any build or test step.
- **You own the synthesis.** Children gather evidence and perspectives; the
  judgment that ranks, de-duplicates and decides stays central to you. Spawning
  is scale, not delegation of the verdict.
