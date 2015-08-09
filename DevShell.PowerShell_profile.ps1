# DevShell PS Profile

if ($Host.Version.Major -lt 5)
{
    Write-Warning "Please use PowerShell 5.0 or newer."
}

#region Misc aliases
Import-Alias $PSScriptRoot\aliases-PS.csv

function not-exist { -not (Test-Path $args) }
Set-Alias !exit not-exist -Option "Constant, AllScope"
Set-Alias exist Test-Path -Option "Constant, AllScope"
#endregion

#region Set-DevRootEnvVars
function Set-DevRootEnvVars([string]$path)
{
    $env:DevRoot = Get-Item $path
    $env:Share = Get-Item $path\share
    $env:Src = Get-Item $path\src
    $env:Tools = Get-Item $path\tools
}

if (not-exist $env:DevRoot) {
    Set-DevRootEnvVars -path $PSScriptRoot\..
}
#endregion

#region Open-CurrentFolder aliases
function Open-CurrentFolder { start . }
Set-Alias .\ Open-CurrentFolder
Set-Alias ./ Open-CurrentFolder
#endregion

#region Push-Location aliases
function Push-LocationToParent { Push-Location ..\$args }
Set-Alias .. Push-LocationToParent
Set-Alias `> Push-Location
Set-Alias `< Pop-Location
function \ { Push-Location $env:DevRoot\$args }
Set-Alias / \ -Description 'Push location to `$env:DevRoot'
#endregion

#region Sublime Text
$private:SublimeTextPath = "$env:ProgramFiles\Sublime Text 3\sublime_text.exe";
if (exist $SublimeTextPath) {
    Set-Alias st $SublimeTextPath
}
else {
    $SublimeTextPath = "$env:Tools\Sublime Text*\sublime_text.exe";
    if (exist $SublimeTextPath) {
        Set-Alias st (Get-Item $SublimeTextPath)
    }
    else {
        Write-Debug "Sublime Text path not found."
    }
}
#endregion

#region List-File function
function List-File {
    param(
        [Parameter(Mandatory=$false,
                   HelpMessage="Filename wildcard pattern", Position=0)]
        [string] $FilePattern = '*',

        [Parameter(Mandatory=$false,
                   HelpMessage="Show paths relative to current directory.")]
        [switch] $Relative
    )

    $FilePattern = $FilePattern.Replace('/', '\');
    if ($FilePattern.Contains('\')) {
        $index = $FilePattern.LastIndexOf('\');
        $FileName = $FilePattern.Substring($index + 1);
        $FilePath = $FilePattern.Substring(0, $index);
    }
    else {
        $FileName = $FilePattern;
        $FilePath = '*'
    }

    dir -Recurse -Path $FilePath -Filter $FileName | % FullName | % {
        if ($Relative) {
            % { '.' + $_.Substring($PWD.Path.Length) }
        }
        else {
            $_
        }
    }
}

Set-Alias ds List-File
function dsr { List-File -Relative $args }
#endregion

function fs { & findstr.exe /spin /a:4A $args }

function Path {
    $env:Path.Replace(';',[char]10)
}

function Open-GlobalAssemblyCache {
    Push-Location $env:SystemRoot\Assembly
    start .
}
Set-Alias gac Open-GlobalAssemblyCache

function Show-AssemblyInfo([string]$Assembly) {
    $Assembly = (Get-Item $Assembly).FullName
    [Reflection.AssemblyName]::GetAssemblyName($Assembly) | Format-List
}

function Open-GitCommit([string]$commitSHA) {
    $origin = (git config --get remote.origin.url).TrimEnd('.git')
    start "$origin/commit/$commitSHA"
}

Set-Alias whereis Where.exe

#region Set up posh-git
Push-Location $env:USERPROFILE\AppData\Local\GitHub\PoshGit_*
$env:PoshGitPath = Get-Location

# Partially borrowed from $env:PoshGitPath\profile.example.ps1
. {
    # Load posh-git module from current directory
    Import-Module .\posh-git

    # Set up a simple prompt, adding the git prompt parts inside git repos
    function global:prompt {
        $realLASTEXITCODE = $LASTEXITCODE

        # Reset color, which can be messed up by Enable-GitColors
        $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

        # Set window title
        #$Host.UI.rawui.WindowTitle = $global:OriginalWindowTitle + ' - ' + $PWD;
	    
        # Prompt
        Write-Host `n$('-' * 80)"`n  $($PWD.ProviderPath)" -NoNewline
        Write-VcsStatus
        Write-Host `n$('>' * $nestedPromptLevel) -NoNewline

        $global:LASTEXITCODE = $realLASTEXITCODE
        return "> "
    }

    Enable-GitColors

    Start-SshAgent -Quiet
}
Pop-Location
Write-Host `n posh-git module loaded. Run `'Get-Command -Module posh-git`' for commands.`n
#endregion
 
Set-Alias vs devenv.exe
Set-Alias vsx $env:VSINSTALLDIR\Common7\IDE\VWDExpress.exe
function vse { & devenv.exe /edit $args }

#region Visual Studio aliases
$private:VsVersionYears = @(10, 12, 13, 15)
$private:VsVersionNumbers = @(10, 11, 12, 14)
$private:index = 0 
foreach ($year in $VsVersionYears) {
    $ver = $VsVersionNumbers[$index]
    $devenvPath = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio $ver.0\Common7\IDE\devenv.com"
    if (exist $devenvPath) {
        Set-Alias -Name "vs$year" -Value $devenvPath
        Set-Alias -Name vs -Value $devenvPath
    }
    $index++;
}
#endregion

<#
if (not-exist Env:\Platform) {
    $env:Platform="AnyCPU"
    $env:Configuration="Debug"
}
#>

Set-Alias GitHub "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\GitHub, Inc\GitHub.appref-ms"

# PowerShell Community Extensions
$private:PscxPackage = get-package pscx -ea Ignore
if (!$PscxPackage) {
    Write-Host Installing PowerShell Community Extensions...
    Install-Package -Name Pscx -ProviderName PSModule
}

if (not-exist Env:\VS*COMNTOOLS) {
    Write-Host Setting environment for using Microsoft Visual 2015 Studio Tools.
    Import-VisualStudioVars 140
}
