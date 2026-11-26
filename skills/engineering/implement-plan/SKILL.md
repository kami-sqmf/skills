---
name: implement-plan
description: "Implement a whole plan from /to-plan and /to-batches in one run: batch by batch, parallel implementer subagents across the ready tickets, a capped review, checks and live tests, and an HTML results report after every batch. Use when the user types /implement-plan or says \"完成計畫\", \"把計畫做完\", \"開工\"."
disable-model-invocation: true
---

Talk to the user in Traditional Chinese.

You have a plan (`docs/plans/<feature>/plan.md`) with batches and tickets. The goal is the whole plan implemented on one **integration branch**, batch by batch, without the user having to manage the process. Stop for the user only for the four kinds of decision that are theirs (committing, publishing, changing the goal, anything irreversible) or when a review's second round still has 必修.

The tickets are a **task graph**: inside a batch there is always a **frontier** of tickets whose blockers are done.

Start every subagent with a fresh context window. Talk to subagents through **context pointers** (the plan, tickets, research notes, commits), not pasted content. Run implementers in the background for concurrency. Who implements is set in the project layer (`docs/agents/workflow.md`); by default backend work goes to a Codex subagent in the newest Sol model (see `codex-subagents`) and frontend work to a Claude subagent.

## Setup

1. Read the plan and every ticket.
2. Optionally run one exploration subagent that saves its notes outside the repo for all later subagents, so implementers spend their context on implementation.
3. Create the integration branch from the current branch.

## Every batch, five steps

1. **Contract.** Change shared types and interfaces yourself before any implementer starts. Contracts are changed only by you.
2. **Implement.** One implementer per ticket on the frontier, each in its own worktree on its own branch (or, if the work builds on uncommitted changes, all in the same tree with disjoint file ownership). Each implementer gets pointers to its ticket, the contract, and the 狀態展開 situations and offline fixtures it covers; it calls the Skill tool with "tdd", and merges the integration branch tip into its branch before reporting. Merge each finished ticket into the integration branch, and start implementers for tickets the merge unblocked. The brief never asks an implementer to write the user's requirements into UI text, docs or comments.
3. **Review.** Call the Skill tool with "plan-review" on the batch (fixed point = the batch's start). Only 必修 blocks the next batch.
4. **Check.** Run the project layer's check commands outside any sandbox. When something fails, rerun only what failed after the fix.
5. **Live test.** Follow the project layer's live-test method, if it has one. Add anything learned to the project's live-testing doc.

Then write the batch's results report and move to the next batch.

## Results report

After every batch, write a self-contained HTML page the user can read without opening the code, and record its key points in the plan.

1. **One-line result**: what this batch delivered.
2. **Before and after**: screenshots, numbers, live-test records.
3. **Acceptance criteria**: each one reached or not, with the number, shown as a status badge.
4. **Review**: how many 必修 and whether all were fixed; how many 建議 and 小毛病 and where they were recorded.
5. **Not done yet**, and what the next batch is.
6. **Something for the user to do**: at most one, only if there is one.

Build it in the style of `health-check`'s report (see that skill's `HTML-REPORT.md`): Tailwind and Mermaid from CDN, before/after visuals. Use the fa-study-kit colour tokens (see `references/fa-study-kit-tokens.md`) and the `chinese-documentation` writing rules. Save it to `docs/plans/<feature>/reports/<NN>-<batch>.html` and give the user its path; publish it as an artifact if the harness supports that.

## Finish

1. When every batch is done, tell the user the integration branch and the final report.
2. Clean up implementer worktrees.
3. Do not commit to the user's main branch, push, or open a PR unless the user asks.
