# Introduction

For your application to accessfully query the FinOps Odata service you have to get the settings correct for the OAuth 2.0 authentication.  All of the examples that I found used the FinOps AAD registrations and no examples for on premise.

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

| Setting Name | Definition |
| --- | --- |
|ActiveDirectoryTenant|The server which is granting authorization|
|ActiveDirectoryResource|The resource server you want access to.|
|ActiveDirectoryClientAppId|The ID for this specific application instance|
|AzureSecret|SUPER SECRET key that validates your claim with the AD Tenant|

