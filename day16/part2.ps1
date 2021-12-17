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

    [string]$packetValue = ""
    [hashtable]$return = @{}
    $return += @{"Type"=""}
    $return += @{"Version"=[Convert]::ToInt32($transmission.Substring($position,3),2)}
    $return += @{"Id"=[Convert]::ToInt32($transmission.Substring($position+3,3),2)}

    if ($transmission.Substring($position+3,3) -eq "100") {
        $return.Type = "Literal"
        $position += 6
        while($transmission.Substring($position,1) -eq "1") {
            $packetValue += $transmission.Substring($position+1,4)
            $position += 5
        }
        
        $return += @{"End"=$position + 5}
        $packetValue += $transmission.Substring($position+1,4)
        $return += @{"Value"=[Convert]::ToInt64($packetValue,2)}

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
    #write-host "Type $($return.Type)"
    return $return
}

function CalcOperator {
    param (
        [Parameter()]
        [array]$operator
    )
    #write-host $operator
    switch ($operator[0]) {
        0 {
            $return = 0
            foreach ($value in $operator[1..($operator.Count - 1)]) {
                $return += $value
            }
        }
        1 {
            $return = $operator[1]
            foreach ($value in $operator[2..($operator.Count - 1)]) {
                $return = $return * $value
            }
        }
        2 {
            $return = (($operator[1..($operator.Count - 1)]) | Measure-Object -Minimum).Minimum
        }
        3 {
            $return = (($operator[1..($operator.Count - 1)]) | Measure-Object -Maximum).Maximum
        }
        5 {
            if ($operator[1] -gt $operator[2]) {
                $return = 1
            }
            else {
                $return = 0
            }
        }
        6 {
            if ($operator[1] -lt $operator[2]) {
                $return = 1
            }
            else {
                $return = 0
            }
        }
        7 {
            if ($operator[1] -eq $operator[2]) {
                $return = 1
            }
            else {
                $return = 0
            }
        }
    }

    $return
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
#[int]$version = 0
[hashtable]$packetinfo = @{}
[hashtable]$operator = @{}
$dept = 1
while ($dept){
    $packetinfo += @{$dept=(CheckPacket -position $start)}
    if (($packetinfo.($dept)).Type -eq "Literal") {
        #$packetinfo.($dept)
        #$version += ($packetinfo.($dept)).Version
        $start = ($packetinfo.($dept)).End
        $value = ($packetinfo.($dept)).Value
        $packetinfo.Remove($dept)
        if ($packetinfo.($dept-1).pCount) {
            if ($packetinfo.($dept-1).pCount -eq 1) {
                #write-host $value
                $operator.($dept-1) += $value
                $packetinfo.Remove($dept - 1)
                $dept--
                if ($dept -gt 1) {
                    #CalcOperator $operator.($dept)
                    $operator.($dept-1) += CalcOperator $operator.($dept)
                    $operator.Remove($dept)
                }
            }
            else {
                $operator.($dept-1) += $value
                $packetinfo.($dept-1).pCount--
            }
        }
        elseif ($packetinfo.($dept-1).Type -eq "Opp0") {
            #write-host "Pack type: $($packetinfo.($dept-1).Type)"
            if ($start -ge $packetinfo.($dept-1).pLength) {
                $operator.($dept-1) += $value
                $packetinfo.Remove($dept - 1)
                $dept--
                if ($dept -gt 1) {
                    #CalcOperator $operator.($dept)
                    $operator.($dept-1) += CalcOperator $operator.($dept)
                    $operator.Remove($dept)
                }
            }
            else {
                #write-host "add value $value"
                $operator.($dept-1) += $value
            }
        }
    }
    elseif (($packetinfo.($dept)).Type -eq "Opp0") {
        $start += ($packetinfo.($dept)).hLength
        $operator += @{$dept=[array]@(($packetinfo.($dept)).Id)}
        $dept++
               
    }
    elseif (($packetinfo.($dept)).Type -eq "Opp1") {
        $start += ($packetinfo.($dept)).hLength
        $operator += @{$dept=[array]@(($packetinfo.($dept)).Id)}
        $dept++
        
    }
    if (($start -ge $transmission.Length) -or !(($transmission.Substring($start)).contains("1"))) {
        $out = CalcOperator $operator.1
        $dept = 0
    }
}

#Write-Host "-----"
$out

#Not correct: 11889203665