---
name: setup-project
description: "Decide this project's layer the first time the agent works in it: where plans and tickets live, the check commands, how live testing works, how deployment works, and which agents do what. Writes docs/agents/ and an Agent skills block in CLAUDE.md. Use when the user types /setup-project, or when another skill needs project facts that docs/agents/ doesn't have yet."
disable-model-invocation: true
---

# Setup Project

Talk to the user in Traditional Chinese; the files you write are in Traditional Chinese.

The workflow skills are generic. Everything specific to one project lives in its **project layer**, under `docs/agents/`. This skill writes it. It is prompt-driven, not a script: explore, present what you found, ask only what you can't find, then write.

## 1. Explore

Read whatever exists; assume nothing:

- `git remote -v`: is there a GitHub or GitLab remote?
- `CLAUDE.md` / `AGENTS.md` at the root, and any existing `## Agent skills` block.
- `docs/agents/`: is there earlier output of this skill? Then update it instead of starting over.
- `GLOSSARY.md`, `GLOSSARY-MAP.md`, `docs/adr/`, and the legacy `CONTEXT.md` (offer to `git mv` it to `GLOSSARY.md`).
- `docs/plans/`, `plans/`, `.scratch/`: where plans already live.
- Build and check commands: `package.json` scripts, `Cargo.toml`, `pyproject.toml`, `Makefile`, `scripts/check*`, CI workflows.
- Live-testing and release docs: anything like `LIVE-TESTING.md`, `RELEASE.md`, release scripts.
- Monorepo signals (`pnpm-workspace.yaml`, `workspaces`, populated `packages/*`), which decide single- or multi-context domain docs.

## 2. Present and ask

Summarise what you found in a few lines. Most answers come from exploration; decide the technical ones yourself and list them (「我直接定了」). Ask the rest on **one question card**, with your recommendation first:

- **Where plans and tickets live**: default `docs/plans/<feature>/` (plan.md, tickets/, reports/) with research in `docs/research/<feature>/`. Offer GitHub or GitLab Issues only when a remote exists and the user works with others there.
- **Live testing**: is there a way to test on the real thing (a device, a remote machine, a game, production-like data)? If exploration found a doc, propose it; otherwise ask whether this project has live testing at all.
- **Deployment**: only if exploration found release steps, confirm them; never invent a deploy.
- **Who does what**: propose the default split below, changed only where the project clearly needs it (a frontend-heavy repo, a project with no Codex access).

Default split:

| Role | Default |
|---|---|
| Research (web, docs) | Claude subagent |
| Research (repo, measurements) | Codex, newest Astra, read-only |
| Implementation, backend | Codex, newest Sol |
| Implementation, frontend | Claude subagent |
| Review, finder | Codex, newest Astra, read-only |
| Review, judge | Claude subagent on Fable |

## 3. Write

Show a short draft, then write:

- `docs/agents/workflow.md` from [workflow.md](./workflow.md): check commands, live testing, deployment, the role split, and any sandbox adjustments Codex needs for this project's tests.
- `docs/agents/issue-tracker.md` from [issue-tracker-local.md](./issue-tracker-local.md), [issue-tracker-github.md](./issue-tracker-github.md) or [issue-tracker-gitlab.md](./issue-tracker-gitlab.md).
- `docs/agents/domain.md` from [domain.md](./domain.md), single-context unless exploration found monorepo signals.
- `docs/agents/triage-labels.md` from [triage-labels.md](./triage-labels.md), only if the project uses a real tracker and `triage`; keep the default labels unless the tracker already has others.

Add or update one block in `CLAUDE.md` (or `AGENTS.md` if only that exists; if neither exists, create `CLAUDE.md`). Update an existing block in place; don't touch the user's other sections:

```markdown
## Agent skills

- 工作流（檢查、實測、部署、代理分工）：`docs/agents/workflow.md`
- 計畫與工單：`docs/agents/issue-tracker.md`
- 詞彙表與 ADR：`docs/agents/domain.md`
```

## 4. Done

Tell the user it's set up, which skills read these files, and that they can edit `docs/agents/*.md` directly at any time. Don't commit unless the user asks.
