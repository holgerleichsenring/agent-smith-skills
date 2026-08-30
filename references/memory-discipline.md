# Experiential Memory — Store Convention and Curation Discipline

A project can carry an experiential-memory store at `.agentsmith/memory/` —
Git-native, typed Markdown facts that travel with the code and are reviewed in
pull requests. This file defines the ONE convention every producer follows
(agent-smith runs and IDE sessions write the identical store) and the curation
discipline that keeps it high-signal.

## Store shape

- **One Markdown file per memory** under `.agentsmith/memory/`, filename
  `<name>.md`.
- **Frontmatter** on every entry:

  ```markdown
  ---
  name: build-needs-redis-local        # kebab-case slug, equals the filename
  description: Local test runs need Redis on 6379 or the harness times out.
  metadata:
    type: project                      # feedback | project | reference
  ---
  The fact itself — a few lines of Markdown. One fact per file.
  Related memories are linked as [[other-slug]].
  ```

  `name` is a kebab-case slug and matches the filename; `description` is ONE
  line; `metadata.type` is one of the three types below.
- **The index** is `.agentsmith/memory/MEMORY.md`: exactly one line per
  memory (`- [name](name.md) — description`). The index is the cheap pointer
  layer loaded at plan time; **content lives in the entry files, never in the
  index**.
- **`[[slug]]` links** connect related memories, and a memory can be cited
  from decisions, phase specs, and code comments the same way.

## Types

| type | carries | ratification |
|------|---------|--------------|
| `feedback` | How the operator wants the agent to work — corrections and confirmed approaches, with the why. | REQUIRED: a feedback entry is policy only after the operator ratifies it (review of the proposing PR / explicit approval). Until then it is a pending proposal. |
| `project` | Ongoing goals, constraints, and state that code and git cannot tell the next agent. | Not required. |
| `reference` | Pointers to external resources (docs, dashboards, feeds). | Not required. |

## The two access paths

- **Plan time**: the index (one line per memory) is loaded into the agent
  context — scan it to learn which facts already exist.
- **Problem time**: `recall(query)` returns the bodies of matching memories.
  Call it the moment the index (or a citation) hints at a fact you are about
  to work out from scratch. Where the tool is not on your surface, the entry
  files are plain Markdown — a `read_file` on `.agentsmith/memory/<name>.md`
  reads the same truth.
- **Writing**: `remember(type, name, description, body)` writes an entry and
  updates the index — as a PROPOSAL. A feedback-type memory is flagged
  pending-ratification, never silently policy. The operator can equally
  author a memory by hand as plain Markdown.

## Curation discipline — what keeps the store worth reading

- **Store what code and git cannot already tell the next agent.** A memory
  earns its line in the index by recording something the repository does not:
  an operator preference and its why, a constraint discovered the hard way, a
  pointer to an external truth. The diff, the log, and the run record already
  preserve what happened — leave that to them.
- **One fact per file.** A file that needs "and" in its description is two
  memories — split it so each can be recalled, updated, and deleted on its
  own.
- **Check for an existing entry first; update, don't duplicate.** Scan the
  index before writing. When the fact already has a home, sharpen that entry
  in place — the store stays one-authoritative-home-per-fact (DRY for
  knowledge).
- **Delete memories that turn out wrong.** A falsified memory is corrected by
  removing or rewriting it the moment you know — a wrong "fact" recalled with
  confidence is worse than none.
- **Link, and back every citation.** Relate memories with `[[slug]]` links.
  Citing a `[[slug]]` — in a memory, a decision, a phase spec, or a code
  comment — requires its committed definition under `memory/`; the citation
  and the definition land together.
- **A decision is not a memory.** A decision records a CHOICE made at a point
  in time (chose/over/reason — it lives in `decisions/`); a memory records a
  transferable FACT or RULE that future work consults. Distil a decision's
  durable lesson into a memory when there is one; never copy the decision
  itself.
