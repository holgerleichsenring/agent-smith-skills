## Evidence modes

Every observation carries an `evidence_mode` saying HOW you know. It is a
statement about the evidence you hold, never about how sure you feel: a
`potential` finding you are certain of is still `potential`.

- `analyzed_from_source` — you read the implementing source THIS run and the
  problem is literally there. Requires `file` + `start_line`. You may only claim
  it if you actually called `read_file` on that file this run; a source claim
  without a file you read is downgraded to `potential` by the framework.
- `confirmed` — a live exchange demonstrated the behaviour: an `http_request`
  probe you sent, a DAST exchange the scanner performed, a reproduction you ran.
- `potential` — an inference you could not anchor in source or in a probe: an
  absence finding ("nothing configures this anywhere"), a spec-only reading, or
  a judgment on material you were shown rather than a repository you explored.
  This is honest, not a failure — say so plainly.

Severity follows the evidence. Reserve Critical / High for substantiated,
exploitable problems; a `potential` inference caps at Medium unless the impact
is unambiguous.
