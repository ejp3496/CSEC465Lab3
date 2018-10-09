$addresses = New-Object System.Collections.ArrayList

foreach($line in [System.IO.File]::ReadLines($args[0])) {
    try {
        $address = [System.Net.Dns]::GetHostAddresses($line)
        [void]$addresses.Add($address[1])
    } catch {
        Write-Warning -Message "Record not found for $line"
    }
}
foreach($address in $Addresses) {
    Write-Host $address
}