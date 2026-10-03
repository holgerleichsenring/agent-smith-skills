# Framework Overlay Format

An overlay is the third layer of the composed principles: `core.md` carries
intent, a delta carries one language's mechanisms, an overlay carries the
rules of one FRAMEWORK that components in several languages share (Spark is
used from Scala and from Python alike). It is composed after the delta for
every component whose manifest proves the framework.

**Membership test**: a rule belongs in an overlay when it holds because of the
framework, whatever the language. A rule that holds because of the language
belongs in that language's delta; pure intent stays in the core.

## File location and naming

One file per framework at `principles/frameworks/<slug>.md`. The file name is
the slug, lowercase.

## Required structure

````markdown
# <Framework> Overlay

<!-- agentsmith:principles-overlay <slug> v1 -->

## Detection

```yaml
- file: build.sbt
  contains: org.apache.spark
- file: requirements*.txt
  contains: pyspark
```

## Rules

### All languages

- <rule that holds in every language using the framework>

### <delta slug>

- <rule that holds only in this language's use of the framework>

## Artefacts

No artefacts — <why>.
````

- **Detection** holds exactly one fenced `yaml` block: a list of signals.
  `file` is a file name, a glob (`requirements*.txt`) or a path relative to
  the component root (`gradle/libs.versions.toml`) — never rooted, never
  `..`. `contains` is text the file must hold; without it, the file's
  existence is the signal. Any one matching signal applies the overlay. A
  signal is a DECLARED dependency, so applying the overlay reads the
  manifest instead of guessing from names.
- **Rules** has an `### All languages` section and one section per language
  the framework's mechanisms differ in, named by that language's delta slug
  (`scala`, `python`). Composition renders `All languages` and the section
  matching the component's language; the overlay's title is not rendered.
- **Artefacts** says so explicitly when there are none, as a delta does.
- An overlay has no Overrides section: it adds rules for a framework and
  replaces no core or delta rule.

## Writing rules for overlays

The delta rules apply: every rule is imperative and checkable against a diff,
and grounded in the framework's own documentation. In addition:

- **Nothing that only might.** A rule that depends on what the code cannot
  show — data size, cluster shape, call frequency — is not a rule. `collect()`
  on a small frame is fine; an overlay that forbade it would be wrong.
- The framework's own documentation stating a behaviour as undefined, wrong,
  or required is a rule; "consider", "prefer" and performance advice are not.

The agent-smith composer is the authoritative reader of this format;
`scripts/validate-skills.sh` checks its shape.
