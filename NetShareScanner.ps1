$netviewout = net view
$devices =  New-Object System.Collections.Generic.List[System.Object]

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
   net view $device.Trim() 
}

Read-Host -Prompt "Press Enter to exit"


    

