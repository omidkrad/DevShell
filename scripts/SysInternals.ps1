# Set-up SysInternals

$private:SysInternalsPath = Get-Item $env:Tools\SysInternals
Add-PathVariable $SysInternalsPath
if (notexist $SysInternalsPath\*.exe) {
    & $SysInternalsPath\UpdateSysInt.cmd
}
