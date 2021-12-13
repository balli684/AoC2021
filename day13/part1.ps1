[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [System.IO.FileInfo]$inputfile = ".\input.txt"
)


if (Test-Path $inputfile) {
    $in = Get-Content $inputfile
}
else {
    write-error "File $inputfile not found!"
    throw
}
