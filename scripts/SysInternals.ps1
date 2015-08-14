# Set-up SysInternals

$private:SysInternalsPath = Get-Item $env:ToolsDir\SysInternals
Add-PathVariable $SysInternalsPath
if (notexist $SysInternalsPath\*.exe) {
    & $SysInternalsPath\UpdateSysInt.cmd
}
