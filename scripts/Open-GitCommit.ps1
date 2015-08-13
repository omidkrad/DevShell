function Open-GitCommit([string]$commitSHA)
{
    $origin = (git config --get remote.origin.url).TrimEnd('.git')
    $url = "$origin/commit/$commitSHA"
    Write-Host "Opening: $url"
    start $url
}
