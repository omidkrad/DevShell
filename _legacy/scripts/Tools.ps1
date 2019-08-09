# Tools

$private:UseTheseTools =
{
    # Keep in alphabetical order
    Use-Tool ConEmu ConEmu$(if ($Pscx:Is64BitProcess) {'64'}).exe
    Use-Tool LinqPad LinqPad.exe
    Use-Tool NDepend VisualNDepend.exe
    Use-Tool NotePad++ NotePad++.exe; Set-Alias npp NotePad++
    Use-Tool WinMerge WinMergePortable.exe; Set-Alias Diff-Path WinMerge
}

<#
.Synopsis
   Creates a lazy-loaded alias to the specified executable or command tool.
.DESCRIPTION
   Creates a lazy-loaded alias to the specified executable or command tool.
   For lazy-loading, it first creates a function with the specified name which
   will search for the executable file under tools path. The first time
   the function is called, it will do the search and if successful will
   set an alias to the executable file with fixed path so no file search is done
   in subsequent calls to that alias. 
#>
function Use-Tool
{
    param(
        [Parameter(Mandatory=$true,
                   HelpMessage="Alias name for the tool", Position=0)]
        [string] $Name,

        [Parameter(Mandatory=$true,
                   HelpMessage="Name of the executable file", Position=1)]
        [string] $Target

        <#
        [Parameter(Mandatory=$false,
                   HelpMessage="List of installation paths to try", Position=1)]
        [string[]] $InstallationPath
        #>
    )

    Set-Item -Path Function:Global:$Name -Options "AllScope" -Value `
@"
    `$tool = Get-ChildItem -Recurse -Path `$env:ToolsDir -Include $Target | sort -Property FileVersion | select -first 1
    if (`$tool) {
        if (`$tool -is [Array]) {
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
        Write-Error "Could not find $Name under `$env:ToolsDir"
    }
"@
}

. $UseTheseTools
