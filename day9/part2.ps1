[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [switch]$test = $false
)


function Write-Grid {
    param (
    [Parameter(Mandatory=$true)]
    [array]$grid,
    [Parameter(Mandatory=$false)]
    [switch]$devider = $false
    )
    for($ypos=0;$ypos -lt $grid.Count;$ypos++) {
        for($xpos=0;$xpos -lt $grid[$ypos].Count;$xpos++) {
            if ($null -eq ($grid[$ypos][$xpos])) {
                Write-Host " . " -NoNewline
            }
            else {
                if ($grid[$ypos][$xpos] -lt 100) {
                    Write-Host " " -NoNewline
                }
                if ($grid[$ypos][$xpos] -lt 10) {
                    Write-Host " " -NoNewline
                }
                Write-Host "$($grid[$ypos][$xpos])" -NoNewline
            }   
        }
        Write-Host "`n"
    }
    if ($devider) {
        write-host "------------------------------------"
    }
}

if ($test) {
    $in = Get-Content .\testinput.txt
}
else {
    $in = Get-Content .\input.txt
}

$y = $in.Count + 2
$x = $in[0].Length + 2

$grid = New-Object "PSobject[][]" $y,$x

$ypos = 1
foreach ($line in $in){
    for($xpos=1;$xpos -le $line.Length;$xpos++) {
        if (($line.Substring($xpos-1,1) -ne "9") -and ($null -ne $line.Substring($xpos-1,1))) {
            $grid[$ypos][$xpos] = 1
        }
    }
    $ypos++
}

#$old_answer = 0


<#
$run = 1
do {
    for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
        for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos-1])) {
                if ($null -ne $grid[$ypos][$xpos+1]) {
                    $grid[$ypos][$xpos] += $grid[$ypos][$xpos-1]
                    $grid[$ypos][$xpos-1] = 0
                }
                else {
                    $grid[$ypos][$xpos-1] += $grid[$ypos][$xpos]
                    $grid[$ypos][$xpos] = 0 
                }
                
            }
            #Write-Grid $grid -devider
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos-1][$xpos])) {
                if ($null -ne $grid[$ypos+1][$xpos]) {
                    $grid[$ypos][$xpos] += $grid[$ypos-1][$xpos]
                    $grid[$ypos-1][$xpos] = 0
                }
                else {
                    $grid[$ypos-1][$xpos] += $grid[$ypos][$xpos]
                    $grid[$ypos][$xpos] = 0 
                }
                
            }
        }
    }

#    Write-Grid $grid

    for($ypos=($grid.Count - 2);$ypos -gt 0;$ypos--) {
        for($xpos=($grid[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos+1])) {
                if ($null -ne $grid[$ypos][$xpos-1]) {
                    $grid[$ypos][$xpos] += $grid[$ypos][$xpos+1]
                    $grid[$ypos][$xpos+1] = 0
                }
                else {
                    $grid[$ypos][$xpos+1] += $grid[$ypos][$xpos]
                    $grid[$ypos][$xpos] = 0 
                }
            }
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos+1][$xpos])) {
                if ($null -ne $grid[$ypos-1][$xpos]) {
                    $grid[$ypos][$xpos] += $grid[$ypos+1][$xpos]
                    $grid[$ypos+1][$xpos] = 0
                }
                else {
                    $grid[$ypos+1][$xpos] += $grid[$ypos][$xpos]
                    $grid[$ypos][$xpos] = 0 
                }
            }
        }
    }

#    Write-Grid $grid


    for($ypos=($grid.Count - 2);$ypos -gt 0;$ypos--) {
        for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos-1])) {
                if ($null -ne $grid[$ypos][$xpos+1]) {
                    $grid[$ypos][$xpos] += $grid[$ypos][$xpos-1]
                    $grid[$ypos][$xpos-1] = 0
                }
                else {
                    $grid[$ypos][$xpos-1] += $grid[$ypos][$xpos]
                    $grid[$ypos][$xpos] = 0 
                }
                
            }
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos+1][$xpos])) {
                if ($null -ne $grid[$ypos-1][$xpos]) {
                    $grid[$ypos][$xpos] += $grid[$ypos+1][$xpos]
                    $grid[$ypos+1][$xpos] = 0
                }
                else {
                    $grid[$ypos+1][$xpos] += $grid[$ypos][$xpos]
                    $grid[$ypos][$xpos] = 0 
                }
                
            }
        }
    }

    for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
        for($xpos=($grid[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos+1])) {
                if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos+1][$xpos])) {
                    if ($null -ne $grid[$ypos][$xpos-1]) {
                        $grid[$ypos][$xpos] += $grid[$ypos][$xpos+1]
                        $grid[$ypos][$xpos+1] = 0
                    }
                    else {
                        $grid[$ypos][$xpos+1] += $grid[$ypos][$xpos]
                        $grid[$ypos][$xpos] = 0 
                    }
                }
            }
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos-1][$xpos])) {
                if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos+1][$xpos])) {
                    if ($null -ne $grid[$ypos+1][$xpos]) {
                        $grid[$ypos][$xpos] += $grid[$ypos-1][$xpos]
                        $grid[$ypos-1][$xpos] = 0
                    }
                    else {
                        $grid[$ypos-1][$xpos] += $grid[$ypos][$xpos]
                        $grid[$ypos][$xpos] = 0 
                    }
                }
            }
        }
    }
<#
    for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
        for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos-1])) {
                $grid[$ypos][$xpos] += $grid[$ypos][$xpos-1]
                $grid[$ypos][$xpos-1] = 0
            }
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos-1][$xpos])) {
                $grid[$ypos][$xpos] += $grid[$ypos-1][$xpos]
                $grid[$ypos-1][$xpos] = 0
            }
        }
    }

    for($xpos=($grid[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
        for($ypos=($grid.Count - 2);$ypos -gt 0;$ypos--) {
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos+1])) {
                $grid[$ypos][$xpos] += $grid[$ypos][$xpos+1]
                $grid[$ypos][$xpos+1] = 0
            }
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos+1][$xpos])) {
                $grid[$ypos][$xpos] += $grid[$ypos+1][$xpos]
                $grid[$ypos+1][$xpos] = 0
            }
        }
    }

    for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
        for($ypos=($grid.Count - 2);$ypos -gt 0;$ypos--) {
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos-1])) {
                $grid[$ypos][$xpos] += $grid[$ypos][$xpos-1]
                $grid[$ypos][$xpos-1] = 0
            }
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos+1][$xpos])) {
                $grid[$ypos][$xpos] += $grid[$ypos+1][$xpos]
                $grid[$ypos+1][$xpos] = 0
            }
        }
    }

    for($xpos=($grid[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
        for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos+1])) {
                $grid[$ypos][$xpos] += $grid[$ypos][$xpos+1]
                $grid[$ypos][$xpos+1] = 0
            }
            if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos-1][$xpos])) {
                $grid[$ypos][$xpos] += $grid[$ypos-1][$xpos]
                $grid[$ypos-1][$xpos] = 0
            }
        }
    }
#>
    [array]$top = @()

    for($ypos=0;$ypos -lt $grid.Count;$ypos++) {
        for($xpos=0;$xpos -lt $grid[$ypos].Count;$xpos++) {
            if ($grid[$ypos][$xpos] -gt 0) {
                $top += $grid[$ypos][$xpos]
            }
        }
    }

    $top = $top | Sort-Object -Descending

    $answer = $top[0] * $top[1] * $top[2]

    if ($answer -gt $old_answer){
        $old_answer = $answer
        $modified = $true
    }
    else {
        $modified = $false
    }

    write-host "Run: $run"
    Write-Grid $grid -devider
    $run++
} while ($modified)

<#
Write-Grid $grid
[array]$top = @()

for($ypos=0;$ypos -lt $grid.Count;$ypos++) {
    for($xpos=0;$xpos -lt $grid[$ypos].Count;$xpos++) {
        if ($grid[$ypos][$xpos] -gt 0) {
            $top += $grid[$ypos][$xpos]
        }
    }
}

$top = $top | Sort-Object -Descending

$top[0]
$top[1]
$top[2]
$answer = $top[0] * $top[1] * $top[2]
#>
$answer
