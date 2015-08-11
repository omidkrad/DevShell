# Sets Visual Studio aliases and environment variables

Set-Alias vs devenv
Set-Alias vsx $env:VSINSTALLDIR\Common7\IDE\VWDExpress.exe
function vse { & devenv /edit $args }

$private:VsVersionYears = @(10, 12, 13, 15)
$private:VsVersionNumbers = @(10, 11, 12, 14)
$private:index = 0 
foreach ($year in $VsVersionYears) {
    $ver = $VsVersionNumbers[$index]
    $devenvPath = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio $ver.0\Common7\IDE\devenv.com"
    if (exist $devenvPath) {
        Set-Alias -Name "vs$year" -Value $devenvPath
        Set-Alias -Name vs -Value $devenvPath
    }
    $index++;
}

#Write-Host Setting environment for using Microsoft Visual 2015 Studio Tools.
#Import-VisualStudioVars 140
Write-Host Setting environment for using Microsoft Visual 2013 Studio Tools.
Import-VisualStudioVars 2013
Set-Alias vs "${Env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE\devenv.com"

# MSBuild properties
$env:Platform="AnyCPU"
$env:Configuration="Debug"
$env:EnableNuGetPackageRestore=true
