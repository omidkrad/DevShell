# Sets up Posh-Git and Prompt

Push-Location $env:USERPROFILE\AppData\Local\GitHub\PortableGit_* -ErrorAction SilentlyContinue
if (!$?) {
    Write-Warning "`n PortableGit not found.`n"
    exit 99
}
$env:GitPath = Get-Location
Pop-Location

Add-PathVariable $env:GitPath\cmd, $env:GitPath\bin

Set-Alias GitHub "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\GitHub, Inc\GitHub.appref-ms"

Push-Location $env:USERPROFILE\AppData\Local\GitHub\PoshGit_* -ErrorAction SilentlyContinue
if (!$?) {
    Write-Warning "`n posh-git not found. Could not load posh-git module. Try opening PowerShell from GitHub client to create the PoshGit directory.`n"
    exit 99
}
$env:PoshGitPath = Get-Location

#region Partially borrowed from $env:PoshGitPath\profile.example.ps1
# Load posh-git module from current directory
Import-Module .\posh-git

# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt
{
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    [Console]::ResetColor()

    # Set window title
    #$Host.UI.rawui.WindowTitle = $global:OriginalWindowTitle + ' - ' + $PWD;
	    
    # Prompt
    Write-Host `n$('-' * 80)"`n  $($PWD.Path)" -NoNewline
    Write-VcsStatus
    Write-Host `n$('>' * $nestedPromptLevel) -NoNewline

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Start-SshAgent -Quiet
#endregion

Pop-Location
Write-Host "`n posh-git module loaded. Run `'Get-Command -Module posh-git`' for commands.`n"
