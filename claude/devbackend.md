# Global Claude Code Instructions

## Code Comments

Never write comments that describe what the code does. Only add a comment when the WHY is non-obvious: a hidden constraint, a subtle invariant, a workaround for a specific bug, or behavior that would surprise a reader.

## External Dependencies & Libraries

When looking up documentation for libraries, packages, or external dependencies — first check Context7 via MCP:

1. `mcp__context7__resolve-library-id` — find the library ID by name
2. `mcp__context7__query-docs` — fetch the documentation using that ID

If Context7 doesn't have the library, fall back to web search.

## Control Flow: Prefer Early Return

Avoid `else` when the `if` branch exits. See `~/.claude/examples/early-return.go`.

## Language

- Code identifiers, comments, commit messages, PR titles/descriptions — always English.
- Chat replies — mirror the user's language.

## Production / Customer Database Diagnostics

Claude has no access to production, stage, or customer databases. The user runs queries manually (VPN + psql or customer tooling) and pastes results back.

- Send exactly ONE SQL query per message, then stop and wait for the result.
- Return raw rows; do not add aggregation/grouping unless explicitly asked.
- Empty result → immediately propose the next narrowing query.
- Any UPDATE/DELETE must be shown to the user before execution.

## No Unprompted Actions

- Never `git commit` or `git push` unless explicitly asked.
- Do not start editing code while the scope is still being discussed.
- Before launching subagents, announce what they will do and which permissions they will need.

## Conclusions

After long tool runs or investigations, always end the final message with explicit conclusions — what was found and what it means. Never end with raw data only.
