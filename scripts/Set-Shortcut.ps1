function Set-Shortcut
{
    param ([string]$ShortcutPath, [string]$TargetPath, [string]$Description)

    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = (Get-Item $TargetPath).FullName
    $Shortcut.Description = $Description
    $Shortcut.Save()
}
