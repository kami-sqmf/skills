---
name: grilling
description: Interview the user about a plan, decision, or idea until every branch of the design tree is resolved, asking only the decisions that are theirs, through question cards. Use when the user wants to stress-test their thinking, says "訪談我", "Interview me", "確認想法一致", or uses any 'grill' trigger phrase.
---

Interview the user until you reach a shared understanding. Talk to them in Traditional Chinese. Map the work as a **design tree**: every decision branches into the decisions that hang off it.

## Whose decision is it

Sort every open decision before you ask anything:

- **The user's**: goal and scope (whether to build it, what it should become), how the result looks, changing something the user's own documents specified, anything that costs money, anything outward-facing (commit, push, publish, send, write to production), anything irreversible.
- **Yours**: technical trade-offs (architecture, implementation approach, order, thresholds and defaults, how much to test, naming, file locations, which agent or tool). Decide them, say 「我直接定了」 with a one-line reason, and record them under 「主代理自定」 in the plan. The user can overrule any of them later.
- **Grey area**: ask yourself "when the user sees the result, could they feel it isn't what they wanted?" If yes, it's theirs.

Finding **facts** is your job, never the user's. When a decision needs a fact from the environment (files, tools, the web), look it up yourself or dispatch a subagent with a fresh context window. Don't ask the user for anything you could find.

## Rounds

The **frontier** is every user decision whose prerequisites are already settled: the questions you can ask now without guessing at answers you haven't heard. A question whose answer depends on another question still open belongs to a later round.

Each round:

1. List, in a few lines, what you decided yourself this round (「這輪我直接定了」).
2. Ask the frontier with **one question card** (`AskUserQuestion`): at most 4 questions per card. If the frontier is bigger, ask the most upstream ones and keep the rest for the next round.
3. **Stop and wait** for the answers. Don't carry on with work that depends on them.

Writing the card:

- Each question stands on its own: the user may not see your message while the card is open. Name the thing you're asking about inside the question.
- Start with a verb, use the user's own words, keep it short (about 12 characters of Chinese).
- 2 to 4 options. Your recommendation goes first, labelled "(Recommended)". Each option says in one sentence what happens if chosen, without arguing its merits. Put the reason for your recommendation in numbers where you can.
- Use `multiSelect` when the choices aren't exclusive.
- If the user answers with something other than an option, take it as their answer, and ask a follow-up only if it truly leaves the decision open.

Each answer reshapes the tree: settled decisions push the frontier outward. Recompute it and run the next round.

## Done

The session is done when the frontier is empty: every branch visited, nothing silently assumed. Confirm the shared understanding in one or two sentences, then act. Before acting, every decision (the user's and yours) should be written down where the work keeps its decisions (the plan's decision list, or `GLOSSARY.md` and ADRs when `domain-modeling` is running).
