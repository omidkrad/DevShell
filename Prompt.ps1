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
