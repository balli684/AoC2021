[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [switch]$test = $false
)

if ($test) {
    $input = Get-Content .\testinput.txt
}
else {
    $input = Get-Content .\input.txt
}

$coords = $input -split " -> "
$coords = $coords -split ","

$max = ($coords | Measure-Object -Maximum).Maximum

$grid = New-Object "object[][]" ($max + 1),($max + 1)

$step = 0
while ($step -lt ($coords.Count)) {
    [int]$x1 = $coords[$step]
    [int]$y1 = $coords[$step + 1]
    [int]$x2 = $coords[$step + 2]
    [int]$y2 = $coords[$step + 3]
    if ($x1 -eq $x2) {
        if ($y1 -lt $y2) {
            $ymin = $y1
            $ymax = $y2
        }
        else {
            $ymin = $y2
            $ymax = $y1
        }
        for ($ymin;$ymin -le $ymax; $ymin++) {
            $grid[$ymin][$x1]++
        }
    }
    elseif ($y1 -eq $y2) {
        if ($x1 -lt $x2) {
            $xmin = $x1
            $xmax = $x2
        }
        else {
            $xmin = $x2
            $xmax = $x1
        }
        for ($xmin;$xmin -le $xmax; $xmin++) {
            $grid[$y1][$xmin]++
        }
    }
    else {
        if ($x1 -lt $x2) {
            $xcount = 1
        }
        else {
            $xcount = -1
        }
        if ($y1 -lt $y2) {
            $ycount = 1
        }
        else {
            $ycount = -1
        }
        $grid[$y2][$x2]++
        do {
            $grid[$y1][$x1]++
            $x1 += $xcount
            $y1 += $ycount
        } while (($x1 -ne $x2) -and ($y1 -ne $y2))
    }
    $step = $step + 4
}

$answer = 0
foreach ($row in $grid) {
    foreach ($number in $row) {
        if ($number -ge 2) {
            $answer++
        }
    }
}

$answer

<#
foreach ($row in $grid) {
    foreach ($number in $row) {
        if ($number -gt 0) {
            write-host -NoNewline $number
        }
        else {
            write-host -NoNewline "."
        }
    }
    write-host "`n"
}
#>