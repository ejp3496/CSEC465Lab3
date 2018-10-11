$netviewout = net view
$devices =  New-Object System.Collections.Generic.List[System.Object]
$disks = New-Object System.Collections.Generic.List[System.Object]

foreach ($line in $netviewout){
    #$line = ($netviewout.split("\n"))[0] 
    #write-host $line 
    if( $line.startswith("\\"))
    {
        $devices.Add($line)
    }
}

foreach ($device in $devices)
{
   write-host $device.Trim()  ":"
   $shares = net view $device.Trim() 
   foreach ($line in $shares)
   {
       if( $line.Contains("Disk") )
       {
            write-host trying $line
            $try = "net use * "+$device.Trim()+"\"+($line.Split(" "))[0]
            iex $try
            $disks.add($line)
       }
   }
   write-host "`n"
}



Read-Host -Prompt "Press Enter to exit"
