#Set executionPolicy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

#Install or update Microsoft Graph Intune module
$GraphModule = Get-Module -Name "Microsoft.Graph.Intune" -ListAvailable 
if ($GraphModule)
{
    Update-Module -Name WindowsAutoPilotIntune	
}
else {
    Install-PackageProvider -Name NuGet -Force
	Install-Module Microsoft.Graph.Intune -AllowClobber -Force
}

#Install or update WindowsAutoPilot module
$WindowsAutoPilotModule = Get-Module -Name "WindowsAutoPilotIntune" -ListAvailable
if ($WindowsAutoPilotModule)
{
    Update-Module -Name WindowsAutoPilotIntune	
}
else {
    Install-PackageProvider -Name NuGet -Force
	Install-Module Microsoft.Graph.Intune -AllowClobber -Force
}


$Serial = (Get-WmiObject -Class Win32_BIOS).SerialNumber #Get device serial number
$Tenants = @("smsboot", "mvp24") #Change these to your own tenats
$AppID = "c296b46c-ad3c-40a2-b041-2cd7fab7528b" #Change this to your own application ID
$AppSecrect = "N5nZ/7MffBM:ReDd@=Bu6DphJPuuklc9" #Change this to your application secrect

#Search imported autpilot device from multiple tenants
foreach ($Tenant in $Tenants) {
    Write-Host "checking from tenant : $Tenant" -ForegroundColor Yellow   
    Update-MSGraphEnvironment -SchemaVersion "beta" -AppId $AppID -AuthUrl "https://login.microsoftonline.com/$Tenant.onmicrosoft.com" -Quiet
    Connect-MSGraph -ClientSecret $AppSecrect -Quiet
    $url = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities?`$filter=contains(serialNumber,'$Serial')"
    $AutopilotDevices = (Invoke-MSGraphRequest -HttpMethod GET -Url $url).value
    if ($AutopilotDevices)
    {
        write-host "found device serial $Serial in tenant $Tenant" -ForegroundColor Cyan
    }
}
