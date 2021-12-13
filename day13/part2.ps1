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

#($ycor | Measure-Object -Maximum).maximum + 1
#($xcor | Measure-Object -Maximum).maximum + 1

$grid = New-Object "PSobject[][]" (($ycor | Measure-Object -Maximum).maximum + 1),(($xcor | Measure-Object -Maximum).maximum + 1)

for($count=0;$count -lt $xcor.Count;$count++){
    $grid[$ycor[$count]][$xcor[$count]] = "#"
}
#Write-Grid $grid
#$count = 1
#$instruction = $instructions[1]
foreach ($instruction in $instructions) {
    #write-host "instruction $instruction"
    if($instruction[0] -eq "y") {
        if ([int]$instruction[1] -ge ($grid.Count) / 2) {
            #write-host "no dif" 
            $dif1 = 0
            [int]$dif2 = ([int]$instruction[1] * 2) - ($grid.Count - 1)
            $gridnew = New-Object "PSobject[][]" ([int]$instruction[1]),($grid[0].Count)
        }
        else {
            [int]$dif1 = ($grid.Count - 1) - ([int]$instruction[1] * 2)
            $dif2 = 0
            #write-host "dif is $dif"
            $gridnew = New-Object "PSobject[][]" (($grid.Count - 1) - [int]$instruction[1]),($grid[0].Count)
        }
        #Write-Host "Dif is $dif"
        for($y=0;$y -lt [int]$instruction[1];$y++) {
            for($x=0;$x -lt $gridnew[0].Count;$x++) {
                if ($grid[$y][$x]) {
                    #Write-Host "hit"
                    try {$gridnew[$y+$dif1][$x] = $grid[$y][$x]} catch {write-host "Y: $y - X: $x"}
                }
            }
        }
        for($y=($grid.Count - 1);$y -gt [int]$instruction[1];$y--) {
            for($x=0;$x -lt $gridnew[0].Count;$x++) {
                if($grid[$y][$x]) {
                    #Write-Host "hit"
                    try {$gridnew[($grid.Count - 1) - $y][$x] = $grid[$y][$x]} catch {write-host "Y: $y - X: $x"}
                }
            }
        }
    }
    else {
        if ([int]$instruction[1] -ge ($grid[0].Count) / 2) {
            #write-host "GT"
            $dif = 0
            $gridnew = New-Object "PSobject[][]" $grid.Count,([int]$instruction[1])
            #$gridnew = New-Object "PSobject[][]" $grid.Count,(($grid[0].Count - 1) - [int]$instruction[1])
        }
        else {
            #write-host "else"
            
            #[int]$dif = [int]$instruction[1] - [math]::Round(($grid[0].Count) / 2)
            [int]$dif = ($grid[0].Count - 1) - ([int]$instruction[1] * 2)
            #$gridnew = New-Object "PSobject[][]" $grid.Count,([int]$instruction[1])
            $gridnew = New-Object "PSobject[][]" $grid.Count,(($grid[0].Count - 1) - [int]$instruction[1])
        }
            #Write-Host "Dif is $dif"
            for($x=0;$x -lt [int]$instruction[1];$x++) {
                for($y=0;$y -lt $gridnew.Count;$y++) {
                    if ($grid[$y][$x]) {
                        try {$gridnew[$y][$x+$dif] = $grid[$y][$x]} catch {write-host "Y: $y - X: $x"}
                        #$gridnew[$y][$x+$dif] = $grid[$y][$x]
                    }
                }
            }
            for($x=($grid[0].Count - 1);$x -gt [int]$instruction[1];$x--) {
                for($y=0;$y -lt $gridnew.Count;$y++) {
                    if($grid[$y][$x]) {
                        try {$gridnew[$y][($grid[0].Count - 1) - $x] = $grid[$y][$x]} catch {write-host "Y: $y - X: $x"}
                        #$gridnew[$y][$x] = $grid[$y][($grid[0].Count + 2) - $x]
                    }
                }
            }
#    $count++
    }
    $grid = $gridnew
#    Write-Host $instruction
#    Write-Grid $grid -devider
}

Write-Grid $gridnew
