function Open-GlobalAssemblyCache
{
    Push-Location $env:SystemRoot\Assembly
    start .
}
Set-Alias gac Open-GlobalAssemblyCache
