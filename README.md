# agentsmith-skills

Versioned skill and pattern definitions for [agent-smith](https://github.com/holgerleichsenring/agent-smith).

## Layout

```
agentsmith-skills/
├── skills/              # Role definitions (api-security, coding, legal, mad, security)
│   └── <category>/
│       └── <role>/
│           ├── SKILL.md         # Required — frontmatter `name:`, role description
│           ├── agentsmith.md    # Optional — agent-smith extensions (triggers, orchestration)
│           └── source.md        # Optional — provenance metadata
└── patterns/            # YAML regex pattern definitions for the static scanner
    ├── ai-security.yaml
    ├── api-auth.yaml
    ├── auth.yaml
    ├── compliance.yaml
    ├── config.yaml
    ├── injection.yaml
    ├── secrets.yaml
    └── ssrf.yaml
```

## How agent-smith consumes this

The agent-smith server resolves content at boot via `SkillsBootstrapHostedService`,
driven by the `skills:` section in `agentsmith.yaml`:

```yaml
skills:
  source: default      # default | path | url
  version: v1.0.0      # default-source: which release to pull
  cacheDir: /var/lib/agentsmith/skills  # where to extract
  # path: /opt/skills          # path source: pre-mounted directory
  # url: https://...           # url source: explicit tarball URL
  # sha256: <hex>              # url source: SHA256 verification
```

The `agentsmith skills pull` CLI command runs the same download/verify/extract
path standalone — see [docs/skills/source-modes.md](https://github.com/holgerleichsenring/agent-smith/blob/main/docs/skills/source-modes.md).

## Releases

Each tag of the form `vX.Y.Z` produces:

- `agentsmith-skills-vX.Y.Z.tar.gz` — deterministic tarball of `skills/` (and from
  v2.0.0 onwards, also `patterns/`)
- `agentsmith-skills-vX.Y.Z.tar.gz.sha256` — SHA256 sidecar

The tarball is reproducible: any rebuild of the same commit produces a byte-equal
archive. See [scripts/package.sh](scripts/package.sh).

The `edge` tag tracks `main` and is republished on every push.

## Air-gap installs

Pre-download a release in a connected environment, then point the server at it:

```bash
agentsmith skills pull --version v1.0.0 --output /var/lib/agentsmith/skills
# or in airgap, copy the tarball + sha256 across the boundary, then:
agentsmith skills pull --url file:///path/to/agentsmith-skills-v1.0.0.tar.gz \
                      --sha256 $(cat agentsmith-skills-v1.0.0.tar.gz.sha256)
```

Or override the default repository URL without changing config:

```bash
export AGENTSMITH_SKILLS_REPOSITORY_URL=https://internal.mirror/agentsmith-skills
```

## Contributing

- New skill: add `<category>/<role>/SKILL.md` with the required frontmatter.
- New pattern: add an entry to one of `patterns/*.yaml` or create a new file there.
  Pattern IDs are opaque — see the
  [custom-patterns docs](https://github.com/holgerleichsenring/agent-smith/blob/main/docs/security/custom-patterns.md).
- Bumping the catalog: edit `CHANGELOG.md`, tag `vX.Y.Z`, push the tag.

## License

See [LICENSE](LICENSE).
