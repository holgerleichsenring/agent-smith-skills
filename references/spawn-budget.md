## Sub-agents

Applies whenever `spawn_agents` is on your surface. What is worth fanning out on
is your own methodology's call; how sub-agents work is the same for every master.

- **What a child knows.** A child starts with the task you write and a short
  situation block from the framework: the repositories, what it can read or
  write, and that its last message is what comes back to you. Everything else
  it needs — the goal, what you already know, what to leave alone — is in your
  task text or it does not have it.
- **What comes back.** The spawn result carries each child's final answer as a
  condensed summary. `read_sub_agent_observations` gives the full text; read it
  when a decision rests on detail the summary leaves out.
- **Names.** Each task carries a descriptive name and a one-line activity
  (`ContextMapInvestigator`, `OrdersEndpointAuditor`, `LiabilityClauseAnalyst`).
  The framework refuses a generic one (`agent1`, `worker`, `helper`) before any
  call is made, because the name is how the operator follows the run.
- **Budget.** The run has a finite number of children, typically 20 for the
  whole run; a design turn has its own smaller cap instead. Spend them on work that is genuinely parallel —
  independent reads, independent checks, independent perspectives — rather than
  on work one pass of your own would finish.
- **Shared sandbox.** Children work in your sandbox. Give two children disjoint
  files to write, and run builds and tests one at a time.
- **The verdict stays with you.** Children gather evidence and perspectives;
  ranking, de-duplicating and deciding stay with you.
