# Update DevShell

function Update-Shell
{
    Push-Location $env:ShellDir
    if (-not (Get-Command "git.exe" -ErrorAction SilentlyContinue))
    {
        Write-Warning "`n git not found in path`n"
        Pop-Location
        exit 99
    }
    Write-Host " Updating DevShell:  " -NoNewline
    git pull --rebase | Out-Host
    Write-Host ""
    Pop-Location
}

Update-Shell
