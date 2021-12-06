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

$input = $input -split ","

$counter = New-Object "object[]" 9

foreach ($number in $input) {
    $counter[$number]++
}

$days = 256

while ($days -gt 0) {
    $new = $counter[0]
    $counter[7] += $new
    for ($x=0;$x -le 7;$x++){
        $counter[$x] = $counter[$x + 1]
    }
    $counter[8] = $new
    $days--
}

$answer = 0
$counter | foreach {$answer += $_}

#$counter
$answer

