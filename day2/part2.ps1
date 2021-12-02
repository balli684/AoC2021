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

[int]$depth = 0
[int]$hor = 0
[int]$aim = 0

foreach ($line in $input) {
    $line = $line -split " "
    Switch ($line[0]) {
        "forward"   {
                        $hor = $hor + [int]($line[1])
                        $depth = $depth + ($aim * [int]($line[1]))
                        break
                    }
        "down"      {    
                        $aim = $aim + [int]($line[1])
                        break
                    }
        "up"        {
                        $aim = $aim - [int]($line[1])
                        break
                    }
    }
}

$answer = $hor * $depth

Write-Host $answer
