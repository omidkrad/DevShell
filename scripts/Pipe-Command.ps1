# Use this cmdlet to pipe files to regular commands
# Example:
#        dir -r *.js | select -first 3 | pipe atom
#        dir -r *.js | select -first 3 | %% devenv _ /edit
#        dir -r *.js | select -first 3 | %% git checkout

function Pipe-Command
{
	[CmdletBinding()]
	PARAM(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[IO.FileInfo[]]$File,

        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true, Position=0)]
        [string]$Command,

        [switch]$WhatIf
	)
	BEGIN
    {
        if ($Command -match '^git ' -and !$Command.Trim().EndsWith(' _')) {
            $Command += ' --';
        }
    }
	PROCESS
    {
        $QuotedPath = "`"$($file.FullName)`""
        if ($Command -cmatch ' _ ') {
            $CommandToRun = $Command.Replace(' _ ', " $QuotedPath ")
        }
        else {
            $CommandToRun = "$Command $QuotedPath"
        }
        if ($WhatIf) {
            Write-Host "What if: $CommandToRun"
        }
        else {
            if (Get-Command Write-Information) {
                Write-Information $CommandToRun
            }
            Invoke-Expression $CommandToRun
        }
    }
	END {}
}

Set-Alias pipe Pipe-Command
Set-Alias %% Pipe-Command
