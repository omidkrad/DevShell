# DevShell PS Profile

Write-Host "=== Developer's PowerShell ==="

if ($Host.Version.Major -lt 5)
{
    Write-Warning "Please use PowerShell 5.0 or newer."
}

Set-PSDebug -Strict
$MaximumHistoryCount = 1024

$env:Shell = Get-Item $PSScriptRoot
$env:DevRoot = Get-Item $PSScriptRoot\..
$private:ScriptsPath = "$env:Shell\scripts"

#region Backup and restore user file
if (Test-Path $ScriptsPath\_user.ps1) {
    # Make a backup of user script in case the repository was reset
    Copy-Item $ScriptsPath\_user.ps1 $env:Shell\.git
}
else {
    if (Test-Path $env:Shell\.git\_user.ps1) {
        # Restore user script
        Copy-Item $env:Shell\.git\_user.ps1 $ScriptsPath -Verbose
    }
    else {
        # Restore default user script
        Copy-Item $ScriptsPath\_user.ps1.txt $ScriptsPath\_user.ps1
    }
}

# Run user configuration
. $ScriptsPath\_user.ps1
#endregion

if (!$env:Src) { $env:Src = Get-Item $env:DevRoot\src }
if (!$env:Tools) { $env:Tools = Get-Item $env:Shell\tools }

New-PSDrive -Name Dev -PSProvider FileSystem -Root $env:DevRoot | Out-Null
Set-Location Dev:\src

# Import all profile scripts
$private:ScriptFiles = Get-ChildItem $ScriptsPath\*.ps[123] -Exclude _user.ps1
$private:ScriptFilesTotalSize = ($ScriptFiles | Measure-Object -Sum Length).Sum
$ScriptFiles | sort -Property Name | foreach { $private:size = 0 } {
    $size += $_.Length
    [int]$private:percent = 100 * $size / $ScriptFilesTotalSize
    Write-Progress -activity "Loading Modules ($percent%)" -Status "$($_.Name)" -PercentComplete $percent;
    . $_
}
