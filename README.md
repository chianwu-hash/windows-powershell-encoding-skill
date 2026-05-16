# windows-powershell-encoding-skill

A Codex skill for avoiding Unicode, UTF-8, and mojibake failures when Windows, PowerShell, terminal rendering, and Chinese/CJK text overlap.

## Requirements

- PowerShell 7.6.1 or newer for validation scripts and examples.
- Invoke PowerShell as `pwsh`, not Windows PowerShell 5.1 (`powershell.exe`).

PowerShell 7.6.1 reduces many default encoding pitfalls by using UTF-8-oriented defaults, but it does not make terminal rendering, external tools, legacy Big5 files, or copy/paste workflows automatically safe. This skill remains a workflow guardrail for those remaining risks.

## Validation

Run the portable PowerShell source check with PowerShell 7.6.1+:

```powershell
pwsh -NoProfile -File .\scripts\assert-no-nonascii-ps1.ps1
```
