DevShell is a custom developer shell for Windows

# How to Install

Install [PowerShell Core](https://github.com/PowerShell/PowerShell)
```powershell
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
```

Install [Scoop](https://scoop.sh)
```powershell
# Uncomment if you want to install scoop to a custom directory
# $env:SCOOP='C:\scoop'
# [environment]::SetEnvironmentVariable('SCOOP',$env:SCOOP,'User')
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
```

Install and run [Cmder](https://cmder.net)
```powershell
scoop install cmder-full
cmder
```

In Cmder:
- Under **Settings -> Startup -> Tasks** create a new task [+]:
  - Name: `DevShell`
  - Check "Default task for new console"
  - Check "Default shell"
  - Task Parameters: `/icon "%CMDER_ROOT%\icons\cmder.ico"`
  - Commands: `*pwsh -ExecutionPolicy RemoteSigned -NoLogo -NoExit -Command "Invoke-Expression 'Import-Module ''%ConEmuDir%\..\profile.ps1'''"`

- Under **Settings -> Startup -> Specified named task** select `{DevShell}` 
- Save settings and pin Cmder to Task Bar

Install DevShell

```powershell
# Change the path to where you want to install DevShell
$env:DevShellDir='C:\dev\DevShell'
```

Next, run:
```powershell
mkdir $env:DevShellDir
git clone https://github.com/omidkrad/DevShell $env:DevShellDir

Add-Content -Path "$env:CMDER_ROOT\config\user_profile.ps1" -value ". $env:DevShellDir\devshell_profile.ps1"
```

### The PowerShell profile call stack will be like this
```powershell
Cmder Settings -> Startup -> Tasks -> {DevShell} Task
calls %ConEmuDir%\..\profile.ps1
calls $env:CMDER_ROOT\config\user_profile.ps1
calls $env:DevShellDir\devshell_profile.ps1
calls $env:DevShellDir\user_profile.ps1
```

## Install required modules
Update PowerShellGet - Open a PowerShell window (as Administrator) and run:

```powershell
Set-ExecutionPolicy RemoteSigned
Install-Module –Name PowerShellGet –Force -AllowClobber
Update-Module -Name PowerShellGet
```

Optionally install these other modules:
```powershell
Install-Module Find-String
Install-Module EnvPath

Import-Module psget
Import-Module PSReadline
Import-Module posh-ssh
Import-Module posh-git
Import-Module powerls
Import-Module PSColor
Import-Module TabExpansion++
```

> **Tip:** Add shortcuts to make [split panes](https://rakhesh.com/windows/whee-cmder-can-do-split-panes).


See also:
- [PowerShell, Cmder / ConEmu, Posh-Git, Oh-My-Posh, Powerline Customization](https://gist.github.com/jchandra74/5b0c94385175c7a8d1cb39bc5157365e)
- [Perfect Dev Environment on Windows, the easiest way](https://medium.com/@pranjalpaliwal/perfect-dev-environment-on-windows-the-easiest-way-691c649850eb)
- [Powershell Profile for use with Cmder](https://gist.github.com/cloudRoutine/87c17655405cd8b1eac7)
