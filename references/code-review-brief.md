Neither the child that built the work nor you who led it is its reviewer:
both of you know what was meant and read the diff as that. Once the build is
green, start a fresh child with `spawn_agents` and give it the spec verbatim,
how to see this spec's diff alone (the command, against the state this spec
started from), the coding principles that apply, and this brief:

> Review this change against its spec. Answer every done line yes or no with
> its evidence — the file and line, or a command you ran and its output. Walk
> the diff against the coding principles and list every violation with
> file:line. Check adherence: the diff does what the spec says and nothing it
> does not. Name what should improve and say which of it belongs in this
> spec. Lead with the done lines that do not hold. Change no file; report
> only.

Its answer is advice. Weigh it, send what holds the spec back to the builder,
and name in your report what you left standing and why. A finding you reject
needs a reason a reader can check: the file and line, the spec, or the
operator's words. If the reviewer cannot be started, say so in your report:
the change was not reviewed, and why.
