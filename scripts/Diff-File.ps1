<#
.Synopsis
   Diff two files
.DESCRIPTION
   Compares two files using Visual Studio compare tool.
   vsDiffMerge can only compare files. For comparing
   directories use Diff-Path.
#>
function Diff-File ($file1, $file2)
{
    vsDiffMerge.exe $file1 $file2 /t
    if (!$?) {
        Write-Error "Could not compare files."
    }
}

Set-Alias vsdiff Diff-File

# also Diff-Path is set in Tools.ps1
#Set-Alias Diff-Path WinMerge
