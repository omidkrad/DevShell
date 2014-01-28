$global:OriginalWindowTitle = $host.ui.rawui.WindowTitle;
function prompt {
	$host.ui.rawui.WindowTitle = $global:OriginalWindowTitle + ' - ' + (get-location).Path;
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
