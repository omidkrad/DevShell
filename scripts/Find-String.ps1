# Wrapper cmdlet for FINDSTR.EXE for the most common usages.
# By default it searches strings literally (no regular expressions).

function Find-String
{
    Param(
        [string]$SearchString,
        [string]$Files = '*',
        [switch]$Recurse = $true,
        [switch]$IgnoreCase = $true,
        [switch]$AtBeginningOfLine,
        [switch]$AtEndOfLine,
        [switch]$SkipBinaryFiles = $true,
        [switch]$PrintLineNumber = $true,
        [switch]$PrintSeekOffset,
        [switch]$FileNamesOnly,
        [switch]$AsRegEx,
        [switch]$ExcludeExternals = $true
    )
    $switches = ''
    if ($Recurse) { $switches += 's' }
    if ($IgnoreCase) { $switches += 'i' }
    if ($AtBeginningOfLine) { $switches += 'b' }
    if ($AtEndOfLine) { $switches += 'e' }
    if ($SkipBinaryFiles) { $switches += 'p' }
    if ($PrintLineNumber) { $switches += 'n' }
    if ($PrintSeekOffset) { $switches += 'o' }
    if ($FileNamesOnly) { $switches += 'm' }
    if ($AsRegEx) { $switches += 'r' }
    if ($switches) { $switches = '/' + $switches }

    $path = Split-Path -Parent -Path $Files
    $pattern = Split-Path -Leaf -Path $Files

    Push-Location $path

    try
    {
        if (!$ExcludeExternals -or !$Recurse)
        {
            & findstr.exe /a:A $switches /c:"$SearchString" .\$pattern
        }
        else
        {
            $ExcludeList = @(
                ".git"
                "bin"
                "jspm_packages"
                "node_modules"
                "packages"
            )

            # Search current directory
            & findstr.exe /a:A $($switches.Replace('s','')) /c:"$SearchString" .\$pattern

            # Search each subdirectory not in the exclude list
            Get-ChildItem -Directory -Exclude $ExcludeList | foreach {
                & findstr.exe /a:A $switches /c:"$SearchString" .\$($_.Name)\$pattern
            }
        }
    }
    finally
    {
        Pop-Location
    }
    
}
Set-Alias fs Find-String

Set-Alias sls Select-String
Set-Alias ss Select-String
