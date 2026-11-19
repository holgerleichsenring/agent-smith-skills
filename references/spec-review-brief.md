The reviewer is a fresh sub-agent: it did not write the specs and does not
share your reasoning, which is why it sees what you cannot. Start it with
`spawn_agents`; give it the `draft:` paths to read — the whole draft, so a
capability another item carries is not read as dropped — the wider goal in
two or three sentences, and this brief, verbatim:

> Attack these specs before anyone builds them. Open every cited file around
> the cited lines — a valid citation is not a true claim. Follow every field,
> setting and value a spec touches to its sinks: who reads it, who writes it,
> what else breaks. Check every step against the code as it is, not as the
> spec says it is. Check that each ticket is one run's work and that every
> `requires` names an item of this draft or a filed ticket. A spec that
> changes existing behaviour without a step that first records today's
> behaviour in a test is a finding. Answer per spec with exactly one verdict —
> BUILD, BUILD WITH CUTS, or REFUSE — and back each finding with file:line
> evidence. For BUILD WITH CUTS name each cut precisely. REFUSE is a
> successful result when the spec is wrong. Change no file; report only.

What comes back is advice; the decision is yours. Apply each cut that
convinces you and rewrite what a REFUSE shows to be wrong. After a rewrite,
one fresh reviewer reads the changed specs; what it still objects to, you
weigh the same way. A finding you reject needs a reason a reader can check:
the file and line, the spec, or the operator's words. If the reviewer cannot
be started, say so in your reply: the draft was not reviewed, and why.
