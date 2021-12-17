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


$xrange = (($in.Substring($in.IndexOf("x=")+2,$in.IndexOf(",")-($in.IndexOf("x=")+2))) -split "\.\.")
$yrange = ($in.Substring($in.IndexOf("y=")+2)) -split "\.\."

#$yrange

[array]$maxhights = @()
$hit = $true
$starty = 1
$yvelocity = $starty
$maxhight = 0
$y = 0
do {
    $y += $yvelocity
    #Write-Host $y
    if ($y -gt [int]$yrange[1]){
        if ($y -gt $maxhight) {
            $maxhight = $y
        }
        #Write-Host "Max $maxhight Y $y"
        $yvelocity--
    }
    elseif ($y -ge [int]$yrange[0]) {
        #write-host "HIT"
        $starty++
        $maxhights += $maxhight
        $maxhight = 0
        $yvelocity = $starty
        $y = 0
    }
    else {
        #write-host "no hit $starty"
        if ($starty -gt 1000) {
            $hit =$false
        }
        $starty++
    }
    
} while ($hit)

$maxhights.Count
($maxhights | Measure-Object -Maximum).Maximum

#2080 too low
#>