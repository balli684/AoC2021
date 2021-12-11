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

$grid = New-Object "PSobject[][]" $in.Count,$in[0].Length

$ypos = 0
foreach ($line in $in){
    for($xpos=0;$xpos -le $line.Length;$xpos++) {
        $grid[$ypos][$xpos] = [int]$line.Substring($xpos,1)
    }
    $ypos++
}

write-grid $grid