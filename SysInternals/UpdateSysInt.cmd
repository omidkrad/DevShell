@echo off

setlocal

:processArgs

 if /I '%1'=='-?' 	shift /1 & goto Usage
 if /I '%1'=='/?' 	shift /1 & goto Usage
 if /I '%1'=='help' 	shift /1 & goto Usage
 if /I '%1'=='/help' 	shift /1 & goto Usage
 if /I '%1'=='-help' 	shift /1 & goto Usage

:Start
set SysInternalsShare=\\live.SysInternals.com\tools

:: Starting the WebClient service for accessing WebDAV folders
net start webclient

:: Check availability
if not exist "%SysInternalsShare%" (
	echo Cannot access the SysInternals WebDAV share.
	goto Error
)

:: Copy files
echo Updating SysInternals Tools...
xcopy /y /d /s /r %SysInternalsShare% %~dp0
if ERRORLEVEL 1 goto Error
echo All files are up-to-date

goto Done

:Usage
echo Usage: %~0
echo        This script updates SysInternals tools in this directory
echo        from SysInternals Live at http://live.SysInternals.com
echo.
echo        For more information about SysInternals tools see:
echo        http://www.SysInternals.com
exit /b 99

:Error
if ERRORLEVEL 0 set ERRORLEVEL=99
echo.
echo %~0 failed: %ERRORLEVEL%
exit /b %ERRORLEVEL%

:Done
echo.
echo %~0 succeeded
exit /b 0
