---
name: windows-powershell-encoding-skill
description: Avoid Unicode and UTF-8 corruption when Codex works on Windows with PowerShell, especially in Chinese/CJK projects. Use when editing or generating PowerShell scripts, running shell commands that read or write non-ASCII text, handling UTF-8 files, diagnosing mojibake, or validating whether terminal-displayed Chinese text is trustworthy.
---

# Windows PowerShell Encoding

Use this skill as a guardrail whenever Windows, PowerShell, Codex tool execution, and non-ASCII text overlap.

## Core Rules

- Treat Windows terminal output as an unreliable rendering layer for non-ASCII text.
- Do not use terminal-rendered Chinese/CJK text as the final source of truth.
- Verify non-ASCII text through UTF-8 files, browser/page rendering, screenshots, structured parser output, or `git diff`.
- Keep `.ps1` source files ASCII-only when practical.
- Do not put raw Chinese/CJK literals into PowerShell inline scripts, heredocs, generated `.ps1` files, or shell redirections.
- Put non-ASCII content in UTF-8 data files, or encode it in an ASCII-safe form such as Base64 or `\uXXXX` escapes and decode at runtime.
- When reading or writing text files from scripts, specify UTF-8 explicitly.
- Avoid `>`, `>>`, `Out-File`, `Set-Content`, and `Add-Content` for non-ASCII text unless encoding is explicit and verified.
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

If this skill includes `scripts/assert-no-nonascii-ps1.ps1`, run it from the project root before finishing PowerShell changes. Use the script from the skill directory, or copy it into the target project first:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\assert-no-nonascii-ps1.ps1
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
