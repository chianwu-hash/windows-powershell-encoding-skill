# Windows PowerShell Encoding Guardrails

## Problem

On Windows, Codex may invoke PowerShell in a non-interactive process that does not share the encoding assumptions of the user's terminal, editor, or profile. Even when files and editors are configured for UTF-8, shell output can still be decoded through a legacy code page. This can make Chinese/CJK text appear as mojibake, question marks, or replacement characters.

The dangerous case is not merely ugly output. The dangerous case is using that mangled output as input for a later write, commit, prompt, browser automation step, or publish action.

## Rules

- Treat PowerShell terminal rendering as a lossy display surface for non-ASCII text.
- Do not copy terminal-rendered Chinese/CJK text back into files, prompts, or browser forms.
- Do not use `Get-Content` output displayed in the terminal as proof that a UTF-8 file is correct.
- Do not continue after seeing `???`, `�`, or mojibake in text that may be saved or published.
- Do not put raw Chinese/CJK text in PowerShell inline commands, heredocs, or `.ps1` source.
- Prefer UTF-8 files as the boundary for localized content.
- Prefer ASCII-only `.ps1` source and decode localized strings at runtime only when needed.

## Trustworthy Sources

Use these as source of truth for non-ASCII text:

- a UTF-8 file read by a tool that preserves bytes correctly
- a browser-rendered page or screenshot
- a parser or test that checks exact file bytes or exact Unicode code points
- `git diff` viewed in an environment known to render UTF-8 correctly
- application output written to a UTF-8 artifact file, not only the terminal

## Safer PowerShell Patterns

Read UTF-8 text explicitly:

```powershell
$text = Get-Content -LiteralPath $path -Raw -Encoding utf8
```

Write UTF-8 text explicitly:

```powershell
Set-Content -LiteralPath $path -Value $text -Encoding utf8
```

For Windows PowerShell 5.1, be aware that `-Encoding utf8` writes UTF-8 with BOM. That is often acceptable for data files, but project conventions may differ. If exact BOM-less UTF-8 is required, use a runtime or API that can specify BOM-less UTF-8 explicitly.

Decode small embedded strings from Base64:

```powershell
$bytes = [Convert]::FromBase64String($base64)
$text = [System.Text.Encoding]::UTF8.GetString($bytes)
```

## Safer Agent Behavior

When acting as Codex:

1. Search and inspect files with tools that preserve enough context, but do not trust terminal-rendered CJK as final verification.
2. Use patches for source edits.
3. Keep generated PowerShell source ASCII-only.
4. Store non-ASCII payloads in separate UTF-8 files when the task needs localized text.
5. Validate with exact checks, browser rendering, screenshots, or diffs.
6. Mention any residual risk if the only available check was terminal output.

## Red Flags

Stop and re-check before writing or committing when any of these appear:

- `???` replacing localized text
- replacement characters such as `�`
- mojibake patterns after reading a known UTF-8 file
- non-ASCII text copied through a PowerShell inline command
- a `.ps1` file that contains direct localized strings
- browser automation that pastes text captured from terminal output

## Portable Check

This skill includes `scripts/assert-no-nonascii-ps1.ps1`. Run it from a repo root to fail if any `.ps1` file contains non-ASCII bytes:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\assert-no-nonascii-ps1.ps1
```

Run it with explicit roots:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\assert-no-nonascii-ps1.ps1 -Path .\tools, .\scripts
```
