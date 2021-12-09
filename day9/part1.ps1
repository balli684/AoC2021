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

$ypos = 1
foreach ($line in $in){
    for($xpos=1;$xpos -le $line.Length;$xpos++) {
        $grid[$ypos][$xpos] = [int]$line.Substring($xpos-1,1)
    }
    $ypos++
}


[array]$lowpoints=@()

for($ypos=1;$ypos -lt ($grid.Count - 1);$ypos++) {
    for($xpos=1;$xpos -lt ($grid[$ypos].Count - 1);$xpos++) {
        [array]$compare=@($grid[$ypos-1][$xpos],$grid[$ypos+1][$xpos],$grid[$ypos][$xpos-1],$grid[$ypos][$xpos+1])
        $low=$true
        foreach ($item in $compare){
            if(($null -ne $item) -and ($item -le $grid[$ypos][$xpos])){
                $low=$false
            }
        }
        if ($low) {
            $lowpoints += $grid[$ypos][$xpos]
        }
    }
}

[int]$risklevel = 0
$lowpoints | foreach {$risklevel += ($_ + 1)}
$risklevel