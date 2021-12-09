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

$digits = New-Object -TypeName psobject
$digits | Add-Member -MemberType NoteProperty -Name "0" -Value @()
$digits | Add-Member -MemberType NoteProperty -Name "1" -Value @()
$digits | Add-Member -MemberType NoteProperty -Name "2" -Value @()
$digits | Add-Member -MemberType NoteProperty -Name "3" -Value @()
$digits | Add-Member -MemberType NoteProperty -Name "4" -Value @()
$digits | Add-Member -MemberType NoteProperty -Name "5" -Value @()
$digits | Add-Member -MemberType NoteProperty -Name "6" -Value @()
$digits | Add-Member -MemberType NoteProperty -Name "7" -Value @()
$digits | Add-Member -MemberType NoteProperty -Name "8" -Value @()
$digits | Add-Member -MemberType NoteProperty -Name "9" -Value @()

[array]$outputs = @()
foreach ($line in $in) {
    $outputs += $line.substring($line.IndexOf("|") + 2)
}

[array]$paterns = @()
foreach ($line in $in) {
    $paterns += $line.substring(0,$line.IndexOf("|") - 1)
}

$awnser = 0
$count = 0
foreach ($patern in $paterns){
    $patern = $patern -split " "
    $digits.0 = @()
    $digits.1 = @()
    $digits.2 = @()
    $digits.3 = @()
    $digits.4 = @()
    $digits.5 = @()
    $digits.6 = @()
    $digits.7 = @()
    $digits.8 = @()
    $digits.9 = @()
    foreach ($set in $patern) {
        $set = $set
        switch ($set.length){
            2 {$digits.1 = $set}
            4 {$digits.4 = $set}
            3 {$digits.7 = $set}
            7 {$digits.8 = $set}
        }
    }
    foreach ($set in $patern) {
        if (($set.length -eq 6)){
            if (($digits.4) -and !($digits.9)) {
                $digits.9 = $set
                foreach ($character in ($digits.4).ToCharArray()) {
                    if (!($set.Contains($character))) {
                        $digits.9 = @()
                    }
                }
            }
            if (($set -ne $digits.9) -and !($digits.6)) {
                $dif = 0
                foreach ($character in ($digits.1).ToCharArray()) {
                    if (!($set.Contains($character))) {
                        $dif++
                    }
                }
                if ($dif -eq 1) {
                    $digits.6 = $set
                }
            }
            if (($set -ne $digits.6) -and ($set -ne $digits.9)) {
                $digits.0 = $set
            }
        }
    }
    foreach ($set in $patern) {
        if (($set.length -eq 5)){
            if (($digits.1) -and !($digits.3)) {
                if (($set.Contains(($digits.1)[0])) -and ($set.Contains(($digits.1)[1]))) {
                    $digits.3 = $set
                }
            }
            if ($digits.9 -and ($set -ne $digits.3)) {
                $dif = 0
                foreach ($character in ($digits.9).ToCharArray()) {
                    if (!($set.Contains($character))) {
                        $dif++
                    }
                }
                if ($dif -lt 2) {
                    $digits.5 = $set
                }
                else {
                    $digits.2 = $set
                }
            }
        }
    }
    $digits.0 = ($digits.0).ToCharArray() # Sort-Object
    $digits.1 = ($digits.1).ToCharArray() #| Sort-Object
    $digits.2 = ($digits.2).ToCharArray() #| Sort-Object
    $digits.3 = ($digits.3).ToCharArray() #| Sort-Object
    $digits.4 = ($digits.4).ToCharArray() #| Sort-Object
    $digits.5 = ($digits.5).ToCharArray() #| Sort-Object
    $digits.6 = ($digits.6).ToCharArray() #| Sort-Object
    $digits.7 = ($digits.7).ToCharArray() #| Sort-Object
    $digits.8 = ($digits.8).ToCharArray() #| Sort-Object
    $digits.9 = ($digits.9).ToCharArray() #| Sort-Object
    
    $output = $outputs[$count] -split " "
    $multiply = [math]::Pow(10,($output.Count - 1))
    foreach ($set in $output -split " ") {
        $set = $set.ToCharArray() #| Sort-Object
        for ($x = 0; $x -le 9; $x++) {
            if ($set.Count -eq ($digits.($x)).count) {
                $same = $true
                foreach ($character in $digits.($x)) {
                    if (!($set.Contains($character))) {
                        $same = $false
                    }
                }
                if ($same) {
                    $awnser += ($x * $multiply)
                }
            }
        }
        $multiply = $multiply / 10
    }
    $count++ 
}

$awnser