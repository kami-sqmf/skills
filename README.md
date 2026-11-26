<div align="center">

<img src="docs/kami/icon.svg" width="96" alt="kami-skills">

# kami-skills

**讓 AI 代理先問清楚、再動手，做完交出看得懂的成果，下次做得更好**

[![Claude Code](https://img.shields.io/badge/Claude_Code-plugin-d97757)](#安裝)
[![Codex](https://img.shields.io/badge/Codex-plugin-000000)](#安裝)
[![Skills](https://img.shields.io/badge/skills-34-46602f)](#指令一覽)
[![繁體中文](https://img.shields.io/badge/語言-繁體中文-a7c283)](global/CLAUDE.md)
[![License](https://img.shields.io/badge/license-MIT-73482a)](LICENSE)

[它解決什麼問題](#它解決什麼問題) ·
[四大塊](#四大塊) ·
[安裝](#安裝) ·
[指令一覽](#指令一覽) ·
[文件](#文件)

</div>

---

## 它解決什麼問題

跟 AI 代理合作時，常見的卡關都不在寫程式本身：

- 還沒聽懂需求就開工，做出來不是你要的
- 技術細節一直問你，真正該你決定的事反而沒問
- 審查每次都挑得出毛病，修了一輪又一輪，修不完
- 把你的要求和界線寫進畫面、文件和註解裡，給根本不需要的人看
- 換一台電腦，skill 和規則就不一樣了

這套 skill 把整個過程排成一條路，每一步都有固定做法，而且在 Claude Code 和 Codex、每台機器上都一樣。

```mermaid
flowchart LR
    A[想法] --> B["/askme<br>提問卡訪談"]
    B --> C[research<br>多代理研究]
    C --> D["/to-plan<br>規劃文件"]
    D --> E["/expand-states<br>展開狀況"]
    E --> F["/to-batches<br>拆批次"]
    F --> G["/implement-plan<br>每批實作"]
    G --> H["/plan-review<br>審查只修必修"]
    H --> I[成果報告<br>HTML]
    I --> J["/retro<br>下次怎麼改進"]
    style B fill:#46602f,color:#fff,stroke:none
    style H fill:#46602f,color:#fff,stroke:none
    style I fill:#46602f,color:#fff,stroke:none
    style J fill:#46602f,color:#fff,stroke:none
```

規劃（第 1 到第 5 步）盡量在同一個對話裡做完；實作開始後，每一批交給子代理，由主代理統籌與驗收。

## 四大塊

<table>
<tr>
<td width="50%" valign="top">

**1. 規劃（研究、解釋）**
- `/askme`：用提問卡訪談，一張卡最多 4 題、推薦選項放第一個。只問你該決定的事（目標、範圍、成品長相、花錢、對外、無法復原），技術取捨由代理自己定並列出來
- `brainstorm`：從 3 到 4 個互相獨立的角度發想，刻意補冷門點子，去重之後用提問卡讓你勾要深入的
- `explain`：一句結論先講，再分段說明原本怎麼做、原計畫怎麼做、現在怎麼改；說「圖解」就畫圖，不順便改東西
- `research`：一輪派 2 到 6 個研究代理，網路與 repo 分工，每份報告附來源，存進 `docs/research/`
- `/to-plan`：寫成 8 節的規劃文件，定案清單分「你定的」與「代理自定」
- `/expand-states`：列出每個功能會遇到的所有狀況，每種都對應一個測試
- `/to-batches`：拆成有相依關係的工單，地基先做、省錢先做、高風險往前

</td>
<td width="50%" valign="top">

**2. 審查**
- `/plan-review`：一個代理找問題（符合規範、符合計畫兩個面向分開報），另一個代理逐條判級：
  - **必修**：會壞、違反計畫、資料遺失、安全問題、把你的要求寫進產品
  - **建議**：品質可以更好，但不會壞，不擋進度
  - **小毛病**：命名、風格，只記下來
- 只修必修；修完只審改過的部分，最多 2 輪，還有必修就出提問卡問你

**3. 實作成果**
- `/implement-plan`：一個指令做完整份計畫，每批走「契約 → 實作 → 審查 → 檢查 → 實測」
- 每批交出一份 HTML 成果報告：一句話結果、前後對照、驗收指標達成狀況、審查結果、還沒做的
- 只在你要求時 commit、push

**4. 下次如何改進**
- `/retro`：把你的糾正和偏好寫進記憶、實測學到的寫進實測文件，其他改進建議用提問卡讓你挑
- `/health-check`：產生 HTML 報告，列出程式碼可以更好改的地方與前後對照圖，完全不動程式

</td>
</tr>
</table>

不知道該用哪個指令時，打 `/which`。第一次在某個專案用，先跑 `/setup-project`，把這個專案的檢查指令、實測方式、部署步驟與代理分工寫進 `docs/agents/`。

<details>
<summary><b>全程規則</b>（每次開新對話時自動載入）</summary>

- 一律用繁體中文、完整句子，結論先講，數字註明來源
- 技術取捨代理自己定，回覆裡說「我直接定了」，並記進規劃文件
- 只有目標與範圍、成品長相、改動你指定的東西、花錢、對外、無法復原的事才問你，而且用提問卡；出卡就停下來等
- 你的要求和界線不寫進介面、文件或程式註解

完整內容見 [global/CLAUDE.md](global/CLAUDE.md)。

</details>

## 安裝

這個 repo 本身就是一個公開的 plugin 市集，每台機器各做一次，之後自動更新。

**Claude Code**（Windows、Linux、macOS 都一樣）：

```
claude plugin marketplace add kami-sqmf/skills
claude plugin install kami@kami
```

桌面版也可以在「新增市集」填 `kami-sqmf/skills`。安裝後，每次開新對話會自動載入全程規則。

**Codex**：

```
codex plugin marketplace add kami-sqmf/skills
codex plugin add kami@kami
```

Claude Code 會自動更新；Codex 跑 `codex plugin marketplace upgrade`。只有 `.claude-plugin/plugin.json` 的版本號變了才會更新。

<details>
<summary><b>不用 plugin 的裝法</b></summary>

改跑 `scripts/install.ps1`（Windows）或 `scripts/install.sh`（Linux、macOS）：把每個 skill 連結進 `~/.claude/skills`，並把全程規則寫進 `~/.claude/CLAUDE.md`。同名的舊資料夾會先搬到 `~/.claude/skills-backup/`。跟 plugin 擇一，不要同時用，否則每個 skill 會出現兩次。

</details>

## 指令一覽

<details>
<summary><b>34 個 skill</b></summary>

| 類別 | Skill | 什麼時候用 |
|---|---|---|
| 規劃 | `/askme` | 「訪談我」「確認想法一致再開工」 |
| 規劃 | `brainstorm` | 「Brainstorm 一下」「有什麼點子」 |
| 規劃 | `explain` | 「展開說明」「詳細講」「圖解」 |
| 規劃 | `research` | 「深入研究」「分析利弊」 |
| 規劃 | `/to-plan` | 「寫計畫」「寫一份實作計畫」 |
| 規劃 | `/expand-states` | 「展開狀態」「有哪些狀況」 |
| 規劃 | `/to-batches` | 「拆批次」「拆工單」 |
| 規劃 | `prototype` | 「做原型」「做幾種版本比較」 |
| 規劃 | `/wayfinder` | 方向還很模糊的大專案 |
| 規劃 | `/to-questionnaire` | 答案在別人腦中，寫問卷給對方 |
| 審查 | `/plan-review` | 「審核」「對照計畫審查」 |
| 實作 | `/implement-plan` | 「完成計畫」「開工」 |
| 實作 | `/implement` | 做一張工單或一小段工作 |
| 實作 | `tdd` | 先寫失敗的測試再實作 |
| 實作 | `diagnosing-bugs` | 「怎麼又壞了」「找出問題並修正」 |
| 實作 | `pr` | 「開 PR」「寫 PR 說明」 |
| 實作 | `wizard` | 只能人工做的步驟（金鑰、DNS、主控台） |
| 改進 | `/retro` | 「回顧」「下次怎麼改進」 |
| 改進 | `/health-check` | 「健康檢查」「怎麼讓這次改動變簡單」 |
| 其他 | `/which` | 不知道用哪個指令 |
| 其他 | `/setup-project` | 第一次在某個專案用 |
| 其他 | `/handoff` | 交接給新的對話或別人 |
| 其他 | `/wait-what` | 看不懂剛剛那段，請它講白話 |
| 其他 | `/teach` | 跨多次對話學一個新概念 |
| 其他 | `/triage` | 整理別人開的 issue |
| 寫作 | `writing-fragments`、`writing-shape`、`writing-beats` | 寫文章：蒐集素材，再逐段或逐個節奏寫 |
| 個人 | `codex-subagents` | 派 Codex 子代理，自動選最新的 Sol 與 Astra 模型 |
| 個人 | `chinese-documentation` | 繁體中文寫作規範，含兩岸用語與 AI 腔 |
| 底層 | `grilling`、`domain-modeling`、`codebase-design`、`writing-for-agents` | 其他 skill 會自動用到，不用直接呼叫 |

</details>

## 文件

- [工作流](docs/kami/WORKFLOW.md)：完整流程、每個 skill 改了什麼、為什麼
- [Brainstorm 研究依據](docs/kami/BRAINSTORM-RESEARCH.md)：為什麼發想有時驚豔、有時很拉，以及對應的做法
- [全程規則](global/CLAUDE.md)

## 來源與授權

最初 fork 自 [mattpocock/skills](https://github.com/mattpocock/skills)，之後改寫成這套流程，不再同步上游。採 MIT 授權，見 [LICENSE](LICENSE)。
