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
                Write-Host " ." -NoNewline
            }
            else {
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

$grid = New-Object "PSobject[][]" ($in.Count + 2),($in[0].Length + 2)

$ypos = 1
foreach ($line in $in){
    for($xpos=0;$xpos -lt $line.Length;$xpos++) {
        $grid[$ypos][$xpos+1] = [int]$line.Substring($xpos,1)
    }
    $ypos++
}

$maxrounds = 100
$flashes = 0

for ($round = 1;$round -le $maxrounds;$round++) {
    for($y=1;$y -lt ($grid.Count - 1);$y++) {
        for ($x=1;$x -lt ($grid[$y].Count - 1);$x++) {
            $grid[$y][$x]++
        }
    }
    
    do {
        $prevflashes = $flashes
        for($y=0;$y -lt $grid.Count;$y++) {
            for ($x=0;$x -lt $grid[$y].Count;$x++) {
                if ($grid[$y][$x] -gt 9) {
                    $grid[$y][$x] = 0
                    Try { 
                        if ($grid[$y-1][$x-1]) {
                            $grid[$y-1][$x-1]++
                        }
                    }Catch {}
                    Try { 
                        if ($grid[$y-1][$x]) {
                            $grid[$y-1][$x]++
                        }
                    }Catch {}
                    Try { 
                        if ($grid[$y-1][$x+1]) {
                            $grid[$y-1][$x+1]++
                        }
                    }Catch {}
                    Try { 
                        if ($grid[$y][$x-1]) {
                            $grid[$y][$x-1]++
                        }
                    }Catch {}
                    Try { 
                        if ($grid[$y][$x+1]) {
                            $grid[$y][$x+1]++
                        }
                    }Catch {}
                    Try { 
                        if ($grid[$y+1][$x-1]) {
                            $grid[$y+1][$x-1]++
                        }
                    }Catch {}
                    Try { 
                        if ($grid[$y+1][$x]) {
                            $grid[$y+1][$x]++
                        }
                    }Catch {}
                    Try { 
                        if ($grid[$y+1][$x+1]) {
                            $grid[$y+1][$x+1]++
                        }
                    }Catch {}
                    $flashes++
                }
            }
        }
    } while ($flashes -ne $prevflashes)
}

$flashes
