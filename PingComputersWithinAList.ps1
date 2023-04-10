$computers = Get-Content -Path "C:\Users\apadmin\Documents\CommputerIPSV3_12_30_22.txt"
 foreach ($computer in $computers)
     {
     $ip = $computer
     if (Test-Connection  $ip -Count 1 -ErrorAction SilentlyContinue){
         Write-Host "$ip is up"
      
     }
     }