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
            $grid2[$ypos][$xpos] = 1
            $grid3[$ypos][$xpos] = 1
            $grid4[$ypos][$xpos] = 1
        }
    }
    $ypos++
}

for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
    for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
        if (($grid[$ypos][$xpos]) -and ($grid[$ypos][$xpos-1])) {
            $grid[$ypos][$xpos] += $grid[$ypos][$xpos-1]
        }
    }
}
for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
    for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
        if (($grid[$ypos][$xpos]) -and ($grid[$ypos-1][$xpos])) {
            $grid[$ypos][$xpos] += $grid[$ypos-1][$xpos]
        }
    }
}


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

Write-Host "----"

for($ypos= ($grid2.Count - 2);$ypos -gt 0;$ypos--) {
    for($xpos=($grid2[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
        if (($grid2[$ypos][$xpos]) -and ($grid2[$ypos][$xpos+1])) {
            $grid2[$ypos][$xpos] += $grid2[$ypos][$xpos+1]
        }
    }
}
for($ypos= ($grid2.Count - 2);$ypos -gt 0;$ypos--) {
    for($xpos=($grid2[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
        if (($grid2[$ypos][$xpos]) -and ($grid2[$ypos+1][$xpos])) {
            $grid2[$ypos][$xpos] += $grid2[$ypos+1][$xpos]
        }
    }
}

for($ypos=0;$ypos -lt $grid2.Count;$ypos++) {
    for($xpos=0;$xpos -lt $grid2[$ypos].Count;$xpos++) {
        if ($null -eq ($grid2[$ypos][$xpos])) {
            Write-Host ". " -NoNewline
        }
        else {
            write-host "$($grid2[$ypos][$xpos]) " -NoNewline
        }   
    }
    write-host "`n"
}

Write-Host "----"

for($ypos=1;$ypos -lt ($grid3.Count - 1);$ypos++) {
    for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
        for($xpos=1;$xpos -lt ($grid3[$ypos].Count - 1);$xpos++) {
            if (($grid3[$ypos][$xpos]) -and ($grid3[$ypos-1][$xpos])) {
                $grid3[$ypos][$xpos] += $grid3[$ypos-1][$xpos]
            }
        }
    }
}
for($ypos=1;$ypos -lt ($grid3.Count - 1);$ypos++) {
    for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
        if (($grid3[$ypos][$xpos]) -and ($grid3[$ypos][$xpos-1])) {
            $grid3[$ypos][$xpos] += $grid3[$ypos][$xpos-1]
        }
    }
}

for($ypos=0;$ypos -lt $grid3.Count;$ypos++) {
    for($xpos=0;$xpos -lt $grid[$ypos].Count;$xpos++) {
        if ($null -eq ($grid3[$ypos][$xpos])) {
            Write-Host ". " -NoNewline
        }
        else {
            write-host "$($grid3[$ypos][$xpos]) " -NoNewline
        }   
    }
    write-host "`n"
}

Write-Host "----"

for($ypos= ($grid4.Count - 2);$ypos -gt 0;$ypos--) {
    for($xpos=($grid4[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
        if (($grid4[$ypos][$xpos]) -and ($grid4[$ypos+1][$xpos])) {
            $grid4[$ypos][$xpos] += $grid4[$ypos+1][$xpos]
        }
    }
}
for($ypos= ($grid4.Count - 2);$ypos -gt 0;$ypos--) {
    for($xpos=($grid4[$ypos].Count - 2);$xpos -gt 0 ;$xpos--) {
        if (($grid4[$ypos][$xpos]) -and ($grid4[$ypos][$xpos+1])) {
            $grid4[$ypos][$xpos] += $grid4[$ypos][$xpos+1]
        }
    }
}

for($ypos=0;$ypos -lt $grid4.Count;$ypos++) {
    for($xpos=0;$xpos -lt $grid4[$ypos].Count;$xpos++) {
        if ($null -eq ($grid4[$ypos][$xpos])) {
            Write-Host ". " -NoNewline
        }
        else {
            write-host "$($grid4[$ypos][$xpos]) " -NoNewline
        }   
    }
    write-host "`n"
}

Write-Host "----"
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