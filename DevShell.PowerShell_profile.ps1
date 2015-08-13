# DevShell PS Profile

Write-Host "=== Developer's PowerShell ==="

if ($Host.Version.Major -lt 5)
{
    Write-Warning "Please use PowerShell 5.0 or newer."
}

$MaximumHistoryCount = 1024

$env:Shell = Get-Item $PSScriptRoot
$env:DevRoot = Get-Item $PSScriptRoot\..
$env:Src = Get-Item $env:DevRoot\src
$env:Tools = Get-Item $env:Shell\tools

New-PSDrive -Name Dev -PSProvider FileSystem -Root $env:DevRoot | Out-Null
Set-Location Dev:\src

# Import all profile scripts
$private:ScriptFiles = Get-ChildItem $PSScriptRoot\scripts\*.ps[123]
$private:ScriptFilesTotalSize = ($ScriptFiles | Measure-Object -Sum Length).Sum
$ScriptFiles | sort -Property Name | foreach { $private:size = 0 } {
    $size += $_.Length
    [int]$private:percent = 100 * $size / $ScriptFilesTotalSize
    Write-Progress -activity "Loading Modules ($percent%)" -Status "$($_.Name)" -PercentComplete $percent;
    . $_
}
