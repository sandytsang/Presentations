#Set executionPolicy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

#Install or update Microsoft Graph Intune module
$GraphModule = Get-Module -Name "Microsoft.Graph.Intune" -ListAvailable 
if ($GraphModule)
{
    Update-Module -Name Microsoft.Graph.Intune	
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
	Install-Module WindowsAutoPilotIntune -AllowClobber -Force
}

#Get device serial number
$Serial = (Get-WmiObject -Class Win32_BIOS).SerialNumber

#Get device hardware hash		
$DeviceHardwareData = (Get-WMIObject -Namespace root/cimv2/mdm/dmmap -Class MDM_DevDetail_Ext01 -Filter "InstanceID='Ext' AND ParentID='./DevDetail'").DeviceHardwareData

$Tenent = "smsboot.onmicrosoft.com" #Change this to your tenant name
$AppID = "c296b46c-ad3c-40a2-b041-2cd7fab7528b" #Change this to your own application ID
$AppSecrect = "N5nZ/7MffBM:ReDd@=Bu6DphJPuuklc9" #Change this to your application secrect
$GroupTag = "MMSJazz" #Change this to your own GroupTag

#Update graph environment
Update-MSGraphEnvironment -SchemaVersion "beta" -AppId $AppID -AuthUrl "https://login.microsoftonline.com/$Tenant"

#Connet to Graph with client secrect
Connect-MSGraph -ClientSecret $AppSecrect

#Add device to Autopilot
Add-AutoPilotImportedDevice -serialNumber $Serial -hardwareIdentifier $DeviceHardwareData -groupTag $GroupTag