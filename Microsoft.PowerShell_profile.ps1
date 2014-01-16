# Mercurial PowerShell Prompt (http://matthewmanela.com/blog/a-mercurial-powershell-prompt)

if (test-path function:\prompt)       {
  $oldPrompt = ls function: | ? {$_.Name -eq "prompt"}
  remove-item -force function:\prompt
  } 
 
function prompt() {
  $host.ui.rawui.WindowTitle = (get-location).Path
 
  $summary = hg summary 2>&1
  if($summary.Exception -eq $null) {
    $regex = "(?si)(parent:(?<parent>.*?)(\n|\r)+.*?)(branch:(?<branch>.*)\s)(commit:(?<commit>.*)\s)(update:(?<update>.*))";
    $summary = [System.String]::Join([System.Environment]::NewLine,$summary)
    $res = $summary -match $regex
    $format = "hg b:{0} c:{1}" -f $matches["branch"].Trim(), $matches["commit"].Trim()
    write-host ($format) -NoNewLine
    write-host (">") -NoNewLine
  }
  else {
    & $oldPrompt
  }
 
  return " "
 
}
