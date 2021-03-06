﻿# Imports, helper functions and aliases
# (this script is loaded first)

# PowerShell Community Extensions
$private:PscxPackage = Get-Package pscx -ea Ignore
if (!$PscxPackage) {
    Write-Host Installing PowerShell Community Extensions...
    Install-Package -Name Pscx -ProviderName PSModule
}

# exist and notexist
if (-not (Test-Path Alias:exist))
{
    function notexist { -not (Test-Path $args) }
    Set-Alias !exit not-exist -Option "Constant, AllScope"
    Set-Alias exist Test-Path -Option "Constant, AllScope"
}
