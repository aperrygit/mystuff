

If ((Get-CimInstance -ClassName CIM_OperatingSystem).Version -eq '10.0.17763') { #Server 2019
    $PatchSSU = 'windows10.0-kb5005112-x64.msu'
    $PatchMonthly = 'windows10.0-kb5020438-x64.msu'
    $PatchDirectory='Server2019Patch'
} ElseIf ((Get-CimInstance -ClassName CIM_OperatingSystem).Version -eq '10.0.14393') { #Server 2016
    $PatchSSU = 'windows10.0-kb5017396-x64.msu'
    $PatchMonthly = 'windows10.0-kb5020439-x64.msu'
    $PatchDirectory='Server2016Patch'
# } ElseIf ((Get-CimInstance -ClassName CIM_OperatingSystem).Version -eq '6.3.9600') { #Server 2012R2
#    $PatchSSU = 'windows8.1-kb4566425-x64.msu'
#    $PatchMonthly = 'windows8.1-kb4592484-x64.msu'
#    $PatchDirectory='Server2012R2Patch'
# } ElseIf ((Get-CimInstance -ClassName CIM_OperatingSystem).Version -eq '6.2.9200') { #Server 2012
#    $PatchSSU = 'windows8-rt-kb4566426-x64.msu'
#    $PatchMonthly = 'windows8-rt-kb4586834-x64.msu'
#    $PatchDirectory='Server2012Patch'
    } Else {Write-Host "This Windows version is not supported"
    End}

#Get Patch name and paths
Write-Host "Installing Patches"
$PatchPathSSU = '\\nivel-fs-cache\d$\ServerPatch\' + $PatchDirectory + '\' + $PatchSSU
$PatchPathMonthly = '\\nivel-fs-cache\d$\ServerPatch\' + $PatchDirectory + '\' + $PatchMonthly

Write-Host $PatchPathSSU
Write-Host $PatchPathMonthly

$PatchSsuKB = $PatchSSU.Split("-")[1]
$PatchMonthlyKB = $PatchMonthly.Split("-")[1]

Write-Host $PatchSsuKB
Write-Host $PatchMonthlyKB

# Install Serviceing Stack Update
$HotfixSSU = Get-Hotfix | Where-Object {$_.hotfixid -eq $PatchSsuKB}
If(!($HotfixSSU))
    {Write-Host "Installing Hotfix $PatchSsuKb"
    Try {
        #Start-Process -FilePath 'c:\windows\system32\wusa.exe' -ArgumentList ($PatchPathSsu, '/quiet', '/norestart', 'log:$env:HOMEDRIVE\Temp\Wusa-SSU.log') -Wait
        $CmdSsu = "c:\windows\system32\wusa.exe $PatchPathSSU /quiet /norestart /log:%temp%\WUSA-SSU.evtx"
        CMD /C $CmdSsu  | Out-Null
        }
    Catch {
        Write-Warning $Error[0]
        Write-Host ""
        Write-Host "Serviceing Stack Update $PatchSsuKb Failed to Install."
        }
    } Else {Write-Host "$PatchSsuKb already installed"}

# Install Montly Hotfix
$HotfixMonthly = Get-Hotfix | Where-Object {$_.hotfixid -eq $PatchMonthlyKB}
If(!($HotfixMonthly))
    {Write-Host "Installing Hotfix $PatchMonthlyKb"
    Try {
        #Start-Process -FilePath 'c:\windows\system32\wusa.exe' -ArgumentList ($PatchPathMonthly, '/quiet', '/norestart', 'log:$env:HOMEDRIVE\Temp\Wusa-Monthly.log') -Wait
        $CmdMonthly = "c:\windows\system32\wusa.exe $PatchPathMonthly /quiet /norestart /log:%temp%\WUSA-Monthly.evtx"
        CMD /C $CmdMonthly  | Out-Null
        }
    Catch {
        Write-Warning $Error[0]
        Write-Host ""
        Write-Host "Serviceing Stack Update $PatchMonthlyKb Failed to Install."
        }
    } Else {Write-Host "$PatchMonthlyKb already installed"}

Write-Host ""
Write-Host "SERVER IS RESTARTING"
Write-Host ""

#shutdown -r -f -t 21600
Restart-Computer -Force
