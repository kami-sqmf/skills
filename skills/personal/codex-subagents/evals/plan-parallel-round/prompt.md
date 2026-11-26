---
tags: [skill-creator]
max_turns: 40
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash, PowerShell]
---

我在做一個 Rust + Svelte 的螢幕牆專案（repo 在 D:\demo\wall，有一些還沒 commit 的改動是這次功能要用到的）。這次要加三個彼此獨立的東西：
1. 後端 src/notify/ 新增 Discord 通知模組（webhook 網址從設定檔讀）
2. 後端 src/exam/ 新增考試偵測模組
3. 前端 web/src/pages/settings/ 新增「通知設定」頁
三個都要接到 src/main.rs 和 web/src/App.svelte。
幫我規劃怎麼丟給 Codex 平行做：把每個 agent 的 brief 寫成檔案、給我啟動指令，先不要真的啟動，我要先看。
