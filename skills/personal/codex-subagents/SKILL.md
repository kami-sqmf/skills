---
name: codex-subagents
description: Delegate coding, review, analysis or benchmark work to OpenAI Codex CLI subagents (`codex exec`), choosing the newest Sol model for implementation and the newest Astra model for review. Use this whenever the user asks to use Codex, Sol, Astra, "子代理" / subagents, parallel agents, an independent review, or to offload or split up a sizeable implementation, refactor, test-writing, audit or benchmark task. Also use it when you plan to fan out work, because the user has more Codex quota than Claude quota and prefers Codex for subagents.
---

# Codex subagents

The user has more Codex quota than Claude quota, so for sizeable delegable work, prefer Codex subagents over Claude subagents. Codex is a capable but separate agent. It sees only the brief you write and the files in its working directory. It runs in a sandbox with real limits, and its report is a claim that you still have to check.

Talk to the user in Traditional Chinese. Ask Codex for its final report in Traditional Chinese too, so you can pass it on without translating.

## Choosing the model by role

Pick a **role**, not a model name. Codex ships new generations often, and a hard-coded name silently keeps you on the previous one.

| Role | Use for | Sandbox |
|---|---|---|
| `sol` | Implementation, fixes, tests, refactors, experiments that write scratch files | `workspace-write` |
| `astra` | Independent review, analysis, audit, investigation | `read-only` |
| `terra` | Work that needs visual understanding or computer use (screenshots, UI comparison) | as the job needs |
| `luna` | Trivial, mechanical checks | `read-only` |

The newest listed model of each family is in `~/.codex/models_cache.json` (entries with `"visibility": "list"`; the highest version number in `gpt-<version>-<role>` wins). The Windows launcher resolves it for you; `-ListModels` prints what each role resolves to. Elsewhere, read the cache yourself before launching. On 2026-11-27 the roles resolved to `gpt-6.2-sol`, `gpt-6.2-astra`, `gpt-6.1-terra` and `gpt-6-luna`. Override with an explicit model only when the user names one.

**Reasoning effort.** Pass it explicitly every time, because the user's config default may differ.
- `high` (the launcher's default) for implementation, fix rounds, and reviews of a real change set.
- `medium` for small, self-contained jobs: one short file, a single-function fix, a quick investigation. A 30-line review at `high` took about 10 minutes in testing.
- `low` only for trivial checks. `xhigh`, `max` and `ultra` exist but cost much more time and quota: only when the user asks.

**Fast mode** (`-c service_tier=priority`, the launcher's `-Fast`) costs more quota. Use it only when the user asks, and only for the rounds they name. The user's `~/.codex/config.toml` belongs to them: never edit it. It may set `service_tier` or `model_reasoning_effort` globally, which then applies to every run; glance at it (read-only) and tell the user when it conflicts with what they asked for.

## Running one agent

### Windows

Codex is the Microsoft Store app and not on PATH. Use the bundled launcher, which handles the Windows pitfalls under "Things that go wrong":

```powershell
& "$HOME\.claude\skills\codex-subagents\scripts\Invoke-Codex.ps1" `
    -Brief <brief.md> -Dir <working dir> -Report <final-report.md> `
    [-Role astra] [-Sandbox read-only] [-Effort high] [-Fast] [-Log <path>] [-AddDir <dir>,...]
```

- Run it with the PowerShell tool and `run_in_background: true`. You get a notification when it finishes; don't poll or sleep.
- The log defaults to `<report>.log`, with stderr in `<report>.log.stderr`. The launcher prints the exit code, the report size and any `%TEMP%\codex-security-artifacts-*` folders the run created; Codex sometimes writes deliverables there instead of the workspace.
- Read reports with `Get-Content -Raw -Encoding utf8` (or the Read tool). Without `-Encoding utf8`, Windows PowerShell 5.1 garbles the Chinese.

### Linux and macOS (not yet tested by this user)

`codex` is normally on PATH there. Resolve the model from the cache as above, then:

```bash
codex exec -m <model> -c model_reasoning_effort=high --sandbox workspace-write \
  -C <dir> -o <report.md> - < <brief.md> > <log> 2>&1
```

Run it in the background, add `--skip-git-repo-check` when `<dir>` is outside a git repo, and pass the brief on stdin with `-`. If `codex` is not found or the run fails in a way not covered here, tell the user what happened instead of working around it, and suggest recording the fix in this skill.

Wherever it runs, keep briefs, reports and logs outside the repository (the scratchpad or a notes folder) so they don't end up in `git status`.

## Writing the brief

The brief is the only context Codex gets. Start from `references/brief-template.md` and fill in every section:

1. **Goal**: what "done" looks like, in a few sentences.
2. **Authoritative docs**: paths to the plan, contract or ADR it must follow. Write the contract before you brief; parallel agents that share a written contract stay consistent.
3. **Files owned / forbidden**: exactly what it may change and what it must not touch.
4. **Constraints**: don't commit (its sandbox can't write `.git`); build offline with dependencies already present; report sandbox failures instead of working around them; don't edit test config, build output dirs or CI files to make things pass; no secrets or real IDs anywhere; the requirements and boundaries in the brief never get written into UI text, user-facing docs or code comments (they describe the product, not the conversation).
5. **Exact test commands** that work inside the sandbox, and what counts as passing. Run them once yourself first. Before writing them, check which runtimes are actually on PATH (`python`, `node`, `bun`, `uv`) and where package caches live; the sandbox often can't write to the user's normal caches, so point them inside the workspace and say you'll clean them up. Project-specific adjustments live in the project layer (`docs/agents/workflow.md`).
6. **Final message format**: in Traditional Chinese, listing files changed, tests run with results, and anything not done, deviating from the plan, or blocked by the sandbox.

Never put secrets in a brief: no tokens, passwords, webhook URLs or real device or account IDs, and no fake values shaped like them either (they get copied verbatim). Describe them instead. If the work needs a secret, have the code read it from config or the environment.

If a gate truly can't run in the sandbox (network, OS keychain or ACL tests), tell Codex to skip and report it; you run it yourself afterwards.

**Reviews.** Give Astra the areas to focus on, not your conclusions: "check concurrency in X and error handling in Y", never "I think X has a race, confirm it". Ask for every finding with a concrete failure scenario (what input or state leads to what wrong result) and the axis it belongs to (follows the standards, or follows the plan). The severity call is not Astra's: in the `plan-review` flow a separate judge sorts findings into 必修 / 建議 / 小毛病, and only 必修 goes to a fix round.

## Parallel rounds

- At most **4** agents at once, each with **explicitly disjoint file ownership** written into its brief. Shared files (module registries, `main.rs`, `Cargo.toml`, route tables) belong to exactly one agent, or you wire them in yourself afterwards.
- **Pre-wire shared files before launch**: add the lines every agent needs (`mod notify;`, a route, an import) with empty stubs, so each can compile without touching the shared file. Tell each agent that compile errors from another agent's unfinished directory aren't its job.
- **Same tree or worktrees?** A worktree per agent works only if the base commit already contains everything the agents need. If the work builds on uncommitted changes, run all agents in the same tree with disjoint files.
- Merging worktree results with `git diff | git apply` can fail on CRLF/LF differences; if so, copy the changed files over and review with `git diff`.
- Put the shared contract where every agent can read it **before** launch (inside the working directory, or a folder passed with `-AddDir`).
- Launch all agents in one message as separate background tool calls, each with its own brief, report and log, then wait for every notification before merging or verifying.

## Verifying results

Treat every Codex report as a claim. Before you report success:

1. **Read the diff** (`git diff --stat`, then the files). Check it stayed inside its owned files. Look for sandbox workarounds that look like progress: changed test config, redirected build output, a fallback added to non-owned code, a skipped or weakened test.
2. **Rerun every gate yourself, outside the sandbox**: build, full tests, lint, type checks. The sandbox causes false failures, and its passes mean little if it changed the test setup. Your rerun is the source of truth.
3. Check it did what the brief asked, not just something plausible.
4. Commit only if the user wants commits.

Known sandbox limits (expected, not bugs in the agent's work): it can't write `.git`; OS-protected storage and ACL tests fail; it may not see the user's package caches, so offline builds can fail on dependency resolution; in `read-only` it can't write any file, so ask for the whole deliverable in its final message, which `-o` captures.

## Things that go wrong

- **"helper not found", or a log that stops advancing (Windows).** The Store auto-updated Codex and deleted the old versioned folder under a running agent. Check `(Get-AppxPackage OpenAI.Codex).Version`, then relaunch with the launcher (it resolves the path fresh) against the same directory, with a brief that says what is already done. Never cache the codex.exe path.
- **"Not inside a trusted directory" / git repo check.** `-C` points outside a git repo, so it needs `--skip-git-repo-check`. The Windows launcher adds it automatically.
- **No report file.** Read the log and stderr tails. Common causes: a bad model name, an auth or quota error, or a crash.
- **Garbled Chinese (Windows).** You read the report without `-Encoding utf8`, or piped the brief through a PowerShell string. The launcher redirects stdin from the file, so this can't happen there.
