#Set environment variables for Visual Studio Command Prompt
$priorities = @(
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat" # VS 2015
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\Tools\VsDevCmd.bat" # VS 2013
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\Common7\Tools\VsDevCmd.bat" # VS 2012
)
$VSMapping = @{"2015" = "Olympia"; "Oregon" = "Salem"; California = "Sacramento"}

#"HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\Shell\MultiCache\C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe.FriendlyAppName" # Microsoft Visual Studio 2015 RC

$VsDevCmdFile = Get-Item $priorities[0]
# source: http://stackoverflow.com/a/2124759/450913
pushd "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\Tools
cmd /c "VsDevCmd.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])" -value "$($v[1])"
  }
}
popd
write-host "`nVisual Studio 2010 Command Prompt variables set." -ForegroundColor Yellow
