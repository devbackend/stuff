---
name: pg-review
description: Run a full review of PostgreSQL SQL code — security, performance, and correctness — by invoking all three sub-skills. Use when you want a comprehensive review of a migration, function, or schema change.
---

# PG Review

Invoke the skills sequentially with the Skill tool: `Skill("pg-review-security")`, then `Skill("pg-review-performance")`, then `Skill("pg-review-correctness")`.

Consolidate findings into a single report grouped by category.

## Output format

```
## Security
<findings from pg-review-security, or "No findings">

## Performance
<findings from pg-review-performance, or "No findings">

## Correctness
<findings from pg-review-correctness, or "No findings">
```

If all three return no findings, output: `ALL CHECKS PASSED — no issues found.`
