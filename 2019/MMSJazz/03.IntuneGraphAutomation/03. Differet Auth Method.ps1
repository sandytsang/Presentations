$scope = "https://graph.microsoft.com/.default"
$tenant = "mvp24.onmicrosoft.com"
$authority = "https://login.microsoftonline.com/$tenant/oauth2/v2.0/token"
$AppId = "c296b46c-ad3c-40a2-b041-2cd7fab7528b"
$AppSecret = 'N5nZ/7MffBM:ReDd@=Bu6DphJPuuklc9'

#Header
$authHeader = @{
	'Content-Type'  = 'application/x-www-form-urlencoded'
}

#Authendication body
$authBody = @{
    'client_id'=$AppId        
    'grant_type'="client_credentials"
    'client_secret'="$AppSecret"
    'scope'= $scope 
}

#Auth to API to get Token
$Request = Invoke-RestMethod -Headers $authHeader -Uri $authority -Body $authBody -Method POST -Verbose
$AuthToken = @{
    Authorization = "Bearer $($Request.access_token)"
}

#User token get windows autopilot devices list
$url = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities"
Invoke-RestMethod -Method Get -Uri $url -Headers $AuthToken


