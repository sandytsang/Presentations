$Serial = (Get-WmiObject -Class Win32_BIOS).SerialNumber

#Get device hardware hash		
$DeviceHardwareData = (Get-WMIObject -Namespace root/cimv2/mdm/dmmap -Class MDM_DevDetail_Ext01 -Filter "InstanceID='Ext' AND ParentID='./DevDetail'").DeviceHardwareData

#Logic app url
$url = "https://prod-21.westeurope.logic.azure.com:443/workflows/4a1d7ef737f44f4d92d91c0224ef9ede/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=c5aCAoP1Cr"

#Send request to logic app
$Body = ConvertTo-JSON @{
    "Tenant" = "smsboot.onmicrosoft.com"
    "orderIdentifier"= "MMSDemo"
    "serialNumber" = "$Serial"
    "hardwareIdentifier"= "$DeviceHardwareData"
}

Invoke-RestMethod -uri $url -Method Post -body $Body -ContentType 'application/json'