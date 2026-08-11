# Local Agent Instructions

## PowerShell Runtime

- Use PowerShell 7.6.1 or newer for this repository. Prefer the MSI installation and invoke it as `pwsh` from `C:\Program Files\PowerShell\7\pwsh.exe`.
- Do not use Microsoft Store / MSIX PowerShell as the default automation runtime.
- Do not use Windows PowerShell 5.1 (`powershell.exe`) for normal validation or project scripts.
- When updating examples, prefer `pwsh -NoProfile -File ...`.
- Keep `.ps1` source files ASCII-only. Put localized content in UTF-8 Markdown or data files.
- Treat terminal-rendered CJK text as untrusted; verify it through file bytes, structured checks, browser rendering, screenshots, or a known-good UTF-8 diff.
