/**
 * Created by sankalp.jhingran on 2/10/23.
 */

public with sharing class ToolingAPIClient {
    private static final SalesforceClient sfClient = new SalesforceClient();
    private static final String BASE_URL = System.Url.getSalesforceBaseUrl().toExternalForm();

    public void login(String userName, String password, EnvType envType) {
        String soapLoginBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com">' +
        '<soapenv:Header>' +
        '</soapenv:Header>' +
        '<soapenv:Body>' +
        '<urn:login>' +
        '<urn:username>' + userName + '</urn:username>' +
        '<urn:password>' +  password + '</urn:password>' +
        '</urn:login>' +
        '</soapenv:Body>' +
        '</soapenv:Envelope>';

        sfClient.login(envType, soapLoginBody);
    }

    /*public static void authenticate() {
        String endPoint = 'https://login.salesforce.com/services/oauth2/token';
        String grantType = 'authorization_code';
        String clientId = '3MVG9ux34Ig8G5er7letpP9jqyAeLV1YIgcK2NIcyC1RFLrfTLAX_MGBZqH_y04zExRiNXs_OxoT9SbSGqdkt';
        String clientSecret = '0E74B5FC6181DA1BFEB2A640EED7D5FD2662328B719D3522527626B8B062C4EB';
        String redirectUri = 'https://login.salesforce.com/services/oauth2/success';
        String code = '<authorization_code>';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setBody('grant_type=' + grantType + '&client_id=' + clientId + '&client_secret=' + clientSecret + '&redirect_uri=' + redirectUri + '&code=' + code);
        HttpResponse response = http.send(request);

        Map<String, Object> authResult = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String accessToken = (String) authResult.get('access_token');
        String instanceUrl = (String) authResult.get('instance_url');
        String refreshToken = (String) authResult.get('refresh_token');
    }*/

    public List<SandboxInfo> listSandboxes(String query) {
        String endpoint = 'callout:This_Org_Named/services/data/v57.0/tooling/query?q=';
        HttpResponse res = sfClient.doQuery(endpoint+query);

        if(res.getStatusCode() != 200) {
            System.debug(res.getBody());
            throw new ToolingAPIException('Error getting list of all sandboxes');
        }
        Map<String, Object> jsonParse = (Map<String, Object>)Json.deserializeUntyped(res.getbody());
        return (List<SandboxInfo>) JSON.deserialize(JSON.serialize(jsonParse.get('records')), List<SandboxInfo>.class);
    }

    public void createSandbox(SandboxInfo sandboxInfo) {
        String endpoint = BASE_URL + '/services/data/v56.0/tooling/sobjects/SandboxInfo';
        SandboxInfo si = new SandboxInfo.Builder()
                                      .withActivationUserGroupId('test')
                                      .build();
        HttpResponse res = sfClient.doPost(endpoint, JSON.serialize(si, true));
    }

    public void refreshSandbox(String sandboxId) {
        List<SandboxInfo> sandboxes = new List<SandboxInfo>();
        sandboxes = listSandboxes('SELECT Id, SandboxName FROM SandboxInfo WHERE id=: ' + sandboxId);

        if(!sandboxes.isEmpty()) {
            String endpoint = BASE_URL + '/services/data/v56.0/tooling/sobjects/SandboxInfo';
            HttpResponse res = sfClient.doPatch(endpoint, JSON.serialize(sandboxes[0], true));
        }
    }

    public void scheduleSandboxCreate(SandboxInfo sandboxInfo, String scheduleExpression) {
        SandboxSchedular p = new SandboxSchedular('New-Sandbox', sandboxInfo, SandboxAction.CREATE);
        System.schedule('One Time Pro', scheduleExpression, p);
    }

    public void scheduleSandboxRefresh(String sandboxId, String refreshCadence) {
        SandboxSchedular p = new SandboxSchedular(sandboxId, null, SandboxAction.REFRESH);
        System.schedule('One Time Pro', refreshCadence, p);
    }

    public void activateSandbox(String sandboxId) {
        HttpResponse res = sfClient.doPost('', '');
    }

    public void deleteSandbox(String sandboxId) {
        HttpResponse res = sfClient.doPost('', '');
    }

    public void checkSandboxProgress(String sandboxId) {
        String query = 'SELECT Id, Status FROM SandboxProcess WHERE SandboxInfoId: '  + sandboxId;
        String endpoint = BASE_URL + '/services/data/v56.0/tooling/query?q=';
        HttpResponse res = sfClient.doQuery(endpoint+query);
    }

    public class ToolingAPIException extends Exception{}
}