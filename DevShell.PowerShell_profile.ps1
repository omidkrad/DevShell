#$global:OriginalWindowTitle = $host.ui.rawui.WindowTitle;

function Open-CurrentFolder {
	start .
}

Set-Alias .\ Open-CurrentFolder
Set-Alias ./ Open-CurrentFolder

# Sublime Text
$SublimeTextPath = "$env:ProgramFiles\Sublime Text 3\sublime_text.exe";
if (Test-Path $SublimeTextPath) {
    Set-Alias st $SublimeTextPath;
}
else {
    $SublimeTextPath = "$env:share\..\Tools\Sublime Text*\sublime_text.exe";
    if (Test-Path $SublimeTextPath) {
        Set-Alias st (Get-Item $SublimeTextPath)
    }
    else {
        Write-Warning "Sublime Text path could not be found."
    }
}

$env:Platform="AnyCPU"
$env:Configuration="Debug"


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

function ShowAssemblyInfo([string]$Assembly) {
    [reflection.assemblyname]::GetAssemblyName($Assembly) | fl
}

# Set up posh-git
Push-Location $env:USERPROFILE\AppData\Local\GitHub\PoshGit_*
$env:PoshGitPath=$PWD

# Some of the following is borrowed from $env:PoshGitPath\profile.example.ps1
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

#. $env:PoshGitPath\profile.example.ps1
Write-Host `n posh-git module loaded. Run `'Get-Command -Module posh-git`' for commands.`n
