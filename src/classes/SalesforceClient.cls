/**
 * Created by sankalp.jhingran on 2/10/23.
 */

public with sharing class SalesforceClient {

    public HttpResponse login(EnvType type, String body) {
        String endpoint = 'https://login.salesforce.com';
        if(type == EnvType.SANDBOX) {
            endpoint = 'https://test.salesforce.com';
        }
        return doCallWithBodyAndHeaders('POST', endpoint, body, new Map<String, String> { 'Content-Type' => 'application/json', 'SOAPAction' => 'login'});
    }

    public HttpResponse doQuery(String endpoint) {
        return doCallWithoutBody('GET', endpoint);
    }

    public HttpResponse doGet(String endpoint) {
        return doCallWithoutBody('GET', endpoint);
    }

    public HttpResponse doPost(String endpoint, String body) {
        return doCallWithBody('POST', endpoint, body);
    }

    public HttpResponse doPatch(String endpoint, String body) {
        return doCallWithBody('PATCH', endpoint, body);
    }

    public HttpResponse doDelete(String endpoint) {
        return doCallWithoutBody('DELETE', endpoint);
    }

    private HttpResponse doCallWithBodyAndHeaders(String method, String endpoint, String body, Map<String, String> headers) {
        return doCall(method, endpoint, body, headers);
    }

    private HttpResponse doCallWithBody(String method, String endpoint, String body) {
        return doCall(method, endpoint, body, null);
    }

    private HttpResponse doCallWithoutBody(String method, String endpoint) {
        return doCall(method, endpoint, null, null);
    }

    private HttpResponse doCall(String method, String endpoint, String body, Map<String, String> headers) {
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(endpoint);

        // only set body if provided
        if(body != null) {
            req.setBody(body);
        }
        // string username = '{!$Credential.AuthorizationMethod}';
        // System.debug(username);
        // req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());

        return doCall(req);
    }

    private HttpResponse doCall(HttpRequest req) {
        Http h = new Http();
        return h.send(req);
    }
}