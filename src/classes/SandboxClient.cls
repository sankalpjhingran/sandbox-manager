/**
 * Created by sankalp.jhingran on 2/10/23.
 */

public with sharing class SandboxClient {
    private static final SalesforceClient sfClient = new SalesforceClient();
    private static final String BASE_URL = System.Url.getSalesforceBaseUrl().toExternalForm();
    private final SalesforceOAuth authHelper;
    private SandboxClient() {}

    public SandboxClient(SalesforceOAuth authHelper) {
        this.authHelper = authHelper;
    }

    public List<Organization> getProdDetail(String query) {
        String endpoint = authHelper.getInstanceUrl()+'/services/data/v57.0/query/?q=';
        HttpResponse res = sfClient.doQuery(endpoint+query, authHelper);

        if(res.getStatusCode() != 200) {
            System.debug(res.getBody());
            throw new ToolingAPIException('Error getting prod details');
        }
        Map<String, Object> jsonParse = (Map<String, Object>)Json.deserializeUntyped(res.getbody());
        return (List<Organization>) JSON.deserialize(JSON.serialize(jsonParse.get('records')), List<Organization>.class);
    }

    public List<SandboxInfo> listSandboxes(String query) {
        String endpoint = authHelper.getInstanceUrl()+'/services/data/v57.0/tooling/query?q=';
        HttpResponse res = sfClient.doQuery(endpoint+query, authHelper);

        if(res.getStatusCode() != 200) {
            System.debug(res.getBody());
            throw new ToolingAPIException('Error getting list of all sandboxes');
        }
        Map<String, Object> jsonParse = (Map<String, Object>)Json.deserializeUntyped(res.getbody());
        return (List<SandboxInfo>) JSON.deserialize(JSON.serialize(jsonParse.get('records')), List<SandboxInfo>.class);
    }

    public void createSandbox(SandboxInfo sandboxInfo) {
        String endpoint = BASE_URL + '/services/data/v56.0/tooling/sobjects/SandboxInfo';
        HttpResponse res = sfClient.doPost(endpoint, JSON.serialize(sandboxInfo, true), authHelper);
    }

    public void refreshSandbox(String sandboxId) {
        List<SandboxInfo> sandboxes = new List<SandboxInfo>();
        sandboxes = listSandboxes('SELECT Id, SandboxName FROM SandboxInfo WHERE id=: ' + sandboxId);

        if(!sandboxes.isEmpty()) {
            String endpoint = BASE_URL + '/services/data/v56.0/tooling/sobjects/SandboxInfo';
            HttpResponse res = sfClient.doPatch(endpoint, JSON.serialize(sandboxes[0], true), authHelper);
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
        HttpResponse res = sfClient.doPost('', '', authHelper);
    }

    public void deleteSandbox(String sandboxId) {
        HttpResponse res = sfClient.doPost('', '', authHelper);
    }

    public void checkSandboxProgress(String sandboxId) {
        String query = 'SELECT Id, Status FROM SandboxProcess WHERE SandboxInfoId: '  + sandboxId;
        String endpoint = BASE_URL + '/services/data/v56.0/tooling/query?q=';
        HttpResponse res = sfClient.doQuery(endpoint+query, authHelper);
    }

    public class ToolingAPIException extends Exception{}
}