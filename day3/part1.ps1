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


[string]$gamma = ""
[string]$epsilon = ""
[array]$counting = @()


$count = ($input[0].ToCharArray()).Count
while ($count -gt 0){
    $counting += 0
    $count--
}

foreach ($line in $input) {
    $line = $line.ToCharArray()
    $count = 0
    foreach ($char in $line) {
        if ($char -eq "1") {
            $counting[$count]++
        }
        $count++
    }
}

foreach ($value in $counting){
    if ($value -gt ($input.Count / 2)){
        $gamma += "1"
        $epsilon += "0"
    }
    else {
        $gamma += "0"
        $epsilon += "1"
    }
}

$gamma = [System.convert]::ToInt32($gamma,2)
$epsilon  = [System.convert]::ToInt32($epsilon,2)

$answer = [int]$gamma * [int]$epsilon

Write-Host $answer
