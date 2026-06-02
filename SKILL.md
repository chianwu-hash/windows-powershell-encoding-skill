---
name: windows-powershell-encoding-skill
description: Avoid Unicode and UTF-8 corruption when Codex works on Windows with PowerShell, especially in Chinese/CJK projects. Use when editing or generating PowerShell scripts, running shell commands that read or write non-ASCII text, handling UTF-8 files, diagnosing mojibake, or validating whether terminal-displayed Chinese text is trustworthy.
---

# Windows PowerShell Encoding

Use this skill as a guardrail whenever Windows, PowerShell, Codex tool execution, and non-ASCII text overlap.

## Requirements

- Use PowerShell 7.6.1 or newer for validation scripts and examples.
- Invoke it as `pwsh`, not Windows PowerShell 5.1 (`powershell.exe`).
- Strongly recommend PowerShell 7.6.1+ for users who will run AI-generated PowerShell commands or process Chinese/CJK files on Windows.
- Treat Windows PowerShell 5.1 as a legacy compatibility target only, not the normal runtime for Chinese/CJK AI workflows.

PowerShell 7.6.1 reduces many default encoding pitfalls by using UTF-8-oriented defaults, but it does not make terminal rendering, external tools, legacy Big5 files, or copy/paste workflows automatically safe.

## Runtime Split

Before diagnosing or writing localized text, identify the environment:

- `pwsh` 7.6.1+: recommended Windows-native route. Defaults are mostly UTF-8-oriented, but terminal rendering, external tools, legacy Big5 input, and copy/paste remain risk areas.
- Windows PowerShell 5.1: legacy route. Default `Set-Content`, `Out-File`, redirection, and native-command boundaries can use different encodings. Avoid it for normal Chinese/CJK file workflows.
- Git Bash: often UTF-8-friendly, but Windows-native tools launched through it can still cross back into Windows code page behavior.
- WSL: usually the cleanest UTF-8 route, but crossing into Windows paths or Windows executables reintroduces Windows encoding boundaries.

## Core Rules

- Treat Windows terminal output as an unreliable rendering layer for non-ASCII text.
- Do not use terminal-rendered Chinese/CJK text as the final source of truth.
- Verify non-ASCII text through UTF-8 files, browser/page rendering, screenshots, structured parser output, or `git diff`.
- Check `$PSVersionTable.PSVersion`, `[Console]::InputEncoding`, and `[Console]::OutputEncoding` when a task involves shell I/O, native commands, or diagnosing mojibake.
- Keep `.ps1` source files ASCII-only when practical.
- Do not put raw Chinese/CJK literals into PowerShell inline scripts, heredocs, generated `.ps1` files, or shell redirections.
- Put non-ASCII content in UTF-8 data files, or encode it in an ASCII-safe form such as Base64 or `\uXXXX` escapes and decode at runtime.
- When reading or writing text files from scripts, specify UTF-8 explicitly.
- Avoid relying on default `>`, `>>`, `Out-File`, `Set-Content`, and `Add-Content` behavior for non-ASCII text unless the PowerShell version is known, the encoding is explicit where needed, and the result is verified.
- For cross-version BOM-less UTF-8 writes, prefer a runtime/API that can specify UTF-8 without BOM explicitly, such as `[System.IO.File]::WriteAllText($path, $text, [System.Text.UTF8Encoding]::new($false))`.
- If a terminal shows `???`, replacement characters, or mojibake, stop before saving, publishing, or committing any affected text.

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

If this skill includes `scripts/assert-no-nonascii-ps1.ps1`, run it from the project root before finishing PowerShell changes. Use the script from the skill directory, or copy it into the target project first:

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
