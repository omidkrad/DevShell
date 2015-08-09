@echo off
setlocal

set sshprivatekey=%share%\Users\%USERNAME%\ssh-private-key.ppk

:processArgs
 if /I '%1'=='-?' 	shift /1 & goto Usage
 if /I '%1'=='/?' 	shift /1 & goto Usage
 if /I '%1'=='help' 	shift /1 & goto Usage
 if /I '%1'=='/help' 	shift /1 & goto Usage
 if /I '%1'=='-help' 	shift /1 & goto Usage

:Start
:: Check if HG exists
where hg.exe >nul 2>&1
if errorlevel 1 (
	echo Error: Could not find hg.exe
	goto Error
)

:: Check for and start pageant process for SSH connections
tasklist | findstr /i pageant.exe >nul 2>&1
if errorlevel 1 (
	if exist "%sshprivatekey%" (
		echo Starting PuTTY authentication agent
		start pageant.exe "%sshprivatekey%"
		pause
	)
)

:: Pull
call :SyncRepo Share
if errorlevel 1 goto Error

call :SyncRepo Simorgh
if errorlevel 1 goto Error

call :SyncRepo DesignDocs
if errorlevel 1 goto Error

call :SyncRepo Wiki
if errorlevel 1 goto Error

goto Done

:SyncRepo
pushd %root%
set repo=%1
echo.
echo --- %repo% ---
hg --repository %repo% pull --update
if errorlevel 1 exit /b 1
popd
goto :eof

:Usage
echo Usage: %~0
echo        This script pulls all repositories.
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
