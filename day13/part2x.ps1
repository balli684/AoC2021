[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [System.IO.FileInfo]$inputfile = ".\input.txt"
)

. ..\functions.ps1

if (Test-Path $inputfile) {
    $in = Get-Content $inputfile
}
else {
    write-error "File $inputfile not found!"
    throw
}

[array]$xcor = @()
[array]$ycor = @()
[System.Collections.ArrayList]$instructions = @()

foreach ($line in $in){
    if ($line -like "*,*") {
        $line = $line -split ","
        $xcor += [int]$line[0]
        $ycor += [int]$line[1]
    }
    elseif ($line -like "fold along*") {
        $instructions.add(($line -split " ")[-1] -split "=") | Out-Null
    }
}

$grid = New-Object "PSobject[][]" (($ycor | Measure-Object -Maximum).maximum + 1),(($xcor | Measure-Object -Maximum).maximum + 1)

for($count=0;$count -lt $xcor.Count;$count++){
    $grid[$ycor[$count]][$xcor[$count]] = "#"
}
#Write-Grid $grid

#$instruction = $instructions[0]
foreach ($instruction in $instructions) {
    if($instruction[0] -eq "y") {
        if ([int]$instruction[1] -ge ($grid.Count - 1) / 2) {
            for($y=0;$y -lt [int]$instruction[1];$y++) {
                for($x=0;$x -lt $grid[0].Count;$x++) {
                    if($grid[($grid.Count - 1) - $y][$x]) {
                        $grid[$y][$x] = $grid[($grid.Count - 1) - $y][$x]
                    }
                }
            }
            $grid = $grid[0..([int]$instruction[1] - 1)]
        }
        else {
            for($y=0;$y -lt [int]$instruction[1];$y++) {
                for($x=0;$x -lt $grid[0].Count;$x++) {
                    if($grid[$y][$x]) {
                        $grid[($grid.Count - 1) - $y][$x] = $grid[$y][$x]
                    }
                }
            }
            $grid = $grid[([int]$instruction[1] + 1)..($grid.Count - 1)]
        }
    }
    else {
        if ([int]$instruction[1] -ge ($grid[0].Count - 1) / 2) {
            for($x=0;$x -lt [int]$instruction[1];$x++) {
                for($y=0;$y -lt $grid.Count;$y++) {
                    if($grid[$y][($grid[0].Count - 1) - $x]) {
                        $grid[$y][$x] = $grid[$y][($grid[0].Count - 1) - $x]
                    }
                }
            }
            for ($y=0;$y -lt $grid.count;$y++) {
                $grid[$y] =  $grid[$y][0..([int]$instruction[1] - 1)]
            }
            #$grid = $grid[0..([int]$instruction[1] - 1)]
        }
        else {
            for($x=0;$x -lt [int]$instruction[1];$x++) {
                for($y=0;$y -lt $grid.Count;$y++) {
                    if($grid[$y][$x]) {
                        $grid[$y][($grid[0].Count - 1) - $x] = $grid[$y][$x]
                    }
                }
            }
            for ($y=0;$y -lt $grid.count;$y++) {
                $grid[$y] =  $grid[$y][([int]$instruction[1] + 1)..($grid[$y].Count - 1)]
            }
        }
    }
}
Write-Grid $grid
