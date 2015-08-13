# Set-up SysInternals

$private:SysInternalsPath = Get-Item $env:Tools\SysInternals
Add-PathVariable $SysInternalsPath
if (not-exist $SysInternalsPath\*.exe) {
    & $SysInternalsPath\UpdateSysInt.cmd
}
