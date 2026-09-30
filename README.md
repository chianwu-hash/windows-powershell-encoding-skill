# windows-powershell-encoding-skill

A Codex skill for avoiding Unicode, UTF-8, and mojibake failures when Windows, PowerShell, terminal rendering, and Chinese/CJK text overlap.

## Requirements

- PowerShell 7.6.1 or newer for validation scripts and examples.
- For PowerShell 7.6 on Windows AI/CJK workflows, install the MSI when available. Prefer:

```powershell
winget install --id Microsoft.PowerShell --source winget --installer-type wix
```

- Invoke PowerShell as `pwsh`, preferably from `C:\Program Files\PowerShell\7\pwsh.exe` for the 7.6 MSI installation, not Windows PowerShell 5.1 (`powershell.exe`).
- For PowerShell 7.6, treat Microsoft Store / MSIX PowerShell as a casual or policy-constrained option. Check its path, profile, and remoting limitations before using it for automation, especially on later releases without MSI.
- Treat Windows PowerShell 5.1 as a legacy compatibility target, not the recommended runtime for CJK/Chinese AI workflows.

PowerShell 7.6.1 reduces many default encoding pitfalls by using UTF-8-oriented defaults, but it does not make terminal rendering, external tools, legacy Big5 files, or copy/paste workflows automatically safe. This skill remains a workflow guardrail for those remaining risks.

Microsoft states that PowerShell 7.7 will not provide an MSI package. Check the official installation options for the version being installed before recommending an upgrade. The ASCII-only PowerShell source check in this repository is a conservative portability policy, not a PowerShell 7 requirement.

## Runtime Guidance

Use this order when choosing an execution environment:

1. Prefer PowerShell 7.6 MSI (`pwsh`) for Windows-native AI/CJK work on 7.6.
2. For later releases, check the official package options; when using MSIX / Store PowerShell, confirm path/profile/remoting assumptions.
3. Use Windows PowerShell 5.1 only when compatibility requires it, and avoid relying on its default file encodings.
4. Use WSL or Git Bash when the workflow already fits those environments, but still check boundaries where Windows-native tools are called.

The goal is version-aware safety: first identify the shell and encoding boundary, then choose the matching read/write pattern, then verify the result outside terminal rendering.

## Validation

Run the environment diagnostic and this repository's ASCII-only PowerShell source check with PowerShell 7.6.1+:

```powershell
pwsh -NoProfile -File .\scripts\diagnose-powershell-encoding.ps1
```

```powershell
pwsh -NoProfile -File .\scripts\assert-no-nonascii-ps1.ps1
```
