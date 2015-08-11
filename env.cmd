@echo off
@echo === Developer's Command Shell ===
echo.
endlocal enableextensions
if ERRORLEVEL 1 echo Unable to enable extensions
echo Setting environment for using Microsoft Visual Studio 2013 Tools.
call "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" x64
if ERRORLEVEL 1 echo ERROR: Visual Studio 2013 installation not found && goto :eof
echo.

:: Setting env vars, expanding to their fully qualified path names
set Shell=%~dp0
set Shell=%Shell:~0,-1%

set DevRoot=%Shell%\..
for %%I in (%DevRoot%) do set DevRoot=%%~fI

set Src=%DevRoot%\src
cd /d %Src%

:: SysInternals
set Tools=%Shell%\tools
if not exist "%Tools%\SysInternals\*.exe" call "%Tools%\SysInternals\UpdateSysInt.cmd"

:: Setting path
pushd %UserProfile%\AppData\Local\GitHub\PortableGit_*
if ERRORLEVEL 1 echo ERROR: PortableGit not found! Please install GitHub for Windows. && goto :eof
set GitPath=%CD%
popd
path %PATH%;%Tools%\SysInternals;%GitPath%\cmd;%GitPath%\bin

:: Import aliases
doskey /macrofile=%~dp0\aliases.txt
echo Type 'alias' for list of command aliases
echo Type 'aliashelp' for help on aliases
echo.

echo DevRoot=%DevRoot%
echo Shell=%Shell%
echo Src=%Src%
echo Tools=%Tools%

title DevShell ^(Command Prompt^)
color 4f
prompt --------------------------------------------------------------------------------$_$S[$P]$_$_$M$G$S

:: MSBuild properties
set Platform="AnyCPU"
set Configuration="Debug"
set EnableNuGetPackageRestore=true

echo.
::PowerShell -NoLogo -MTA -NoExit -File %~dp0\DevShell.PowerShell_profile.ps1
