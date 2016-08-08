<#
.Synopsis
   Changes directory to the specified folder name under user profile.
.DESCRIPTION
   Changes directory to the specified folder name under user profile.
.EXAMPLE
   Push location to desktop folder

   PS C:\>my desk
.EXAMPLE
   Open desktop folder in File Explorer

   PS C:\>my desk -start
.EXAMPLE
   Open 'Notes' folder on desktop in File Explorer

   PS C:\>my note -pop
#>

[CmdletBinding()]
[Alias('my')]
Param
(
    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$false,
        Position=0)]
    [string]
    $Name,

    [switch]
    [bool]
    [Alias('pop')]
    $Start
)

$item = Get-ChildItem $env:USERPROFILE\$name*
if (-not $item) {
    $item = Get-ChildItem $env:USERPROFILE\Desktop\$name*
}
$item = $item | select -First 1
if ($item)
{   
    if ($Start)
    {
        Start $item
    }
    else
    {
        pushd $item
    }
}
else
{
    "Not found!"
}
