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

$grid = New-Object "PSobject[][]" ($in.Count),($in[0].Length)
$gridpath = New-Object "PSobject[][]" ($in.Count),($in[0].Length)

#for($x=0;$x -lt $grid[0].Count;$x++) {
#    $grid[0][$x] = 10
#}
$y = 0
foreach ($line in $in){
    for($x=0;$x -lt $grid[$y].Count;$x++) {
        $grid[$y][$x] = [int]$line.Substring($x,1)
    }
    $y++
}

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
$count = 1
#Write-Grid $gridpath -devider
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

#Write-Grid $gridpath

$gridpath[$gridpath.Count-1][$gridpath[0].Count-1]

