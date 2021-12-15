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

$multiplier = 5

$grid = New-Object "PSobject[][]" ($in.Count * $multiplier),($in[0].Length * $multiplier)
$gridpath = New-Object "PSobject[][]" $grid.Count,$grid[0].Count

$y = 0
foreach ($line in $in){
    for($x=0;$x -lt $line.Length;$x++) {
        for($mul=0;$mul -lt $multiplier;$mul++) {
            $grid[$y][$x+($line.Length * $mul)] = [int]$line.Substring($x,1) + $mul
        }
    }
    $y++
}

for ($y = 0;$y -lt $in.count;$y++) {
    for($x=0;$x -lt $grid[$y].Count;$x++) {
        for($mul=1;$mul -lt $multiplier;$mul++) {
            $grid[$y+($in.Count * $mul)][$x] = $grid[$y][$x] + $mul
        }
    }
}

for($y=0;$y -lt $grid.Count;$y++) {
    for($x=0;$x -lt $grid[$y].Count;$x++) {
        if($grid[$y][$x] -gt 9) {
            $grid[$y][$x] -= 9
        }
    }
}

Write-Host "Grid filled"

$gridpath[0][0] = 0

for($x=1;$x -lt $grid[0].Count;$x++) {
    $gridpath[0][$x] = $gridpath[0][$x-1] + $grid[0][$x]
}

for($y=1;$y -lt $grid.Count;$y++) {
    $gridpath[$y][0] = $gridpath[$y-1][0] + $grid[$y][0] 
}

for($y=1;$y -lt $grid.Count;$y++) {
    for($x=1;$x -lt $grid[$y].Count;$x++) {
        if ($gridpath[$y-1][$x] -le $gridpath[$y][$x-1]) {
            $gridpath[$y][$x] = $gridpath[$y-1][$x] + $grid[$y][$x] 
        }
        else {
            $gridpath[$y][$x] = $gridpath[$y][$x-1] + $grid[$y][$x]
        }
    }
}

Write-Host "First walkthrough"

$count = 1
do {
    $changed = $false
    for($y=1;$y -lt $grid.Count;$y++) {
        for($x=1;$x -lt $grid[$y].Count;$x++) {
            if ($y -lt $grid.Count -1 ) {
                if ($gridpath[$y][$x] -gt $grid[$y][$x] + $gridpath[$y+1][$x]) {
                    $gridpath[$y][$x] = $grid[$y][$x] + $gridpath[$y+1][$x]
                    $changed = $true
                }
            }
            if ($x -lt $grid[$y].Count -1 ) {
                if ($gridpath[$y][$x] -gt $grid[$y][$x] + $gridpath[$y][$x+1]) {
                    $gridpath[$y][$x] = $grid[$y][$x] + $gridpath[$y][$x+1]
                    $changed = $true 
                }
            }
            if ($gridpath[$y][$x] -gt $grid[$y][$x] + $gridpath[$y-1][$x]) {
                $gridpath[$y][$x] = $grid[$y][$x] + $gridpath[$y-1][$x]
                $changed = $true
            }
            if ($gridpath[$y][$x] -gt $grid[$y][$x] + $gridpath[$y][$x-1]) {
                $gridpath[$y][$x] = $grid[$y][$x] + $gridpath[$y][$x-1]
                $changed = $true
            }
        }
    }
    Write-Host "Round $count"
    $count++
} while ($changed)

$gridpath[$gridpath.Count-1][$gridpath[0].Count-1]
