function List-File
{
    param(
        [Parameter(Mandatory=$false,
                   HelpMessage="Filename wildcard pattern", Position=0)]
        [string] $FilePattern = '*',

        [Parameter(Mandatory=$false,
                   HelpMessage="Show paths relative to current directory.")]
        [switch] $Relative
    )

    $FilePattern = $FilePattern.Replace('/', '\');
    if ($FilePattern.Contains('\')) {
        $index = $FilePattern.LastIndexOf('\');
        $FileName = $FilePattern.Substring($index + 1);
        $FilePath = $FilePattern.Substring(0, $index);
    }
    else {
        $FileName = $FilePattern;
        $FilePath = '*'
    }

    dir -Recurse -Path $FilePath -Filter $FileName | % FullName | % {
        if ($Relative) {
            % { '.' + $_.Substring($PWD.ProviderPath.Length) }
        }
        else {
            $_
        }
    }
}

Set-Alias ds List-File
function dsr { List-File "$args" -Relative }
