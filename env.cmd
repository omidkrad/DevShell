@echo off
@echo === Rad's Command Shell ===
echo.
endlocal enableextensions
if ERRORLEVEL 1 echo Unable to enable extensions
::call "%VS100COMNTOOLS%..\..\VC\vcvarsall.bat" x86
echo Setting environment for using Microsoft Visual Studio 2012 Tools.
call "%VS120COMNTOOLS%\VsDevCmd.bat"
if ERRORLEVEL 1 echo Visual Studio 10 installation not found
echo.

:: Setting env vars, expanding to their fully qualified path names
set share=%~dp0
set share=%share:~0,-1%

set root=%share%\..
for %%I in (%root%) do set root=%%~fI

set src=%root%\src
cd /d %src%

:: Setting path
pushd %UserProfile%\AppData\Local\GitHub\PortableGit_*
set GitPath=%CD%
popd
path %path%;%share%;%share%\SysInternals;%GitPath%\cmd;%GitPath%\bin

:: Import aliases
::doskey /macrofile=%~dp0\aliases.txt
echo Type 'alias' for list of command aliases
echo Type 'aliashelp' for help on aliases
echo.

echo root=%root%
echo share=%share%
echo src=%src%

title DevShell ^(Command Prompt^)
color 4f
prompt --------------------------------------------------------------------------------$_$S[$P]$_$_$M$G$S

set EnableNuGetPackageRestore=true

doskey /exename=PowerShell.exe /macrofile=%~dp0\aliases-PS.txt
PowerShell -NoLogo -MTA -NoExit -File %~dp0\Prompt.ps1
