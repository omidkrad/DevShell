# DevShell PS Profile

Write-Host "=== Developer's Command Shell ==="

$MaximumHistoryCount = 1024

if ($Host.Version.Major -lt 5)
{
    Write-Warning "Please use PowerShell 5.0 or newer."
}

function Set-DevRootEnvVars([string]$path)
{
    $env:DevRoot = Get-Item $path
    $env:Share = Get-Item $env:DevRoot\share
    $env:Src = Get-Item $env:DevRoot\src
    $env:Tools = Get-Item $env:DevRoot\tools
}

Set-DevRootEnvVars -path $PSScriptRoot\..
Add-PathVariable $env:Share, $env:Share\SysInternals

New-PSDrive -Name Dev -PSProvider FileSystem -Root $env:DevRoot | Out-Null
Set-Location Dev:\src

# dot-source all profile scripts
Get-ChildItem $PSScriptRoot\scripts\*.ps1 | sort -Property Name | foreach { 
    Write-Debug "Loading:`t$($_.Name)"
    . $_
}
