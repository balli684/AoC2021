[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [switch]$test = $false
)


function Write-Grid {
    param (
    [Parameter(Mandatory=$true)]
    [array]$grid
    )
    for($ypos=0;$ypos -lt $grid.Count;$ypos++) {
        for($xpos=0;$xpos -lt $grid[$ypos].Count;$xpos++) {
            if ($null -eq ($grid[$ypos][$xpos])) {
                Write-Host ". " -NoNewline
            }
            else {
                write-host "$($grid[$ypos][$xpos]) " -NoNewline
            }   
        }
        write-host "`n"
    }
    Write-Host "---"
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
$grid2 = New-Object "PSobject[][]" $y,$x
$grid3 = New-Object "PSobject[][]" $y,$x
$grid4 = New-Object "PSobject[][]" $y,$x

$ypos = 1
foreach ($line in $in){
    for($xpos=1;$xpos -le $line.Length;$xpos++) {
#        $grid[$ypos][$xpos] = [int]$line.Substring($xpos-1,1)
        if (($line.Substring($xpos-1,1) -ne "9") -and ($null -ne $line.Substring($xpos-1,1))) {
            $grid[$ypos][$xpos] = 1
        }
    }
    $ypos++
}

for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
    for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
        if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos-1])) {
            $grid[$ypos][$xpos] += $grid[$ypos][$xpos-1]
            $grid[$ypos][$xpos-1] = 0
        }
    }
}

Write-Grid $grid

for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
    for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
        if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos-1][$xpos])) {
            $grid[$ypos][$xpos] += $grid[$ypos-1][$xpos]
            $grid[$ypos-1][$xpos] = 0
        }
    }
}

Write-Grid $grid

for($ypos=($grid.Count - 2);$ypos -gt 0;$ypos--) {
    for($xpos=($grid[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
        if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos+1])) {
            $grid[$ypos][$xpos] += $grid[$ypos][$xpos+1]
            $grid[$ypos][$xpos+1] = 0
        }
    }
}

Write-Grid $grid

for($xpos=($grid[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
    for($ypos=($grid.Count - 2);$ypos -gt 0;$ypos--) {
        if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos+1][$xpos])) {
            $grid[$ypos][$xpos] += $grid[$ypos+1][$xpos]
            $grid[$ypos+1][$xpos] = 0
        }
    }
}

Write-Grid $grid

for($ypos=($grid.Count - 2);$ypos -gt 0;$ypos--) {
    for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
        if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos-1])) {
            $grid[$ypos][$xpos] += $grid[$ypos][$xpos-1]
            $grid[$ypos][$xpos-1] = 0
        }
    }
}

Write-Grid $grid

for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
    for($ypos=($grid.Count - 2);$ypos -gt 0;$ypos--) {
        if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos+1][$xpos])) {
            $grid[$ypos][$xpos] += $grid[$ypos+1][$xpos]
            $grid[$ypos+1][$xpos] = 0
        }
    }
}

Write-Grid $grid

for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
    for($xpos=($grid[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
        if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos][$xpos+1])) {
            $grid[$ypos][$xpos] += $grid[$ypos][$xpos+1]
            $grid[$ypos][$xpos+1] = 0
        }
    }
}

Write-Grid $grid

for($xpos=($grid[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
    for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
        if (($null -ne $grid[$ypos][$xpos]) -and ($null -ne $grid[$ypos-1][$xpos])) {
            $grid[$ypos][$xpos] += $grid[$ypos-1][$xpos]
            $grid[$ypos-1][$xpos] = 0
        }
    }
}

Write-Grid $grid


<#
[System.Collections.ArrayList]$lowpoints=@()

$ypos -lt ($grid.Count - 1);$ypos++) {
    for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
        [array]$compare=@($grid[$ypos-1][$xpos],$grid[$ypos+1][$xpos],$grid[$ypos][$xpos-1],$grid[$ypos][$xpos+1])
        $low=$true
        foreach ($item in $compare){
            if(($null -ne $item) -and ($item -le $grid[$ypos][$xpos])){
                $low=$false
            }
        }
        if ($low) {
            $lowpoints +=  @{"y"=$ypos;"x"=$xpos}
        }
    }
}

$lowpoints
#>