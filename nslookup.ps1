$dnsresolutions = @{}


foreach($line in [System.IO.File]::ReadLines($args[0])) {
    try {
        $dnsresolutions.Add($line, [System.Net.Dns]::GetHostAddresses($line)[1])
    } catch {
        #$dnsresolutions[$line] = "Record not found"
        $dnsresolutions.Add($line, "Record not found")
    }
}

 $dnsresolutions