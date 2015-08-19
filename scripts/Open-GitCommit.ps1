function Open-GitCommit([string]$commitSHA)
{
    $origin = (git config --get remote.origin.url).TrimEnd('.git')
    if ($commitSHA) {
        $url = "$origin/commit/$commitSHA"
    }
    else {
        $branch = ""
        if (Get-Command Get-GitStatus -Module posh-git) {
            $branch = (Get-GitStatus).Branch
        }
        $url = "$origin/commits/$branch"
    }
    Write-Host "Opening: $url"
    start $url
}
