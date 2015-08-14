# Sets Visual Studio aliases and environment variables

Set-Alias vs devenv
Set-Alias vsx $env:VSINSTALLDIR\Common7\IDE\VWDExpress.exe
function vse { & devenv /edit $args }

$private:VsVersionYears = @(2010, 2012, 2013, 2015)
$private:VsVersionNumbers = @(10, 11, 12, 14)
$private:index = 0 
foreach ($private:year in $VsVersionYears) {
    $private:ver = $VsVersionNumbers[$index]
    $private:devenvPath = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio $ver.0\Common7\IDE\devenv.com"
    if (exist $devenvPath) {
        Set-Alias -Name vs$($year-2000) -Value $devenvPath
        Set-Alias -Name vs -Value $devenvPath
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
Import-VisualStudioVars "$($ver)0"

# MSBuild properties
$env:Platform="AnyCPU"
$env:Configuration="Debug"
$env:EnableNuGetPackageRestore=true
