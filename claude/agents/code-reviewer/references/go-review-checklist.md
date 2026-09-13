# Go Review Checklist

Additional Go-specific rules to check during review, on top of `go-core-rules.md`, `go-isp-patterns.md`, `go-concurrency-patterns.md`, and `go-error-handling.md`. Map findings to the `issue (blocking)` / `suggestion` / `nitpick` labels from `conventional-comments.md`.

## Blocking

- Nil pointer dereference risk where a receiver/dependency is never set outside tests.
- Goroutine leak — writing to a buffered channel with no guaranteed reader.
- Error returned as `nil` when the case is clearly an error condition.
- Error ignored completely (missed error handling).
- Hardcoded production secrets/credentials left in the diff.

## Suggestions

- `fmt.Println` / `fmt.Printf` / `fmt.Fprintf` in production code — use structured logging (`slog`, `zerolog`).
- Wrong log level: an error logged at `Info` level should be `Error` or `Warn`.
- Commented-out code left in the diff — flag for removal (or `//TODO` + a linter rule for TODOs).
- Debug/temporary code committed to the main branch.
- Unused function parameters.
- Unused struct/interface fields that are never referenced.
- Interface too large — includes methods the implementation doesn't need (ISP violation).
- Pointer to slice (`*[]T`) returned or passed — a slice is already a pointer to its backing array.
- Regexp compiled inside a function that's called repeatedly — compile once as a package-level variable.
- Zero-valued fields set explicitly in struct initialization — drop them.
- Errors must be wrapped with context. Default: `fmt.Errorf("...: %w", err)`. Repo-specific wrappers override this (e.g. finance-backend uses `errs.WrapWithFuncParams` — see its CLAUDE.md).
- Missing sentinel errors — prefer an exported `ErrNotFound`-style value checked with `errors.Is` over ad-hoc string comparison.
- Repeated boolean literals (`true, true, true`) passed as call arguments — extract to named constants.
- HTTP handler doesn't restrict methods — use explicit method restrictions on the router.
- Reimplementing something a stdlib/existing library already provides.
- Missing `go.sum` in the repo.
- Map access without a mutex — needs a proper `RLock`/`Lock` pattern.
- Tool version pinned to `@latest` in Makefile/tooling — pin an explicit version.
- `.DS_Store` or other OS-specific files not covered by `.gitignore`.

## Nits

- Filename typo or wrong case (not snake_case).
- Comment that only restates what the code does.
- `[]TypeSlice` where `Type` is already a slice type.
- Unnecessary `return` in a `case` block.
- Unclear or overly abbreviated variable names.
