$input = Get-Content .\input.txt
[int]$counter = 0

[int]$oldvalue =  $input[0]

foreach ($line in $input) {
    [int]$newvalue = $line
    if ($newvalue -gt $oldvalue) {
        $counter++
    }
    $oldvalue = $newvalue
}

Write-Host $counter