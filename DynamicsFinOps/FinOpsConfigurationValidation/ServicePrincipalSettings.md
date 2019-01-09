# Introduction

For your application to accessfully query the FinOps Odata service you have to get the settings correct for the OAuth 2.0 authentication.  All of the examples that I found used the FinOps AAD registrations and no examples for on premise.

All service principle based access to finops are configured through the mi=SysAADClientTable form.  

## Settings For this Application

In the app.config for this project you will find the following settings.

| Setting Name | Definition |
| --- | --- |
|ActiveDirectoryTenant|The server which is granting authorization|
|ActiveDirectoryResource|The resource server you want access to.|
|ActiveDirectoryClientAppId|The ID for this specific application instance|
|AzureSecret|SUPER SECRET key that validates your claim with the AD Tenant|


## Setting for Azure Active Directory Registration

| Setting Name | Example |Notes|
| --- | --- | --- |
|ActiveDirectoryTenant| https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47 |This is the **actual** AD Tenant we use for Microsoft.  |
|ActiveDirectoryResource| https://IWouldNeverGiveYouTheActualName.cloudax.dynamics.com |When you start up your actual [FinOps Cloud Instance](https://docs.microsoft.com/en-us/dynamics365/unified-operations/dev-itpro/deployment/cloud-deployment-overview) it will *likely* be hosted at *.cloudax.dynamics.com.|
|ActiveDirectoryClientAppId|42D9BDE1-8029-469D-A0B6-BA0CBDC11DEC|The guid that you will get back when you [register your application](https://docs.microsoft.com/en-us/dynamics365/unified-operations/dev-itpro/data-entities/services-home-page#register-a-native-application-with-aad)|
|AzureSecret|ABunch0fCr@zyCh@r@ct3r5|When you register your service principal this will be only available once.  Copy it and protect it.|



## Settings for Active Directory Federated Services

If we use contoso.com as our example company let's assume that Contoso has deployed an [ADFS Server](https://docs.microsoft.com/en-us/windows-server/identity/active-directory-federation-services) with the ADFSServiceFQDN of fs.contoso.com.  The FQDN for the **on premise** Dynamics 365 FinOps instance will be AwesomeFinOps.subsidiary.contoso.com.

The official documentation on how to access FinOps OData on premise can be found at https://blogs.msdn.microsoft.com/axsa/2018/04/17/authenticate-with-dynamics-365-for-finance-and-operations-web-services-in-on-premise/ 


| Setting Name | Example |Notes|
| --- | --- | --- |
|ActiveDirectoryTenant| http://fs.contoso.com/adfs |You could ask our administrator or, if you have admin rights to a test environment, just go look at a user in the mi=SysUserInfoPage page.  Select a user and grab the Provider url which is also your Active Directory Tenant. |
|ActiveDirectoryResource| https://AwesomeFinOps.subsidiary.contoso.com/namespaces/AXSF |If you miss the **/namespaces/AXSF** as part of your url it will make life very difficult.  When you access an on premise Dynamics 365 instance it appends the **/namespaces/AXSF**.|
|ActiveDirectoryClientAppId|42D9BDE1-8029-469D-A0B6-BA0CBDC11DEC|The guid that you will get back when you [register your application](https://blogs.msdn.microsoft.com/axsa/2018/04/17/authenticate-with-dynamics-365-for-finance-and-operations-web-services-in-on-premise/)|
|AzureSecret| MO-tVemKqAjVLj1NdcCs3mfiWw2X3ZNyjuFe0UYg |secret is from ADFS management - same place as the client app ID|

## Debugging Resources

- How on premise Dynamics 365 Authetication works: https://blogs.msdn.microsoft.com/axsa/2018/05/10/how-authentication-works-in-dynamics-365-for-finance-and-operations-on-premises/ 
- Debugging using [PostMan](https://docs.microsoft.com/en-us/dynamics365/customer-engagement/developer/webapi/use-postman-perform-operations)