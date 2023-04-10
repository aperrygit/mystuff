$InactiveDays = 90
$Days = (Get-Date).Adddays(-($InactiveDays))
  

Get-ADUser -Filter {LastLogonTimeStamp -lt $Days -and enabled -eq $true} -SearchBase 'OU=Nivel,DC=nivelparts,DC=local' -Properties LastLogonTimeStamp |
  
select-object Name,@{Name="Date"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('MM-dd-yyyy')}} | export-csv C:\inactive_Users.csv -notypeinformation