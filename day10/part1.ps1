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



$OpenChars = @("(","[","{","<")
$CloseChars = @(")","]","}",">")
$Score = @("3","57","1197","25137")

$answer = 0
foreach ($line in $in){
    [System.Collections.ArrayList]$Open = @()
    for($x=0;$x -lt $line.Length;$x++) {
        $character = $line.Substring($x,1)
        if ($OpenChars.Contains($character)) {
            $Open += @{"char"=$character;"position"=$x}
        }
        elseif ($CloseChars.Contains($character)) {
            $index = [array]::IndexOf($CloseChars,$character)
            if ($Open[-1].char -eq $OpenChars[$index]){
                $Open = $Open[0..($Open.Count-2)]
            }
            else {
                $answer += $Score[$index]
                $x = $line.Length
            }
        }
    }
}

$answer