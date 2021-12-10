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

[array]$answers = @()
foreach ($line in $in){
    $answer = 0
    $corrupt = $false
    [array]$Open = @()
    for($x=0;$x -lt $line.Length;$x++) {
        $character = $line.Substring($x,1)
        if ($OpenChars.Contains($character)) {
            $Open += $character
        }
        elseif ($CloseChars.Contains($character)) {
            $index = [array]::IndexOf($CloseChars,$character)
            if ($Open[-1] -eq $OpenChars[$index]){
                if ($Open.Count -gt 1) {
                    $Open = $Open[0..($Open.Count-2)]
                }
                else {
                    $Open = @()
                }
            }
            else {
                $corrupt = $true
                $x = $line.Length
            }
        }
    }
    if (!($corrupt)) {
        for($x=($Open.Count - 1);$x -ge 0;$x--) {
            $Score = [array]::IndexOf($OpenChars,$Open[$x]) + 1
            $answer = $answer * 5
            $answer += $Score
        }
        $answers += $answer
    }
}

($answers | Sort-Object)[($answers.count -1) / 2]



