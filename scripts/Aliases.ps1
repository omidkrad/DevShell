# Aliases and quick functions

function Open-CurrentFolder { start .\$args }
Set-Alias .\ Open-CurrentFolder
Set-Alias ./ Open-CurrentFolder

function Push-LocationToParent { Push-Location ..\$(if($args){"$args*"}) }
Set-Alias .. Push-LocationToParent
Set-Alias `> Push-Location
Set-Alias `< Pop-Location
function \ { Push-Location $env:DevRoot\$(if($args){"$args*"}) } # example: '\ src' will jump to $env:Src
Set-Alias / \ -Description 'Push location to `$env:DevRoot'

Set-Alias new New-Object
Set-Alias s Select-Object
Set-Alias mo Measure-Object
Set-Alias whereis Where.exe
Set-Alias n notepad.exe
Set-Alias Path Get-PathVariable

function Quote-String { "$args" }
function Quote-List { $args }
Set-Alias qs Quote-String
Set-Alias ql Quote-List

Set-Alias my Open-MyFolder
