---
description: Run a task brief through Grill Me and plan mode. Use ONLY when explicitly invoked as /exectask, or when handed off to from /jiratask — never self-invoke it for an ordinary implementation request.
allowed-tools: Bash, Read, Glob, Grep, WebFetch, ToolSearch, Skill, AskUserQuestion, EnterPlanMode, ExitPlanMode
---

# ExecTask

The task input is: `$ARGUMENTS`

---

## Step 0 — Normalize the input

Resolve `$ARGUMENTS` top to bottom, first match wins:

1. **A readable file path** (`test -r "$ARGUMENTS"`) → read the file; its content is the task brief.
2. **An `http(s)://` URL** → fetch it with WebFetch; the fetched content is the task brief.
3. **Empty** → ask the user to describe the task, then continue with their answer as the brief.
4. **Anything else** → the text itself is the task.

A brief may carry a trailing free-form instruction for this run (e.g. "backend scope only",
"research only, change nothing"). Honor it — it outranks the generic flow below.

Derive the **task title**: the brief's top-level heading if it has one, otherwise a short
noun phrase you write yourself. It becomes the plan heading in Step 5.

---

## Step 1 — Internalize the task

Read and internalize everything available:

- Goal — what problem this solves
- Scope, explicit and implied
- Acceptance criteria
- Constraints: deadlines, compatibility, dependencies on other systems or teams
- Any background, links, prior discussion carried in the brief

---

## Step 2 — Grill Me: resolve all unclear points

Before writing any plan, invoke the `grill-me` skill to surface every ambiguous, unclear, or
dual-interpretation point in the task.

**Never assume.** If something can be understood in more than one way, or a decision isn't
spelled out in the brief — ask. Ask one question at a time and wait for the answer before
continuing.

Probe in particular:

- Scope boundaries left vague in the brief
- Technical approach choices where multiple paths exist
- Edge cases the brief doesn't address
- Dependencies on other services, teams, or tickets
- Expected behavior in error/failure scenarios
- Non-obvious acceptance criteria

If a question can be answered by exploring the codebase, do that instead of asking.

Only proceed to Step 3 once all open questions are resolved.

---

## Step 3 — Plan mode or implement directly?

Ask the user (plain text):

> Based on [one-line assessment of complexity/scope], I'd suggest [plan mode / implementing
> directly]. Should I enter plan mode and write a structured implementation plan, or start
> implementing directly?

Wait for the answer.

- If **plan mode**: continue to Step 4.
- If **implement directly**: start coding immediately based on all context gathered above.

---

## Step 4 — Enter plan mode

```
ToolSearch: select:EnterPlanMode
```

Call `EnterPlanMode`.

---

## Step 5 — Write the implementation plan

Based on the brief and the answers from Step 2, produce a structured plan:

```
## [Task Title]

### Context
[What problem this solves. Where it fits in the product. Relevant background from the brief.]

### Scope
**In scope:**
- ...

**Out of scope:**
- ...

### Implementation Steps
1. [Step — reference specific files, modules, or functions]
2. [...]
...

### Testing Plan
- [ ] Unit tests: ...
- [ ] Integration / e2e tests: ...
- [ ] Manual verification steps: ...
```

No "Open Questions" section — all questions were resolved in Step 2. If the codebase is
accessible, explore relevant files to make file paths and module names concrete.
