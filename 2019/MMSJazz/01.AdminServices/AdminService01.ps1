$scope = "https://ConfigMgrServiceCB/user_impersonation"
$authority = "https://login.microsoftonline.com/8cfbf3fe-35a7-482f-ab0a-32e5f5109225/oauth2/v2.0/token"
$clientId = "402daf63-7115-4a87-883e-2ad83c3143c2"

# 'myPassword' |  ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString


$secureStringText = "01000000d08c9ddf0115d1118c7a00c04fc297eb01000000fbdee6c6672ec645949f972d8f80811e00000000020000000000106600000001000020000000570466b07244fd1baf4883b557d57c2543feb5e3dff207f14b18fb509ef7d380000000000e8000000002000020000000c676f076d09c1477d8fc2641208b66c57bf60e8e4d673dc97cc65fed897098af200000001db4f981b256dd813df5c43c457d2dd1397b3337553007da87537325504259ec40000000ec1c10ffc271f6ed662fd5372c4f7d51a551d32bfacc73bc106d7fecce71b4a9bc90b59b1650d3453cd9f201b069a05f46640f52e21e67bb140b396261a95418"
$securePwd = $secureStringText | ConvertTo-SecureString 
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd)
$UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$authHeader = @{
	'Content-Type'  = 'application/x-www-form-urlencoded'
}

$authBody = @{
    'client_id'=$clientId        
    'grant_type'="password"
    'username'="cmgdeom@smsboot.com"
    'password'= $UnsecurePassword
    'scope'= $scope 
}

if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type)
{
$certCallback = @"
    using System;
    using System.Net;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;
    public class ServerCertificateValidationCallback
    {
        public static void Ignore()
        {
            if(ServicePointManager.ServerCertificateValidationCallback ==null)
            {
                ServicePointManager.ServerCertificateValidationCallback += 
                    delegate
                    (
                        Object obj, 
                        X509Certificate certificate, 
                        X509Chain chain, 
                        SslPolicyErrors errors
                    )
                    {
                        return true;
                    };
            }
        }
    }
"@
    Add-Type $certCallback
 }
[ServerCertificateValidationCallback]::Ignore()

#Auth to API to get Token
$auth = Invoke-RestMethod -Headers $authHeader -Uri $authority -Body $authBody -Method POST -Verbose 

$authHeader = @{
	'Content-Type'  = 'application/json'
	'Authorization' = "Bearer " + $auth.access_token
}

#change this to your own CMG endpoint
$url = "HTTPS://mycmg.SMSBOOT.COM/CCM_Proxy_ServerAuth/72057594037927941/AdminService/wmi/SMS_Package?`$filter=Name eq 'BIOS Update - Lenovo ThinkPad P1'" 

$Result = Invoke-RestMethod -Method Get -Uri $url -Headers $authHeader
$Result.value
