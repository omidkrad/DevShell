$global:OriginalWindowTitle = $host.ui.rawui.WindowTitle;
function prompt {
	$host.ui.rawui.WindowTitle = $global:OriginalWindowTitle + ' - ' + $PWD;
	return "--------------------------------------------------------------------------------`n" +
	       "PS [$($executionContext.SessionState.Path.CurrentLocation)]`n`n$('>' * ($nestedPromptLevel + 1)) "
}

function Open-CurrentFolder {
	start .
}

Set-Alias .\ Open-CurrentFolder
Set-Alias ./ Open-CurrentFolder

# Sublime Text
$SublimeTextPath = "$env:ProgramFiles\Sublime Text 3\sublime_text.exe";
if (Test-Path $SublimeTextPath) {
    Set-Alias st $SublimeTextPath;
}
else {
    $SublimeTextPath = "$env:share\..\Tools\Sublime Text*\sublime_text.exe";
    if (Test-Path $SublimeTextPath) {
        Set-Alias st (Get-Item $SublimeTextPath)
    }
    else {
        Write-Warning "Sublime Text path could not be found."
    }
}

$env:Platform="AnyCPU"
$env:Configuration="Debug"


function List-File {
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
            % { '.' + $_.Substring($PWD.Path.Length) }
        }
        else {
            $_
        }
    }
}

Set-Alias ds List-File
