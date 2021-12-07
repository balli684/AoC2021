[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [switch]$test = $false
)

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
        [int]$distance = [math]::abs($crab - $pos)
        [int]$consumption = 0
        for($x = 1; $x -le $distance; $x++){
            $consumption += $x
        }
        $fuel += $consumption
    }
    if (($fuel -lt $minfuel) -or ($minfuel -eq 0)) {
        $minfuel = $fuel
    } 
    $pos++
}

$minfuel