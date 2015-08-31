# DevShell PS Profile

Write-Host "=== Developer's PowerShell ==="

if ($Host.Version.Major -lt 5)
{
    Write-Warning "Please use PowerShell 5.0 or newer."
}

Set-PSDebug -Strict
$MaximumHistoryCount = 1024

$env:ShellDir = Get-Item $PSScriptRoot
$env:DevRoot = Get-Item $env:ShellDir\..
$env:SrcDir = Get-Item $env:DevRoot\src
$env:ToolsDir = Get-Item $env:ShellDir\tools
$private:ScriptsDir = "$env:ShellDir\scripts"

New-PSDrive -Name Dev -PSProvider FileSystem -Root $env:DevRoot | Out-Null

# Set location before running scripts
Set-Location $env:SrcDir

#region Backup and Restore user file
if (Test-Path $ScriptsDir\_user.ps1) {
    # Make a backup of user script in case the repository was reset
    Copy-Item $ScriptsDir\_user.ps1 $env:ShellDir\.git
}
else {
    if (Test-Path $env:ShellDir\.git\_user.ps1) {
        # Restore user script
        Copy-Item $env:ShellDir\.git\_user.ps1 $ScriptsDir -Verbose
    }
    else {
        # Restore default user script
        Copy-Item $ScriptsDir\_user.ps1.txt $ScriptsDir\_user.ps1
        Write-Host "Please modify '$ScriptsDir\_user.ps1' for user settings." -ForegroundColor Yellow
    }
}
#endregion

# Run user configuration first
. $ScriptsDir\_user.ps1

# Import all profile scripts
$private:ScriptFiles = Get-ChildItem -Recurse $ScriptsDir\*.ps[123] -Exclude _user.ps1 |
                       Sort-Object -Property  Directory, Name
$private:ScriptFilesTotalSize = ($ScriptFiles | Measure-Object -Sum Length).Sum
$ScriptFiles | foreach { $private:size = 0 } {
    $size += $_.Length
    [int]$private:percent = 100 * $size / $ScriptFilesTotalSize
    Write-Progress -activity "Loading Modules ($percent%)" -Status "$($_.Name)" -PercentComplete $percent;
    . $_
}

# Set location again after importing scripts. Set-Location
# on different drives sets location for that drive.
Set-Location $env:SrcDir
Set-Location Dev:\src
if ($UserSettings.ProjectPath -and (exist $UserSettings.ProjectPath)) {
    Set-Location $UserSettings.ProjectPath
}
