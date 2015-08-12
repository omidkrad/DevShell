﻿# Sets up Posh-Git and Prompt

Push-Location $env:USERPROFILE\AppData\Local\GitHub\PortableGit_*
$env:GitPath = Get-Location
Pop-Location

Add-PathVariable $env:GitPath\cmd, $env:GitPath\bin

Set-Alias GitHub "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\GitHub, Inc\GitHub.appref-ms"

Push-Location $env:USERPROFILE\AppData\Local\GitHub\PoshGit_*
$env:PoshGitPath = Get-Location

#region Partially borrowed from $env:PoshGitPath\profile.example.ps1
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
    Write-Host `n$('-' * 80)"`n  $($PWD.Path)" -NoNewline
    Write-VcsStatus
    Write-Host `n$('>' * $nestedPromptLevel) -NoNewline

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Enable-GitColors

Start-SshAgent -Quiet
#endregion

Pop-Location
Write-Host `n posh-git module loaded. Run `'Get-Command -Module posh-git`' for commands.`n