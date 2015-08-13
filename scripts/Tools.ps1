# Tools

$private:UseTheseTools =
{
    # Keep in alphabetical order
    Use-Tool ConEmu ConEmu$(if ($Pscx:Is64BitProcess) {'64'}).exe
    Use-Tool LinqPad LinqPad.exe
    Use-Tool NDepend VisualNDepend.exe
    Use-Tool NotePad++ NotePad++.exe; Set-Alias npp NotePad++
}

function Use-Tool
{
    param(
        [Parameter(Mandatory=$true,
                   HelpMessage="Alias name for the tool", Position=0)]
        [string] $Name,

        [Parameter(Mandatory=$true,
                   HelpMessage="Name of the executable file", Position=1)]
        [string] $Target
    )

    Set-Item -Path Function:Global:$Name -Options "AllScope" -Value `
@"
    `$tool = Get-ChildItem -Recurse -Path `$env:Tools -Include $Target
    if (`$tool) {
        if (`$tool.Length -is [Array]) {
            Write-Error "Multiple targets found for $Target"
            `$tool | % { `$_.FullName }
        }
        else {
            Remove-Item -Path Function:Global:$Name
            Set-Alias -Name $Name -Value `$tool.FullName -Scope Global -Option AllScope
            & `$tool `$args
        }
    }
    else {
        Write-Error "Could not find $Name under `$env:Tools"
    }
"@
}

. $UseTheseTools
