# DevShell PS Profile

if (-not $CustomEmblem) {
@"
 Welcome to
   ____              ____  _          _ _ 
  |  _ \  _____   __/ ___|| |__   ___| | |
  | | | |/ _ \ \ / /\___ \| '_ \ / _ \ | |
  | |_| |  __/\ V /  ___) | | | |  __/ | |
  |____/ \___| \_/  |____/|_| |_|\___|_|_|

   ====== THE Developer PowerShell ======

"@ # http://patorjk.com/software/taag/#p=display&f=Ivrit&t=DevShell
}
else
{
    Write-Output $CustomEmblem
}

if ($Host.Version.Major -lt 5)
{
    Write-Warning "Please use PowerShell 5.0 or newer."
}

Set-PSDebug -Strict
$MaximumHistoryCount = [Math]::Max($MaximumHistoryCount, 4096)

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

# Create user scripts folder
$private:UserScriptsDir = "$ScriptsDir\user"
if (-not (Test-Path $UserScriptsDir)) {
    mkdir $UserScriptsDir | Out-Null
    "Add your user-specific scripts in this folder to load when the shell starts." |
        Out-File $UserScriptsDir\readme.txt
}

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
    # Reset location before each import so all scripts can assume same starting location
    Set-Location $env:SrcDir
    . $_
}

# Set user's landing location
if ($UserSettings.ProjectPath -and (exist $UserSettings.ProjectPath)) {
    Set-Location $UserSettings.ProjectPath
} else {
    Set-Location Dev:\src
}
