# Local Agent Instructions

## PowerShell Runtime

- Use PowerShell 7.6.1 or newer for this repository. Prefer MSI for PowerShell 7.6 and invoke it as `pwsh` from `C:\Program Files\PowerShell\7\pwsh.exe`. Check official packaging and the executable path for later releases.
- Check Microsoft Store / MSIX path, profile, and remoting limitations before using it for automation.
- Do not use Windows PowerShell 5.1 (`powershell.exe`) for normal validation or project scripts.
- When updating examples, prefer `pwsh -NoProfile -File ...`.
- Keep `.ps1` source files ASCII-only as this repository's portability policy. Put localized content in UTF-8 Markdown or data files; PowerShell 7 itself can run UTF-8 scripts containing localized text.
- Treat terminal-rendered CJK text as untrusted; verify it through file bytes, structured checks, browser rendering, screenshots, or a known-good UTF-8 diff.
