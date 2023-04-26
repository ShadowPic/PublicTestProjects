import http from 'k6/http';
import { check,fail } from 'k6';

/**
 * Authenticate using OAuth against Azure Active Directory  **note: fails iteration if bearer token was not returned in server response
 * @function
 * @param  {string} tenantId - Directory ID in Azure
 * @param  {string} clientId - Application ID in Azure
 * @param  {string} clientSecret - Can be obtained from https://docs.microsoft.com/en-us/azure/storage/common/storage-auth-aad-app#create-a-client-secret
 * @param  {string} scope - Space-separated list of scopes (permissions) that are already given consent to by admin
 * @param  {string} grantType - this is the type of authorization such as client_credentials
 * @param  {string} resource - resource ID (as string), to generate the required access token for
 */
export function authenticateUsingAzure(tenantId, clientId, clientSecret, scope, grantType, resource) {
    const url = `https://login.microsoftonline.com/${tenantId}/oauth2/token`;
    const requestBody = {
        client_id: clientId,
        client_secret: clientSecret,
        scope: scope,
        grant_type: grantType,
        resource: resource
    };
    
    const response = http.post(url, requestBody);

    let isValidBearer = false;

    //check if authentication has occured by doing a basic sanity check for a properly formed response bearer token
    if (response.status == 200) {
        isValidBearer = check(response, {
            "authenticateUsingAzure-Successful-http-200": (r) => r.status == 200,
            "authenticateUsingAzure-BearerToken-IsInResponse": (r) =>
                (r.json('access_token').length >= 500) &&
                (r.json('token_type').startsWith('Bearer')) &&
                (r.json('resource').startsWith(resource))
        });
        console.debug(`1-isValidBearer=${isValidBearer}`)

        //if a bad bearer token, fail the iteration
        if (!isValidBearer) {
            const errInvalidBearer = 'Catastrophic Failure: authenticateUsingAzure-BearerToken returned HTTP STATUS 200 , but it does not contain a valid bearer token response. Script cannot continue - Aborting iteration'
            console.error(errInvalidBearer)
            fail(errInvalidBearer)
        }
    }
    //we got an http status code that was not 200, something failed
    else if (response.status != 200) {
        console.debug(`2-isValidBearer=${isValidBearer}`)
        const errHttpStatus = `Catastrophic Failure: authenticateUsingAzure-BearerToken has returned an HTTP STATUS=${response.status} - Aborting iteration - Response.Body=${response.body}`
        console.error(errHttpStatus)
        fail(errHttpStatus);
    }
    console.debug(`authenticateUsingAzure-access_token=${response.json('access_token')}`);

    return response.json();
}