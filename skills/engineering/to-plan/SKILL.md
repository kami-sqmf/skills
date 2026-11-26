---
name: to-plan
description: "Turn the current conversation, research and decisions into a plan document at docs/plans/<feature>/plan.md: no interview, just synthesis of what has already been discussed. Use when the user types /to-plan or says \"寫計畫\", \"寫一份實作計畫\", \"整理成規劃\"."
disable-model-invocation: true
---

Talk to the user in Traditional Chinese; the plan itself is written in Traditional Chinese.

This skill takes the conversation, the research reports and your understanding of the codebase and writes the plan. Do NOT interview the user: synthesise what you already know. If a decision that is the user's is still open (see `grilling`), list it under 「未決事項」 and ask it with one question card at the end, rather than guessing.

The tracker setup should be in `docs/agents/issue-tracker.md`. If it is missing, use the default (`docs/plans/<feature>/`) and mention `/setup-project` in one line.

## Process

1. Explore the repo if you haven't already. Use the project's `GLOSSARY.md` vocabulary throughout, and respect ADRs in the area you're touching.
2. **For a big build**, run `/health-check` pointed at this plan's area first and ask it: "how can we make this change easy?" Fold its answer into the 設計 section. Skip this for small changes.
3. Write `docs/plans/<feature>/plan.md` with the template below. Leave 狀態展開 and 批次 as headings with one line saying which skill fills them (`/expand-states`, `/to-batches`).
4. Reply with the plan's path, a three-line summary, and the list of decisions you made yourself.

Plans describe decisions, not code. Avoid file paths and code snippets except where a prototype produced a snippet (state machine, schema, type shape) that says a decision more precisely than prose; inline only the decision-rich part and note it came from a prototype.

<plan-template>

# <功能名稱> 規劃

## 1. 摘要

- **目標**：使用者原話。
- **方向**：三到五句。
- **已改的地方**：相對於上一版計畫或現況，改了什麼（第一版可省略）。

## 2. 定案清單

### 使用者定的

| 內容 | 日期 | 理由 | 依據 |
|---|---|---|---|

### 主代理自定

| 內容 | 日期 | 理由 | 依據 |
|---|---|---|---|

被推翻的決定用刪除線保留，並在新的一條寫「取代 ~~舊決定~~」。不要直接刪。

## 3. 設計

資料模型、流程圖、介面、契約（共用型別與 API）。需要圖時畫圖。

## 4. 狀態展開

由 `/expand-states` 填。

## 5. 批次

由 `/to-batches` 填。

## 6. 驗收指標

數字門檻，例如「p95 ≤ 3 秒」「每次決策 ≤ US$0.008」。每條都要能量測。

## 7. 未決事項

誰要做什麼、在等什麼。

## 8. 研究索引

| 報告 | 一行結論 |
|---|---|

</plan-template>
