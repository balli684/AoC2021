[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [switch]$test = $false
)

if ($test) {
    $input = Get-Content .\testinput.txt
}
else {
    $input = Get-Content .\input.txt
}


[string]$oxygen = ""
[string]$co2 = ""


$array = $input
$counter = 0
while ($array.count -gt 1) {
    $count = 0
    foreach ($line in $array) {
        $line = $line.ToCharArray()
        if ($line[$counter] -eq "1") {
            $count++
        }
    }
    if ($count -ge ($array.count / 2)) {
        $oxygen += "1"
    }
    else {
        $oxygen += "0"
    }
    $array = $array | where {$_ -like "$oxygen*"}
    $counter++
}
[string]$oxygen = $array

$array = $input
$counter = 0
while ($array.count -gt 1) {
    $count = 0
    foreach ($line in $array) {
        $line = $line.ToCharArray()
        if ($line[$counter] -eq "1") {
            $count++
        }
    }
    if ($count -ge ($array.count / 2)) {
        $co2 += "0"
    }
    else {
        $co2 += "1"
    }
    $array = $array | where {$_ -like "$co2*"}
    $counter++
}
[string]$co2 = $array

$oxygen = [System.convert]::ToInt32($oxygen,2)
$co2  = [System.convert]::ToInt32($co2,2)

$answer = [int]$oxygen * [int]$co2

Write-Host $answer