# fa-study-kit colour and type tokens

The visual theme for results reports and the manual (from the `fa-study-kit` npm package). Use the tokens, never literal colours; no emoji; don't name the theme on the page.

```css
:root{
  --bg:#f6f2e0;--paper:#fdfbf4;--meadow:#dde7c6;--ink:#2b2a20;--ink-2:#5e5b47;--line:#e1dabb;--accent:#46602f;--moss:#a7c283;--sprout:#cbdeab;--bark:#73482a;
  --red:#96392c;--red-soft:#f4dfd2;--blue:#2c5c6b;--blue-soft:#dae7e1;--gold:#76540f;--gold-soft:#f1e3b6;
  --mono:"JetBrains Mono","SF Mono",Menlo,Consolas,monospace;
  --display:"GenSenRounded2 TW","Zen Maru Gothic","LINE Seed TW","Noto Sans TC",sans-serif;
  --sans:"LINE Seed TW","Noto Sans TC","PingFang TC","Microsoft JhengHei",system-ui,sans-serif}
@media (prefers-color-scheme: dark){:root:not([data-theme="light"]){color-scheme:dark;
  --bg:#1f241a;--paper:#292f23;--meadow:#333d2b;--ink:#ece6d2;--ink-2:#b5b29b;--line:#3e4735;--accent:#b7c98c;--moss:#67794b;--sprout:#47563b;--bark:#d6b48d;
  --red:#eba593;--red-soft:#40291f;--blue:#a3cad0;--blue-soft:#253535;--gold:#e0c070;--gold-soft:#3b351f}}
:root[data-theme="dark"]{color-scheme:dark;
  --bg:#1f241a;--paper:#292f23;--meadow:#333d2b;--ink:#ece6d2;--ink-2:#b5b29b;--line:#3e4735;--accent:#b7c98c;--moss:#67794b;--sprout:#47563b;--bark:#d6b48d;
  --red:#eba593;--red-soft:#40291f;--blue:#a3cad0;--blue-soft:#253535;--gold:#e0c070;--gold-soft:#3b351f}
body{background:var(--bg);color:var(--ink);font-family:var(--sans)}
```

Fonts: `https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;600&family=Noto+Sans+TC:wght@400;700&display=swap`.

Conventions from the kit: dashed `--moss` borders on callouts and collapsibles, `--accent` headings with a dashed bottom rule, status colours from the `--red` / `--gold` / `--blue` pairs (soft background, strong text), tables inside a rounded `--paper` box with `--sprout` header cells.
