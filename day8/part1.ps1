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
$digits | Add-Member -MemberType NoteProperty -Name "0" -Value @("a","b","c","e","f","g")
$digits | Add-Member -MemberType NoteProperty -Name "1" -Value @("c","f")
$digits | Add-Member -MemberType NoteProperty -Name "2" -Value @("a","c","d","e","g")
$digits | Add-Member -MemberType NoteProperty -Name "3" -Value @("a","c","d","f","g")
$digits | Add-Member -MemberType NoteProperty -Name "4" -Value @("b","c","d","f")
$digits | Add-Member -MemberType NoteProperty -Name "5" -Value @("a","b","d","f","g")
$digits | Add-Member -MemberType NoteProperty -Name "6" -Value @("a","b","d","e","f","g")
$digits | Add-Member -MemberType NoteProperty -Name "7" -Value @("a","c","f")
$digits | Add-Member -MemberType NoteProperty -Name "8" -Value @("a","b","c","d","e","f","g")
$digits | Add-Member -MemberType NoteProperty -Name "9" -Value @("a","b","c","d","f","g")

[array]$values = @()
foreach ($line in $in) {
    $values += $line.substring($line.IndexOf("|") + 2) -split " "
}

$awnser = 0
$checknumbers = @(1,4,7,8)
[array]$check = @()

foreach ($number in $checknumbers){
    $check += $digits.($number).count
}



foreach ($value in $values) {
    if ($check -contains $value.length) {
        $awnser++
    }
}

$awnser