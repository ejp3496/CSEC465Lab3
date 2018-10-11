NetShareScanner.ps1
  usage: powershell ./NetShareScanner.ps1
  
  result: will list all host and their respective network shares.
    The script will then attempt to connect to each share 
		and print weather or not it was successful.
  
nslookup.ps1
  usage: powershell ./nslookup.ps1 file.txt
  the file should conatain a list of host names to be looked up (one per line)
  
  result: will print hostnames with their corresponding address if it was resolved. If not, the value will display as "Record not found".
  
 osclasstool.sh
  usage: ./osclasstool.sh file.txt
  the file should conatain a list of ip addresses (one per line)
  
  result: will return the OS class of each IP address that could be pinged succesfully
  
  pingsweep.py
    Usage: python pingsweep.py addresses
    addresses: range or network to scan
    example: 10.0.1.1-10.10.2.50 or 10.10.0.0/16
    
    result: will return a list of IP addresses that responded to the ping
    
  portscan.sh
    usage: ./portscan.sh addresses ports
    addresses: range or network to scan
    example: 10.0.1.1-10.10.2.50 or 10.10.0.0/16
    ports: comma seperated list
    example: 80,90,100
    
    result: will return the result of an attempt to connect to each port
   
    
  
