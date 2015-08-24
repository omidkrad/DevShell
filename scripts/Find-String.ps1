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
        [switch]$AsRegEx
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
    & findstr.exe /a:A $switches /c:"$SearchString" $Files
}
Set-Alias fs Find-String

Set-Alias sls Select-String
Set-Alias ss Select-String
