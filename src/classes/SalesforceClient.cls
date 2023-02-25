/**
 * Created by sankalp.jhingran on 2/10/23.
 */

public with sharing class SalesforceClient {

    public HttpResponse login(EnvType type, String body) {
        String endpoint = 'https://login.salesforce.com/services/oauth2/token';
        if(type == EnvType.SANDBOX) {
            endpoint = 'https://test.salesforce.com/services/oauth2/token';
        }
        return doCallWithBody('POST', endpoint, body, null);
    }

    public HttpResponse doQuery(String endpoint, SalesforceOAuth authHelper) {
        return doCallWithoutBody('GET', endpoint, authHelper);
    }

    public HttpResponse doGet(String endpoint, SalesforceOAuth authHelper) {
        return doCallWithoutBody('GET', endpoint, authHelper);
    }

    public HttpResponse doPost(String endpoint, String body, SalesforceOAuth authHelper) {
        return doCallWithBody('POST', endpoint, body, authHelper);
    }

    public HttpResponse doPatch(String endpoint, String body, SalesforceOAuth authHelper) {
        return doCallWithBody('PATCH', endpoint, body, authHelper);
    }

    public HttpResponse doDelete(String endpoint, SalesforceOAuth authHelper) {
        return doCallWithoutBody('DELETE', endpoint, authHelper);
    }

    private HttpResponse doCallWithBodyAndHeaders(String method, String endpoint, String body, Map<String, String> headers, SalesforceOAuth authHelper) {
        return doCall(method, endpoint, body, headers, authHelper);
    }

    private HttpResponse doCallWithBody(String method, String endpoint, String body, SalesforceOAuth authHelper) {
        return doCall(method, endpoint, body, null, authHelper);
    }

    private HttpResponse doCallWithoutBody(String method, String endpoint, SalesforceOAuth authHelper) {
        return doCall(method, endpoint, null, null, authHelper);
    }

    private HttpResponse doCall(String method, String endpoint, String body, Map<String, String> headers, SalesforceOAuth authHelper) {
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(endpoint);

        // only set body if provided
        if(body != null) {
            req.setBody(body);
        }
        // string username = '{!$Credential.AuthorizationMethod}';
        // System.debug(username);
        if(authHelper != null) {
            req.setHeader('Authorization', 'Bearer ' + authHelper.getSessionId());
        }
        return doCall(req);
    }

    private HttpResponse doCall(HttpRequest req) {
        Http h = new Http();
        return h.send(req);
    }
}