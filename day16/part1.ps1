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

function CheckPacket {
    param (
        [Parameter()]
        [int]$position
    )

    [hashtable]$return = @{}
    $return += @{"Type"=""}
    $return += @{"Version"=[Convert]::ToInt32($transmission.Substring($position,3),2)}

    if ($transmission.Substring($position+3,3) -eq "100") {
        $return.Type = "Literal"
        $position += 6
        while($transmission.Substring($position,1) -eq "1") {
            $position += 5
        }
        $return += @{"End"=$position + 5}

    }
    else {
        if ($transmission.Substring($position+6,1) -eq "0") {
            $return.Type = "Opp0"
            $return += @{"hLength" = 22}
            $return += @{"pLength" = [Convert]::ToInt32($transmission.Substring($position+7,15),2) + 22}
            while ($return.pLength % 4){
                $return.pLength++
            }
        }
        else {
            $return.Type = "Opp1"
            $return += @{"hLength" = 18}
            $return += @{"pCount" = [Convert]::ToInt32($transmission.Substring($start+7,11),2)}
        }
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

[int]$start = 0
[int]$version = 0
[hashtable]$packetinfo = @{}
$dept = 1
while ($dept){
    $packetinfo += @{$dept=(CheckPacket -position $start)}
    if (($packetinfo.($dept)).Type -eq "Literal") {
        $version += ($packetinfo.($dept)).Version
        $start = ($packetinfo.($dept)).End
        $packetinfo.Remove($dept)
        if ($packetinfo.($dept-1).pCount) {
            if ($packetinfo.($dept-1).pCount -eq 1) {
                $packetinfo.Remove($dept - 1)
                $dept--
            }
            else {
                $packetinfo.($dept-1).pCount--
            }
        }
        if ($packetinfo.($dept-1).pLength) {
            if ($start -ge $packetinfo.($dept-1).pLength) {
                $packetinfo.Remove($dept - 1)
                $dept--
            }
        }
    }
    elseif (($packetinfo.($dept)).Type -eq "Opp0") {
        $version += ($packetinfo.($dept)).Version
        $start += ($packetinfo.($dept)).hLength
        $dept++        
    }
    elseif (($packetinfo.($dept)).Type -eq "Opp1") {
        $version += ($packetinfo.($dept)).Version
        $start += ($packetinfo.($dept)).hLength
        $dept++
    }
    if (($start -ge $transmission.Length) -or !(($transmission.Substring($start)).contains("1"))) {
        $dept = 0
    }
}

$version