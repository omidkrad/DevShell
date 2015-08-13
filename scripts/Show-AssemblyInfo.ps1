function Show-AssemblyInfo([string]$Assembly)
{
    $Assembly = (Get-Item $Assembly).FullName
    [Reflection.AssemblyName]::GetAssemblyName($Assembly) | Format-List
}
