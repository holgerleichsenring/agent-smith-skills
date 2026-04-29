# Agent Smith Configuration

## display-name
Security Headers Auditor

## emoji
🛡️

## triggers
- security-headers
- csp
- hsts
- x-frame-options
- cookie-flags

## convergence_criteria

- "All baseline headers checked against dynamic and source signals"
- "Weak header values flagged against allowed_value_patterns"
- "Drift between dynamic and source surfaced where applicable"

## orchestration
role: contributor
output: list
runs_after:
runs_before: chain-analyst
parallel_with: auth-config-reviewer, controller-implementation-reviewer
input_categories: headers
mode: dynamic-or-source
