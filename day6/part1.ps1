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

$input = $input -split ","

$days = 80
$day = 0

while ($day -lt $days) {
    $count = 0
    $maxcount = $input.Count
    while ($count -lt $maxcount) {
        if ($input[$count] -gt 0) {
            [int]$new = $input[$count]
            $new--
            $input[$count] = $new
        }
        else {
            $input[$count] = 6
            $input += 8
        }
        $count++
    }
    $day++
}

$input.Count