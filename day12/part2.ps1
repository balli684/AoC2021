[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [System.IO.FileInfo]$inputfile = ".\input.txt"
)


if (Test-Path $inputfile) {
    $in = Get-Content $inputfile
}
else {
    write-error "File $inputfile not found!"
    throw
}


[System.Collections.ArrayList]$connections=@()

$cavechar = 2
$start = ("##").Substring(0,$cavechar)
$end = ("++").Substring(0,$cavechar)

foreach ($line in $in){
    $line = $line -replace "start",$start -replace "end",$end -split "-"
    $connections.Add($line) | Out-Null
}

#[System.Collections.ArrayList]$steps = @{}
#$steps += @{"0"="1" + $start}
[array]$step = @("1" + $start)

$count = 1
$routecount = 0

#$newstep = $true
do {
    $oldstep = $step
    [array]$step = @()
    foreach ($route in $oldstep) {
        foreach ($connection in $connections) {
            [string]$last = $route.substring($route.length - $cavechar,$cavechar)
            if(($connection.Contains($last)) -and ($last -ne $end)) {
                [string]$newcave = $connection[([array]::IndexOf($connection,$last) - 1)]
                if ($newcave -eq $end) {
                    $routecount++
                }
                elseif ($newcave -ne $start) {
                    if ($newcave -cmatch '[A-Z]'){
                    $step += $route + $newcave
                    }
                    else {
                        if (!($route.Contains($newcave))) {
                            $step += $route + $newcave
                        }
                        elseif ($route.substring(0,1) -eq "1") {
                            $step += ($route -replace "1","0") + $newcave
                        }
                    }
                }
#                if ((!($route.Contains($newcave))) -or ($newcave -cmatch '[A-Z]')) {
#                    $step += $route + $newcave
#                    if ($newcave -eq $end) {
#                        $routecount++
#                    }
#                }
#                elseif (($route.substring(0,1) -eq "1") -and ($newcave -ne $start) -and ($newcave -ne $end)){
#                    $step += ($route -replace "1","0") + $newcave
#                }
            }
#        }
    }
    
    #if ($step.Count){
    #    $steps += @{"$count"=$step}
    #}
    #else {
    #    $newstep=$false
    }
    $count++
} while($oldstep.Count)

$routecount

#$steps