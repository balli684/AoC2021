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

$steps = 40
[string]$start = $in[0]
[hashtable]$polymer = @{}


foreach ($line in $in[2..($in.Count-1)]) {
    $line = $line -split " -> "
    [hashtable]$object = @{}
    $object += @{"Name"=$line[0]}
    $object += @{"Become1"=($line[0]).Substring(0,1)+$line[1]}
    $object += @{"Become2"=$line[1]+($line[0]).Substring(1,1)}
    $object += @{"Counter"=0}
    $object += @{"NewCounter"=0}
    $object += @{"First"=($line[0]).Substring(0,1)}
    $polymer += @{$line[0]=$object}
}

for($x=0;$x -lt ($start.Length - 1);$x++) {
    $polymer.($start.Substring($x,2)).Counter++
}

$polymer.Keys | foreach {
    $polymer.($_).NewCounter = $polymer.($_).Counter
}

for($step=1;$step -le $steps;$step++) {
    $polymer.Keys | foreach {
        $polymer.($_).NewCounter -= $polymer.($_).Counter
        $polymer.($polymer.($_).Become1).NewCounter += $polymer.($_).Counter
        $polymer.($polymer.($_).Become2).NewCounter += $polymer.($_).Counter
    }
    $polymer.Keys | foreach {
        $polymer.($_).Counter = $polymer.($_).NewCounter
    }
}

[hashtable]$counter
$polymer.Keys | foreach {
    if ($null -ne $counter.($polymer.$_.First)) {
        $counter.($polymer.$_.First) += $polymer.$_.Counter
    } else {
        $counter += @{($polymer.$_.First)=$polymer.$_.Counter}
    }
}

$counter.($start.Substring($start.Length-1,1))++

$out = $counter.Values | Measure-Object -Maximum -Minimum
$out.Maximum - $out.Minimum