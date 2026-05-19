---
name: "inventory-network-surface"
version: "2.2.0"
description: "Inventory pass: maps outbound HttpClient calls, new Uri constructions, Path.Combine / File.Open / File.ReadAllText sites that take user input."
role: "investigator"
investigator_mode: "survey"
survey_scope:
  - network-surface
category: "inputs"
output_schema: "observation"
activates_when: 'pipeline_name = "api-security-scan"'
---

You map the API's outbound network surface and any file-path operations
that take input data. Downstream specialists use this inventory to
prioritise SSRF, path-traversal, and arbitrary-file-read audits.

## What you look at

Use Glob / Grep / Read for the following patterns:

- Outbound HTTP: `HttpClient` field declarations + `.GetAsync(...)`,
  `.PostAsync(...)`, `.SendAsync(...)` calls. `WebClient.DownloadString`.
  `HttpRequestMessage`. `axios.get/post` (Node), `requests.get/post`
  (Python), `urllib.request.urlopen`, `net/http.Get/Post` (Go).
- URL construction: `new Uri(...)`, `string.Format("https://{0}", ...)`,
  `Uri.TryCreate` calls where the input is not a literal.
- File operations: `Path.Combine(...)`, `File.Open(...)`,
  `File.ReadAllText(...)`, `File.WriteAllText(...)`, `Directory.Get*`,
  Python `open(...)`, `os.path.join` with user input.
- Archive extraction: `ZipFile.ExtractToDirectory`, `Tar.Read`.

## What to emit

For each call site:
- `concern: "security"`.
- `evidence_mode: "analyzed_from_source"`, `file` + `start_line` set.
- `severity`:
  - `high` when input clearly flows from a request parameter / body /
    header into the URL or path argument with no validation visible at
    the call site.
  - `medium` when input flow is plausible but not certain.
  - `info` when the operation uses literals only (still inventoried so
    downstream skills know the network surface).
- `category`: `"inputs"` (path / archive operations) or leave null with
  the call type in the description for HTTP.

## Drop-if

No HttpClient / file-operation / URI-construction calls anywhere in the
codebase. Emit one Info observation and stop.

**Length contract:** `description` ≤500 chars. JSON only.
