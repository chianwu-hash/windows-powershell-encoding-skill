# windows-powershell-encoding-skill

A Codex skill for avoiding Unicode, UTF-8, and mojibake failures when Windows, PowerShell, terminal rendering, and Chinese/CJK text overlap.

## Requirements

- PowerShell 7.6.1 or newer for validation scripts and examples.
- Invoke PowerShell as `pwsh`, not Windows PowerShell 5.1 (`powershell.exe`).
- Treat Windows PowerShell 5.1 as a legacy compatibility target, not the recommended runtime for CJK/Chinese AI workflows.

PowerShell 7.6.1 reduces many default encoding pitfalls by using UTF-8-oriented defaults, but it does not make terminal rendering, external tools, legacy Big5 files, or copy/paste workflows automatically safe. This skill remains a workflow guardrail for those remaining risks.

## Runtime Guidance

Use this order when choosing an execution environment:

1. Prefer PowerShell 7.6.1+ (`pwsh`) for Windows-native work.
2. Use Windows PowerShell 5.1 only when compatibility requires it, and avoid relying on its default file encodings.
3. Use WSL or Git Bash when the workflow already fits those environments, but still check boundaries where Windows-native tools are called.

The goal is version-aware safety: first identify the shell and encoding boundary, then choose the matching read/write pattern, then verify the result outside terminal rendering.

## Validation

Run the environment diagnostic and portable PowerShell source check with PowerShell 7.6.1+:

```powershell
pwsh -NoProfile -File .\scripts\diagnose-powershell-encoding.ps1
```

```powershell
pwsh -NoProfile -File .\scripts\assert-no-nonascii-ps1.ps1
```
