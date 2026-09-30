---
name: windows-powershell-encoding-skill
description: Avoid Unicode and UTF-8 corruption when Codex works on Windows with PowerShell, especially in Chinese/CJK projects. Use when editing or generating PowerShell scripts, running shell commands that read or write non-ASCII text, handling UTF-8 files, diagnosing mojibake, or validating whether terminal-displayed Chinese text is trustworthy.
---

# Windows PowerShell Encoding

Use this skill as a guardrail whenever Windows, PowerShell, Codex tool execution, and non-ASCII text overlap.

## Requirements

- Use PowerShell 7.6.1 or newer for validation scripts and examples.
- For PowerShell 7.6 on Windows AI/CJK workflows, prefer the MSI installation when available: `winget install --id Microsoft.PowerShell --source winget --installer-type wix`, or the official `.msi` installer.
- Invoke it as `pwsh`, preferably from `C:\Program Files\PowerShell\7\pwsh.exe` for a 7.6 MSI installation, not Windows PowerShell 5.1 (`powershell.exe`). Check the package path when using a later release.
- Recommend the PowerShell 7.6 MSI for users who will run AI-generated PowerShell commands or process Chinese/CJK files on Windows. For later releases, use an officially supported package and check its automation limitations.
- Treat Microsoft Store / MSIX PowerShell as a casual or policy-constrained option for 7.6; when it is the available package for a later release, check its path, profile, and remoting limitations before automation.
- Treat Windows PowerShell 5.1 as a legacy compatibility target only, not the normal runtime for Chinese/CJK AI workflows.

PowerShell 7.6.1 reduces many default encoding pitfalls by using UTF-8-oriented defaults, but it does not make terminal rendering, external tools, legacy Big5 files, or copy/paste workflows automatically safe.

Plain `winget install --id Microsoft.PowerShell --source winget` installs MSIX by default for PowerShell 7.6. Use `--installer-type wix` only for a release that still provides MSI. Microsoft states that PowerShell 7.7 will not provide MSI; check the current official installation options before recommending an upgrade.

## Runtime Split

Before diagnosing or writing localized text, identify the environment:

- PowerShell 7.6 MSI: recommended Windows-native route for AI/CJK work on 7.6. It normally lives under `C:\Program Files\PowerShell\7` and has fewer app-container surprises.
- PowerShell 7.6 MSIX / Store: UTF-8 behavior is still PowerShell 7, but the packaged-app environment can affect paths, profiles, all-users settings, remoting, and automation assumptions. For later releases, check which packages are offered and test these limits.
- Windows PowerShell 5.1: legacy route. Default `Set-Content`, `Out-File`, redirection, and native-command boundaries can use different encodings. Avoid it for normal Chinese/CJK file workflows.
- Git Bash: often UTF-8-friendly, but Windows-native tools launched through it can still cross back into Windows code page behavior.
- WSL: usually the cleanest UTF-8 route, but crossing into Windows paths or Windows executables reintroduces Windows encoding boundaries.

## Core Rules

- Treat Windows terminal output as an unreliable rendering layer for non-ASCII text.
- Do not use terminal-rendered Chinese/CJK text as the final source of truth.
- Verify non-ASCII text through UTF-8 files, browser/page rendering, screenshots, structured parser output, or `git diff`.
- Check `$PSVersionTable.PSVersion`, `$PSHOME`, `(Get-Command pwsh).Source`, `[Console]::InputEncoding`, and `[Console]::OutputEncoding` when a task involves shell I/O, native commands, or diagnosing mojibake.
- Keep `.ps1` source files ASCII-only when practical. This repository enforces that as a conservative portability policy, not because PowerShell 7 cannot run UTF-8 scripts containing CJK text.
- In this repository, avoid raw Chinese/CJK literals in PowerShell inline scripts, heredocs, and generated `.ps1` files. In other projects, follow their source policy and verify the encoding boundary.
- Put non-ASCII content in UTF-8 data files, or encode it in an ASCII-safe form such as Base64 or `\uXXXX` escapes and decode at runtime.
- When reading or writing text files from scripts, specify UTF-8 explicitly.
- Avoid relying on default `>`, `>>`, `Out-File`, `Set-Content`, and `Add-Content` behavior for non-ASCII text unless the PowerShell version is known, the encoding is explicit where needed, and the result is verified.
- For cross-version BOM-less UTF-8 writes, prefer a runtime/API that can specify UTF-8 without BOM explicitly, such as `[System.IO.File]::WriteAllText($path, $text, [System.Text.UTF8Encoding]::new($false))`.
- If a terminal shows `???`, replacement characters, or mojibake, check the underlying file bytes or Unicode text before saving, publishing, or committing affected text. A display problem alone does not prove the file is damaged.

## Preferred Patterns

For PowerShell scripts that need localized text:

1. Keep the `.ps1` file ASCII-only.
2. Store localized text in a separate UTF-8 file.
3. Read it with explicit `-Encoding utf8`.
4. Validate the result outside the terminal rendering path.

For small literals that must live inside a script:

1. Store the literal as Base64-encoded UTF-8 bytes or Unicode escapes.
2. Decode at runtime.
3. Keep the encoded `.ps1` source ASCII-only.

For file edits:

1. Prefer structured tools and patches over shell-generated text.
2. Avoid PowerShell heredocs containing non-ASCII text.
3. If a shell command must write text, write ASCII control code only and read non-ASCII payloads from UTF-8 files.
4. Do not copy CJK text from terminal output back into source files, prompts, or browser fields.

## Validation

If this skill includes `scripts/diagnose-powershell-encoding.ps1`, run it before diagnosing Windows shell encoding behavior:

```powershell
pwsh -NoProfile -File .\scripts\diagnose-powershell-encoding.ps1
```

This repository enforces ASCII-only PowerShell source. Run `scripts/assert-no-nonascii-ps1.ps1` from this repository root before finishing PowerShell changes. In another project, use it only if that project adopts the same policy:

```powershell
pwsh -NoProfile -File .\scripts\assert-no-nonascii-ps1.ps1
```

If the project has its own equivalent npm or CI command, use that command too.

## Teacher-Facing Prompt

When this skill is used in a teacher workshop or other non-engineer setting, prefer giving the learner a short prompt they can paste to their AI assistant.

Use `references/teacher-ai-prompt.md` for that copy-paste version.

## More Detail

Read `references/guardrails.md` when:

- diagnosing mojibake or mixed encodings
- deciding whether terminal output is trustworthy
- adapting the guardrail to a repo with existing PowerShell scripts
- explaining the rule to another agent or teammate
