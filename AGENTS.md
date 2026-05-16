# Local Agent Instructions

## PowerShell Runtime

- Use PowerShell 7.6.1 or newer for this repository. Invoke it as `pwsh`.
- Do not use Windows PowerShell 5.1 (`powershell.exe`) for normal validation or project scripts.
- When updating examples, prefer `pwsh -NoProfile -File ...`.
- Keep `.ps1` source files ASCII-only. Put localized content in UTF-8 Markdown or data files.
- Treat terminal-rendered CJK text as untrusted; verify it through file bytes, structured checks, browser rendering, screenshots, or a known-good UTF-8 diff.
