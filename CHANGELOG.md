# Changelog

All notable changes to the agentsmith-skills catalog are documented here.
Versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [v1.0.0]

### Added
- Initial extraction from the agent-smith main repo (was `config/skills/` until
  agent-smith p0103).
- Categories shipped: `api-security`, `coding`, `legal`, `mad`, `security`.
- Deterministic tarball packaging via `scripts/package.sh`.
- GitHub release workflow on tag push (`vX.Y.Z`).
- Edge channel published on every push to `main`.

### Notes
- Patterns (`patterns/`) are present in this initial release for parity with
  agent-smith bundled defaults but are not yet consumed externally — that
  switchover happens in agent-smith p0103b together with the repo rename to
  `agentsmith-content`.
