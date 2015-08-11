# Imports, helper functions and aliases

# PowerShell Community Extensions
$private:PscxPackage = Get-Package pscx -ea Ignore
if (!$PscxPackage) {
    Write-Host Installing PowerShell Community Extensions...
    Install-Package -Name Pscx -ProviderName PSModule
}

# exist and not-exist
function not-exist($path) { -not (Test-Path $path) }
Set-Alias !exit not-exist -Option "Constant, AllScope"
Set-Alias exist Test-Path -Option "Constant, AllScope"

# Open-CurrentFolder aliases
function Open-CurrentFolder { start . }
Set-Alias .\ Open-CurrentFolder
Set-Alias ./ Open-CurrentFolder

# Push-Location aliases
function Push-LocationToParent { Push-Location ..\$args }
Set-Alias .. Push-LocationToParent
Set-Alias `> Push-Location
Set-Alias `< Pop-Location
function \ { Push-Location $env:DevRoot\$args } # example: '\ src' will jump to $env:Src
Set-Alias / \ -Description 'Push location to `$env:DevRoot'

function Open-GlobalAssemblyCache {
    Push-Location $env:SystemRoot\Assembly
    start .
}
Set-Alias gac Open-GlobalAssemblyCache

function Show-AssemblyInfo([string]$Assembly) {
    $Assembly = (Get-Item $Assembly).FullName
    [Reflection.AssemblyName]::GetAssemblyName($Assembly) | Format-List
}

function Open-GitCommit([string]$commitSHA) {
    $origin = (git config --get remote.origin.url).TrimEnd('.git')
    start "$origin/commit/$commitSHA"
}

function fs { & findstr.exe /spin /a:4A $args }
Set-Alias whereis Where.exe
Set-Alias Path Get-PathVariable

function Search-Google { start "https://google.com?#q=$args" }

function Quote-String { "$args" }
function Quote-List { $args }
Set-Alias qs Quote-String
Set-Alias ql Quote-List
Set-Alias s Select-Object
Set-Alias mo Measure-Object
Set-Alias new New-Object
Set-Alias sls Select-String
Set-Alias ss Select-String
