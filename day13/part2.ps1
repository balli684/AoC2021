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

[array]$xcoords = @()
[array]$ycoords = @()
[System.Collections.ArrayList]$instructions = @()

foreach ($line in $in){
    if ($line -like "*,*") {
        $line = $line -split ","
        $xcoords += [int]$line[0]
        $ycoords += [int]$line[1]
    }
    elseif ($line -like "fold along*") {
        $instructions.add(($line -split " ")[-1] -split "=") | Out-Null
    }
}

foreach ($instruction in $instructions) {
    if ($instruction[0] -eq "y") {
        $ymax = (($ycoords | Measure-Object -Maximum).maximum)
        for ($count=0;$count -lt $ycoords.Count;$count++) {
            if ($ycoords[$count] -gt $instruction[1]) {
                $ycoords[$count] = (2 * $instruction[1]) - $ycoords[$count]
            }
            elseif ($ycoords[$count] -eq $instruction[1]) {
                $ycoords[$count] = $null
                $xcoords[$count] = $null
            }
        }
    }
    elseif ($instruction[0] -eq "x") {
        $xmax = (($xcoords | Measure-Object -Maximum).maximum)
        for ($count=0;$count -lt $xcoords.Count;$count++) {
            if ($xcoords[$count] -gt $instruction[1]) {
                $xcoords[$count] = (2 * $instruction[1]) - $xcoords[$count]
            }
            elseif ($xcoords[$count] -eq $instruction[1]) {
                $ycoords[$count] = $null
                $xcoords[$count] = $null
            }
        }
    }
}

$grid = New-Object "PSobject[][]" (($ycoords | Measure-Object -Maximum).maximum + 1),(($xcoords | Measure-Object -Maximum).maximum + 1)

for($count=0;$count -lt $ycoords.Count;$count++){
    if (($null -ne $ycoords[$count]) -and ($null -ne $xcoords[$count])){
        $grid[$ycoords[$count]][$xcoords[$count]] = "#"
    }
}

Write-Grid $grid
