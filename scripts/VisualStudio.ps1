﻿# Sets Visual Studio aliases and environment variables

if (notexist Env:\VS???COMNTOOLS) {
    Write-Warning " Visual Studio installation not found. Skippied loading VS environment."
    exit
}

Set-Alias vs devenv
Set-Alias vsx "$env:VSINSTALLDIR\Common7\IDE\VWDExpress.exe"
Set-Alias vsl "${env:CommonProgramFiles(x86)}\Microsoft Shared\MSEnv\VSLauncher.exe"
Set-Alias dnvm dnvm.cmd
function vse { & devenv /edit $args }

$env:VS150COMNTOOLS = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Community\Common7\Tools\"

$private:VsVersionYears = @(2010, 2012, 2013, 2015, 2017)
$private:VsVersionNumbers = @(10, 11, 12, 14, 15)
$private:index = 0
foreach ($private:ver in $VsVersionNumbers) {
    $private:year = $VsVersionYears[$index]
    $private:VsCommonTools = "Env:\VS$($ver)0COMNTOOLS"
    if (exist $VsCommonTools) {
        $private:devenvPath = Join-Path (Get-Content $VsCommonTools) "..\IDE\devenv.com"
        if (exist $devenvPath) {
            $devenvPath = Resolve-Path $devenvPath
            Set-Alias -Name vs$($year-2000) -Value $devenvPath
            # map default vs alias to the last available version
            Set-Alias -Name vs -Value $devenvPath
        }
    }
    $index++;
}

# Use user's configured Visual Studio version
if ($UserSettings.DefaultVisualStudioVersion) {
    $year = $UserSettings.DefaultVisualStudioVersion
    $ver = $VsVersionNumbers[[Array]::IndexOf($VsVersionYears, $year)]
    Set-Alias -Name vs -Value vs$($year-2000)
}

Write-Host " Setting environment for using Microsoft Visual $year Studio Tools."
if ($year -ge 2017)
{
    & (Join-Path $env:VS150COMNTOOLS "VsDevCmd.bat")
}
else
{
    Import-VisualStudioVars "$($ver)0"
}

# MSBuild properties
$env:Platform="AnyCPU"
$env:Configuration="Debug"
$env:EnableNuGetPackageRestore=$true
