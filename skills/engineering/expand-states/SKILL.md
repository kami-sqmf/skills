---
name: expand-states
description: Before implementation, list every situation each feature in a plan will meet, how to detect it, what the app does and how it falls back, and pair each situation with a test or offline fixture. Use when the user types /expand-states or says "展開狀態", "有哪些狀況", "想清楚各種情況", or after /to-plan on any feature with real-world input (UI, network, recordings, OCR, timing).
---

Talk to the user in Traditional Chinese; write the section in Traditional Chinese.

Read the plan (`docs/plans/<feature>/plan.md`) and fill its 「4. 狀態展開」 section. Every situation listed here must end up with a test before live testing starts. This list is also the set of seams `tdd` tests at: no separate confirmation of seams with the user is needed.

## 1. List the situations

For each feature in the plan, list **every** situation it will meet. Think beyond the happy path. Situations that come up again and again:

- Moving or switching mid-task: re-locating, changing question, changing page, going back
- Layout changes: a different screen, a resized window, a scaled display
- Delay and loss: slow remote, network drop, a request that never returns
- Wrong input: OCR misreads, unexpected text, an empty or partial value
- Waiting: a spinner that doesn't stop, a timeout, the clock running out
- The human stepping in: the user takes over mid-run, then hands back
- Repetition: the same action twice, a retry after partial success

Drop a category only when it genuinely can't happen for this feature.

## 2. Write each situation

| 狀況 | 偵測 | 處理 | 退路 | 測試 |
|---|---|---|---|---|
| What happens | How the app knows it is in this situation | What the app does | What it does when the handling fails | The test or fixture that covers it |

## 3. Pair every situation with a test

- **Logic and backend**: a unit or integration test written red first, through `tdd`.
- **UI and integration**: an offline replay test built from an existing recording, log or screenshot. Name the exact source (folder, frame file name, `events.jsonl` line number). If no sample exists, write 「沒有樣本」 and how to produce one by hand in the preview.
- Recordings you rely on get pinned (or copied somewhere safe) right away if the project auto-deletes old ones; the project layer (`docs/agents/workflow.md`) says how.

## 4. Report

Reply with how many situations per feature, how many already have a sample, and the ones marked 「沒有樣本」. A situation the user must decide how to handle (it changes what the feature does, not just how) goes on one question card at the end.
