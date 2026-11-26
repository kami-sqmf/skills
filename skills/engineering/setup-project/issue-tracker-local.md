# 計畫與工單：repo 內 Markdown

這個 repo 的計畫、工單、研究和成果報告都是 `docs/` 底下的 Markdown 檔。

## 慣例

- 一個功能一個資料夾：`docs/plans/<feature>/`
- 計畫：`docs/plans/<feature>/plan.md`
- 工單：一張一個檔案，`docs/plans/<feature>/tickets/<NN>-<slug>.md`，從 `01` 開始照相依順序編號，不合併成一個檔
- 成果報告：`docs/plans/<feature>/reports/<NN>-<batch>.html`
- 研究報告：`docs/research/<feature>/<agent>-<NN>-<topic>.md`
- 狀態寫在工單開頭的 `**狀態**：` 一行（`ready-for-agent`、`進行中`、`完成`）
- 討論紀錄附在檔案最後的 `## 討論` 底下

## 當 skill 說「寫進 tracker」

在 `docs/plans/<feature>/` 底下建立檔案，資料夾不存在就建立。

## 當 skill 說「讀取工單」

讀指定路徑的檔案。使用者通常會直接給路徑或工單編號。

## Wayfinder 用法

給 `/wayfinder` 用。**地圖**是一個檔案，每張**決策工單**一個子檔案。

- **地圖**：`docs/plans/<effort>/map.md`（Notes、Decisions-so-far、Fog）
- **決策工單**：`docs/plans/<effort>/issues/NN-<slug>.md`，從 `01` 編號，內文寫問題。`Type:` 一行記類型（`research`、`prototype`、`grilling`、`task`），`Status:` 一行記 `claimed` 或 `resolved`
- **相依**：開頭附近一行 `Blocked by: NN, NN`。列出的檔案都 `resolved` 時才解鎖
- **前緣**：掃 `docs/plans/<effort>/issues/` 找開放、已解鎖、未認領的檔案，編號小的優先
- **認領**：動手前先設 `Status: claimed` 並存檔
- **解決**：把答案附在 `## Answer` 底下，設 `Status: resolved`，再把一行摘要和連結加進 `map.md` 的 Decisions-so-far
