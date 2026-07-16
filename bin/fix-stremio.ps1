#requires -Version 5.1
<#
.SYNOPSIS
    Windows equivalent of fix-stremio.sh: reinstalls Stremio, clears its cached
    web-app data, and relaunches it.
.DESCRIPTION
    Uninstalls Stremio (via winget, falling back to Chocolatey), wipes the
    cached web app / server data that commonly gets Stremio stuck, reinstalls,
    and launches the app. There is no macOS-style codesigning step on Windows.
.NOTES
    Run from an elevated (Administrator) PowerShell prompt.
#>

$ErrorActionPreference = 'Stop'

function Test-Command {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

$hasWinget = Test-Command 'winget'
$hasChoco  = Test-Command 'choco'

if (-not $hasWinget -and -not $hasChoco) {
    Write-Error 'Neither winget nor Chocolatey is available. Install one of them first.'
    exit 1
}

Write-Host 'Uninstalling Stremio...' -ForegroundColor Cyan
if ($hasWinget) {
    winget uninstall --id Stremio.Stremio --silent --accept-source-agreements 2>$null
} elseif ($hasChoco) {
    choco uninstall stremio -y 2>$null
}

# Clear cached web app data
Write-Host 'Clearing cached Stremio data...' -ForegroundColor Cyan
$cachePaths = @(
    Join-Path $env:APPDATA        'Stremio'
    Join-Path $env:LOCALAPPDATA   'Stremio'
    Join-Path $env:APPDATA        'stremio-server'
    Join-Path $env:LOCALAPPDATA   'stremio-server'
)
foreach ($path in $cachePaths) {
    if (Test-Path $path) {
        Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  removed $path"
    }
}

Write-Host 'Installing Stremio...' -ForegroundColor Cyan
if ($hasWinget) {
    winget install --id Stremio.Stremio --silent --accept-package-agreements --accept-source-agreements
} elseif ($hasChoco) {
    choco install stremio -y
}

# Locate and launch the freshly installed app
Write-Host 'Launching Stremio...' -ForegroundColor Cyan
$candidates = @(
    Join-Path $env:ProgramFiles        'Stremio\stremio.exe'
    Join-Path ${env:ProgramFiles(x86)} 'Stremio\stremio.exe'
    Join-Path $env:LOCALAPPDATA        'Programs\Stremio\stremio.exe'
)
$exe = $candidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1

if ($exe) {
    Start-Process -FilePath $exe
} else {
    Write-Warning 'Could not find stremio.exe. Launch Stremio manually from the Start menu.'
}
