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

[System.Collections.ArrayList]$connections=@()

$start = "##"
$end = "++"

foreach ($line in $in){
    $line = $line -replace "start",$start -replace "end",$end -split "-"
    $connections.Add($line) | Out-Null
}

[System.Collections.ArrayList]$steps = @{}
$steps += @{"0"=$start}

$count = 1
$routecount = 0

$newstep = $true
while($newstep) {
    [array]$step = @()
    foreach ($route in $steps.($count-1)) {
        foreach ($connection in $connections) {
            [string]$last = $route.substring($route.length-2,2)
            if(($connection.Contains($last)) -and ($last -ne $end)) {
                [string]$newcave = $connection[([array]::IndexOf($connection,$last) - 1)]
                if ((!($route.Contains($newcave))) -or ($newcave -cmatch '[A-Z]')) {
                    $step += $route + $newcave
                    if ($newcave -eq $end) {
                        $routecount++
                    }
                }
            }
        }
    }
    if ($step.Count){
        $steps += @{"$count"=$step}
    }
    else {
        $newstep=$false
    }
    $count++
}

#$steps
$routecount
