# Brief template for a Codex subagent

Copy this, fill in every section, and delete the guidance in parentheses. Keep it in a file outside the repo and pass it to the launcher with `-Brief`. If a section doesn't apply, write "n/a" rather than dropping it, so you can see you thought about it.

---

# Task: <short title>

## Goal
(What "done" means, in 2–5 sentences. Say what to build, fix, review or measure, and why.)

## Authoritative documents
(The contract, ADR, spec or issue to follow. They take precedence over the agent's own judgement. If code and doc disagree, the agent should report it, not silently pick one.)
- `<path/to/contract.md>`

## Context you need
(Only what it can't find out quickly itself: relevant modules, conventions, decisions already made, and what other agents are doing in parallel.)

## Files you own
(The only files or dirs you may create or modify.)
- `<path>`

## Do not modify
(Especially shared files that belong to other agents or to the main agent: registries, `main.rs`/`lib.rs`, `Cargo.toml`/`package.json`, route tables, CI config, test config.)
- `<path>`

## Constraints
- Do not commit, stash, or run any git write command. The main agent handles git.
- Build and test offline with the dependencies already present. Do not add dependencies unless this brief allows it.
- If something fails because of the sandbox (permissions, ACL/DPAPI, missing caches, network), stop and report it. Do not change build output dirs, test config, environment handling or other code to get around the sandbox.
- Do not weaken, skip or delete tests to make them pass.
- No secrets, tokens, webhook URLs or real device/account IDs in code, tests, fixtures or your report. Use obviously fake values (e.g. on a reserved `.invalid` host).
- UI text, user-facing docs and code comments describe the product only. Never write the requirements or boundaries from this brief into them ("as requested, X is disabled", "note: this tool must not…", `// user asked for green`). If a feature is deliberately absent, leave it absent without announcing it. Comments explain only non-obvious technical reasons.
- (Task-specific constraints: style, performance budgets, API compatibility…)

## How to verify
(The exact commands, run from the working directory, and what counts as passing. Use the sandbox-ready form: absolute interpreter paths, caches pointed inside the workspace, `--offline`. List any gate it cannot run in the sandbox and tell it to skip and report that gate.)
```
<e.g. cargo test --offline -p foo>
<e.g. bun run check && bun run test>
```

## Final message
Reply in Traditional Chinese with:
1. The files changed or created, with a one-line purpose for each.
2. Each verification command you ran and its result (pass/fail counts). Mark any failure you believe is caused by the sandbox.
3. Anything not done, any deviation from the authoritative documents, and any open questions.

(For a read-only review, replace this section with: "Put your full review in the final message: findings ordered by severity, each with file:line, the concrete failure scenario, and a suggested fix. Say explicitly which focus areas you found no problems in.")

---

## Review brief variant (Astra, read-only)

For an independent review, keep Goal, Authoritative documents and Final message, and replace "Files you own" with:

## Scope
- The changes to review: `<git diff range, or a file list>`
- Focus areas: (name areas, not suspicions, e.g. "concurrency in the hot channel worker", "error paths in config loading", "does the UI match the contract's state table")
- Out of scope: (style nits, unrelated legacy code…)

## Constraints
- Read only. You cannot write files, so the whole deliverable goes in your final message.
- Verify each finding against the code before reporting it. Separate confirmed problems from suspicions.
