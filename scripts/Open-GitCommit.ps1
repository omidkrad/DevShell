function Open-GitCommit([string]$commitSHA)
{
    $origin = (git config --get remote.origin.url).TrimEnd('.git')
    if ($commitSHA) {
        $url = "$origin/commit/$commitSHA"
    }
    else {
        $url = "$origin/commits/"
    }
    Write-Host "Opening: $url"
    start $url
}
