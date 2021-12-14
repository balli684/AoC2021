[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [System.IO.FileInfo]$inputfile = ".\input.txt"
)

. ..\functions.ps1

if (Test-Path $inputfile) {
    $in = Get-Content $inputfile
}
else {
    write-error "File $inputfile not found!"
    throw
}

[string]$polymer = $in[0]
[hashtable]$insert = @{}


foreach ($line in $in[2..($in.Count-1)]) {
    $line = $line -split " -> "
    $insert += @{$line[0]=$line[1]}
}

$steps = 10

for($step=1;$step -le $steps;$step++) {
    [string]$newpolymer = $polymer.Substring(0,1)
    for($x=0;$x -lt ($polymer.Length - 1);$x++) {
        $newpolymer += $insert.($polymer.Substring($x,2)) + $polymer.Substring($x+1,1)
    }
    $polymer = $newpolymer
}

#$polymer.Length

$out = $polymer.ToCharArray() | Group-Object | Sort-Object -Property "Count"
#$out

$out[-1].Count - $out[0].Count