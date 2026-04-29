# Agent Smith Configuration

## display-name
Controller Implementation Reviewer

## emoji
🛠️

## triggers
- controller-implementation
- input-validation
- exception-leakage
- dto-exposure
- sql-injection
- missing-authorize
- log-secrets

## convergence_criteria

- "All state-changing handlers reviewed for validation, exception handling, DTO exposure"
- "Correlated findings mapped to handler snippets where applicable"
- "Project-brief constraints (DTO conventions, authorization defaults) applied"

## orchestration
role: contributor
output: list
runs_after:
runs_before: chain-analyst
parallel_with: ownership-checker, auth-config-reviewer, upload-validator-reviewer
input_categories: runtime, headers
mode: source-only
