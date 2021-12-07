[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [switch]$test = $false
)

$sw = [System.Diagnostics.Stopwatch]::StartNew()

if ($test) {
    $in = Get-Content .\testinput.txt
}
else {
    $in = Get-Content .\input.txt
}

#$in = $in -split ","
$crabs = $in -split "," | Sort-Object | Group-Object

[array]$minfuel = @()

[int]$max = $crabs[-1].name
[int]$pos = $crabs[0].name

while ($pos -le $max){
    [int]$fuel = 0
    foreach ($crab in $crabs){
        $fuel += (([math]::abs($pos - [int]$crab.name)) * $crab.count)
    }
    $minfuel += $fuel
    $pos++
}

($minfuel | Measure-Object -Minimum).Minimum

$sw.stop()
write-host $sw.Elapsed.Milliseconds

