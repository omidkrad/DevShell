# Update DevShell
Push-Location $env:ShellDir
Write-Host " Updating DevShell:  " -NoNewline
git pull | Out-Host
Write-Host ""
Pop-Location