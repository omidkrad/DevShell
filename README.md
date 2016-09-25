DevShell is a custom developer shell for Windows

# How to Install

- Open a PowerShell window and run the following:
```PowerShell
mkdir C:\dev
git clone https://github.com/omidkrad/DevShell C:\dev\shell
Install-Package Pscx -source PSGallery
Install-Package GitHub -source chocolatey
Install-Package ConEmu -source chocolatey
```
- Run ConEmu
- Under **Settings > Startup > Tasks** create a new Task:
  - Name: DevShell
  - Command: `*powershell.exe -NoLogo -MTA -NoExit -File C:\dev\shell\DevShell.PowerShell_profile.ps1`
  - Set it as Default shell
- Under **Settings > Startup > Specified named task** select `{DevShell}` 
- Save settings and Pin ConEmu to Task Bar

> **Tip:** When you open DevShell, press **Ctrl**+**Shift**+**E** to open a second shell on the side.

# Tools
- Visual Studio Code: https://code.visualstudio.com
- [Notepad2-mod](https://github.com/XhmikosR/notepad2-mod/releases): Alias `n` in the shell opens notepad. We recommend running Notepad2-mod's executable setup that replaces notepad.
