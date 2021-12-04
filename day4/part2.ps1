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

function Check-Card {
    param (
        [Parameter(Mandatory=$true)]
        [array]$draws,
        [Parameter(Mandatory=$true)]
        [array]$card
    )

    $counter = 0
    $bingo = $false
    foreach ($draw in $draws) {
        $x = 0
        while ($x -lt $card.count) {
            $y = 0
            while ($y -lt $card[$x].Count) {
                if ($card[$x][$y] -like $draw) {
                    $card[$x][$y] = $null
                    if (($null -eq ($card[$x][0] + $card[$x][1] + $card[$x][2] + $card[$x][3] + $card[$x][4])) -Or ($null -eq ($card[0][$y] + $card[1][$y] + $card[2][$y] + $card[3][$y] + $card[4][$y]))) {
                        [int]$answer = 0
                        foreach ($line in $card) {
                            foreach ($number in $line) {
                                $answer += [int]$number
                            }
                        }
                        $answer = $answer * $draw
                        $y = $card[$x].Count
                        $x = $card.Count
                        $bingo = $true
                    }
                }
                $y++
            }
            $x++
        }
        if ($bingo) {break}
        $counter++
    }
    
    $return = New-Object psobject
    $return | Add-Member -MemberType "Noteproperty" -Name "counter" -Value $counter
    $return | Add-Member -MemberType "Noteproperty" -Name "answer" -Value $answer

    return $return
}

[array]$draws = $input[0] -split ","

$input = $input[2..($input.count - 1)]

[System.Collections.ArrayList]$card = @()

$most = 0
foreach ($line in $input) {
    if ($line -eq "" ){
        $check = Check-Card -draws $draws -card $card
        if ($check.counter -gt $most) {
            $most = $check.counter
            $answer = $check.answer
        }
        $card.Clear()

    }
    else {
        $card.Add((($line -split " ") | where {$_ -ne ""})) | Out-Null
    }
}
$check = Check-Card -draws $draws -card $card
if ($check.counter -gt $most) {
    $most = $check.counter
    $answer = $check.answer
}

#$most
$answer
