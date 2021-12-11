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

function Up-Adjecent {
    param (
    [Parameter(Mandatory=$true)]
    [array]$grid,
    [Parameter(Mandatory=$true)]
    [int]$y,
    [Parameter(Mandatory=$true)]
    [int]$x
    )

    if ($y -gt 0){
        $starty = $y - 1
    }
    else {
        $starty = 0
    }

    if ($y -lt ($grid.Count - 1)){
        $stopy = $y + 1
    }
    else {
        $stopy = $grid.Count - 1
    }

    if ($x -gt 0){
        $startx = $x - 1
    }
    else {
        $startx = 0
    }

    if ($x -lt ($grid[0].Count - 1)){
        $stopx = $x + 1
    }
    else {
        $stopx = $grid[0].Count - 1
    }

    for($starty;$starty -le $stopy;$starty++) {
        for($startx;$startx -le $stopx;$startx++) {
            if (($starty -ne $y) -or ($startx -ne $x)) {
                $grid[$starty][$startx]++
                write-host "upped $startx $starty"
            }
        }
    }
    $grid
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

#>