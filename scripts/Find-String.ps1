function Find-String
{
    & findstr.exe /spin /a:A $args
}
Set-Alias fs Find-String

Set-Alias sls Select-String
Set-Alias ss Select-String
