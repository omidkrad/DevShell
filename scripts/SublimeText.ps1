# Sets st alias to Sublime Text

$private:SublimeTextPath = "$env:ProgramFiles\Sublime Text 3\sublime_text.exe";
if (exist $SublimeTextPath) {
    Set-Alias st $SublimeTextPath
}
else {
    $SublimeTextPath = "$env:Tools\Sublime Text*\sublime_text.exe";
    if (exist $SublimeTextPath) {
        Set-Alias st (Get-Item $SublimeTextPath)
    }
    else {
        Write-Debug "Sublime Text path not found."
    }
}
