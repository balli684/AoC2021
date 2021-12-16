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

function LiteralValue {
    param (
        [Parameter()]
        [int]$position
    )

    [hashtable]$return = @{}
    $return += @{"IsLiteral"=$false}
    $return += @{"End"="0"}
    $return += @{"Version"="0"}

    if ($transmission.Substring($start+3,3) -eq "100") {
        $return.IsLiteral = $true
        $return.Version = [Convert]::ToInt32($transmission.Substring($start,3),2)
        $position += 6
        while($transmission.Substring($position,1) -eq "1") {
            $position += 5
        }
        
        $return.End = $position + 5

    }
    return $return
}

[hashtable]$hex = @{}
$hex += @{"0"="0000"}
$hex += @{"1"="0001"}
$hex += @{"2"="0010"}
$hex += @{"3"="0011"}
$hex += @{"4"="0100"}
$hex += @{"5"="0101"}
$hex += @{"6"="0110"}
$hex += @{"7"="0111"}
$hex += @{"8"="1000"}
$hex += @{"9"="1001"}
$hex += @{"A"="1010"}
$hex += @{"B"="1011"}
$hex += @{"C"="1100"}
$hex += @{"D"="1101"}
$hex += @{"E"="1110"}
$hex += @{"F"="1111"}

[string]$global:transmission = ""

for($x=0;$x -lt $in.Length;$x++) {
    $transmission += $hex.($in.Substring($x,1))
}

#$transmission


#[array]$packets = @()
[int]$start = 0
[int]$end = 0
[int]$version = 0
while ($end + 1 -lt $transmission.Length){
    $transmission.Substring($start,$transmission.Length-$start)
    #$version += [Convert]::ToInt32($transmission.Substring($start,3),2)
    $literal = LiteralValue -position $start
    if ($literal.IsLiteral) {
        $version += $literal.Version
        $end = $literal.End
    }else {
        if ($transmission.Substring($start+6,1) -eq "0") {
            #$pLength = [Convert]::ToInt32($transmission.Substring($start+7,15),2) + 22
            #while ($pLength % 4){
            #    $pLength++
            #}
            $end = $start + 22
        }
        else {
            #$pCount = [Convert]::ToInt32($transmission.Substring($start+7,11),2)
            $end = $start+18
            #$count = 0
            #    if($transmission.Substring($end,1) -eq "1") {
            #        $end += 5
            #    }
        }
    }
    #$packets += $transmission.Substring($start,$end - $start)
    while ($end % 4){
        $end++
    }
    $start = $end
    #$end=$transmission.Length
}

$version