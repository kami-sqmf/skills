---
name: to-batches
description: Break a plan into ordered batches of tracer-bullet tickets, each declaring the tickets that block it, written to docs/plans/<feature>/tickets/ (or a real tracker if the project uses one). Use when the user types /to-batches or says "拆批次", "拆工單", "排順序".
disable-model-invocation: true
---

# To Batches

Talk to the user in Traditional Chinese; tickets are written in Traditional Chinese.

Break a plan into **tickets** grouped into **batches**. A ticket is a tracer-bullet vertical slice that declares the tickets that **block** it. A batch is a set of tickets that gets implemented, reviewed and accepted together.

The tracker setup should be in `docs/agents/issue-tracker.md`. If it is missing, use the default: local files under `docs/plans/<feature>/tickets/`.

## Process

### 1. Gather context

Work from the plan (`docs/plans/<feature>/plan.md`), its 狀態展開 section, and the conversation. Read the full plan if you were only given its path.

### 2. Explore the codebase (if you haven't)

Use the project's `GLOSSARY.md` vocabulary in titles and descriptions, and respect ADRs in the area. Look for prefactoring that makes the work easier: "make the change easy, then make the easy change".

### 3. Draft vertical slices

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests): vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring is done first
- Each slice names the situations from 狀態展開 it covers, so every situation lands in exactly one ticket

</vertical-slice-rules>

Give each ticket its **blocking edges**: the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change (rename a column, retype a shared symbol) whose **blast radius** fans across the whole codebase, so no vertical slice can land green. Sequence it as **expand, migrate, contract**: first add the new form beside the old so nothing breaks; then migrate call sites in batches sized by blast radius, each blocked by the expand, keeping checks green because the old form still exists; finally delete the old form in a ticket blocked by every migrate batch.

### 4. Order into batches

Order by these principles, in this priority:

1. **Foundations first**: what several features share.
2. **Money savers first**: anything that makes every later live test cheaper (a cache, a fixture recorder).
3. **High-risk and live-test work early**; pure UI later, or split out to run in parallel.
4. **Every batch independently reviewable and acceptable**.

Mark which batches can run in parallel: research, read-only analysis, UI spec drafts, and batches whose code doesn't overlap. Keep in sequence: batches that touch the same files, work that needs a particular machine, and work that needs live testing on real hardware.

### 5. Confirm with the user

Show the batches as a numbered list. For each ticket: **title**, **blocked by**, **what it delivers**. Granularity, edges and order are your call (technical trade-offs): decide them and say so. Ask on one question card only when the order or the split changes what the user gets when (for example, a feature they expected early lands last).

### 6. Write the tickets

- **Local files** (default) → one file per ticket under `docs/plans/<feature>/tickets/<NN>-<slug>.md`, numbered from `01` in dependency order (blockers first). Never one combined file.
- **A real tracker** (GitHub, GitLab) → one issue per ticket in dependency order, using native blocking links where the platform has them.

Then fill the plan's 「5. 批次」 section: each batch, its tickets, what it depends on, and how it is accepted.

<local-ticket-template>

# <NN>: <工單標題>

**批次**：<批次編號>

**要做什麼**：這張工單完成後，從使用者角度能用的完整行為。不要列各層的實作清單。

**被擋住**：擋住這張工單的工單編號與標題，或「無（可以立刻開始）」。

**涵蓋的狀況**：狀態展開中對應的狀況。

**驗收**：

- [ ] 驗收條件 1
- [ ] 驗收條件 2

</local-ticket-template>

Avoid file paths and code snippets in tickets: they go stale fast. The same prototype exception as `/to-plan` applies.
