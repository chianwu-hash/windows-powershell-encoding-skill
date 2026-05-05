param(
    [string[]]$Path = @("."),
    [string[]]$Extension = @(".ps1", ".psm1", ".psd1")
)

$ErrorActionPreference = "Stop"

$failed = New-Object System.Collections.Generic.List[string]

foreach ($root in $Path) {
    if (-not (Test-Path -LiteralPath $root)) {
        Write-Error "Path not found: $root"
    }

    $items = Get-ChildItem -LiteralPath $root -Recurse -File -Force |
        Where-Object { $Extension -contains $_.Extension.ToLowerInvariant() }
    foreach ($item in $items) {
        $bytes = [System.IO.File]::ReadAllBytes($item.FullName)
        $bad = $false
        for ($i = 0; $i -lt $bytes.Length; $i++) {
            if ($bytes[$i] -gt 0x7F) {
                $bad = $true
                break
            }
        }

        if ($bad) {
            $failed.Add($item.FullName)
        }
    }
}

if ($failed.Count -gt 0) {
    Write-Host "Non-ASCII bytes found in checked shell source files:" -ForegroundColor Red
    foreach ($file in $failed) {
        Write-Host "  $file" -ForegroundColor Red
    }
    exit 1
}

Write-Host "OK: all checked shell source files are ASCII-only."
