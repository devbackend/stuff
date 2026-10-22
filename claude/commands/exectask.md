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

### Controversial answers

After every answer, check it against the brief. If the answer contradicts what the brief
states — a different approach, scope, behavior, or acceptance criterion — never silently
accept either side. Flag it explicitly before moving on:

> **Controversial:** the brief says `<quote or paraphrase from the brief>`, but your answer
> says `<the user's answer>`.

Then ask via `AskUserQuestion` (single question, header `Conflict`) with these options:

1. **Go with my answer** — the brief is overridden on this point.
2. **Go with the brief** — discard the answer, follow the brief as written.

Do not continue to the next question until the conflict is resolved. Keep a running list of
every point where the brief was overridden — it is carried into the plan or the
implementation.

Only proceed to Step 3 once all open questions and conflicts are resolved.

---

## Step 3 — Ready to implement

Questions are done — say so in one line, then ask via `AskUserQuestion` (single question,
header `Next step`) with exactly these options, in this order:

1. **Implement (Recommended)** — start coding now based on everything gathered above.
2. **Plan mode** — write a structured implementation plan first.

Implement is always the first option, regardless of task size: the user confirms it with a
plain Enter in almost every run, so never reorder or re-label it based on your own complexity
assessment.

- If **Implement**: start coding immediately.
- If **Plan mode**: continue to Step 4.

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

### Deviations from the brief
- [Point where the brief was overridden in Step 2: what the brief said → what we do instead]

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

No "Open Questions" section — all questions were resolved in Step 2. Omit "Deviations from
the brief" if nothing was overridden. If the codebase is
accessible, explore relevant files to make file paths and module names concrete.
