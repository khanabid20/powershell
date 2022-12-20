
<#
	This script toggles the Touch Screen, also it requires to be run with Admin priviledges.
	
	Just double click to toggle it ON or OFF.

#>

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force

#$STATUS=(Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Format-Table -HideTableHeaders -Property Status)

$STATUS=(Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Select -ExpandProperty Status)

if ($STATUS -eq "OK") {
	Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Disable-PnpDevice -Confirm:$false
}
else {
	Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Enable-PnpDevice -Confirm:$false
}

Exit



#############################################
# Create a Windows shortcut with following content
#############################################

# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "C:\Users\abikhan\scripts\ToggleTouchScreen.ps1"
#       OR
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "C:\Users\abikhan\scripts\ToggleTouchScreen.ps1" -NoLogo -NonInteractive -NoProfile
#       OR
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe '& "C:\Users\abikhan\scripts\ToggleTouchScreen.ps1" -NoLogo -NonInteractive -NoProfile
#       OR
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File "C:\Users\abikhan\scripts\ToggleTouchScreen.ps1"
