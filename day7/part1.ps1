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

$in = $in -split ","

[int]$minfuel = 0

[int]$max = ($in | Measure-Object -Maximum).Maximum
[int]$pos = ($in | Measure-Object -Minimum).Minimum

while ($pos -le $max){
    [int]$fuel = 0
    foreach ($crab in $in){
        [int]$crab = $crab
        $fuel += [math]::abs($crab - $pos)
    }
    if (($fuel -lt $minfuel) -or ($minfuel -eq 0)) {
        $minfuel = $fuel
    } 
    $pos++
}

$minfuel

$sw.stop()
write-host $sw.Elapsed.Milliseconds

