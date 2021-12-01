$input = Get-Content .\input.txt
[int]$counter = 3
[int]$awnser = 0

[int]$one = $input[0]
[int]$two = $input[1]
[int]$three = $input[2]
[int]$oldvalue = $one + $two + $three

while ($counter -le $input.Count) {
    [int]$newvalue = $one + $two + $three

    Write-Host "$one $two $three"
    Write-Host $oldvalue
    Write-Host $newvalue

    if ($newvalue -gt $oldvalue) {
        $awnser++
    }
    $one = $two
    $two = $three
    [int]$three = $input[$counter]
    $oldvalue = $newvalue
    $counter++
}

Write-Host $awnser