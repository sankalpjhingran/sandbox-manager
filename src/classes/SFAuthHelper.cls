/**
 * Created by sankalp.jhingran on 2/24/23.
 */

public with sharing class SFAuthHelper {
    private static final SalesforceClient sfClient = new SalesforceClient();
    private static final String BASE_URL = System.Url.getSalesforceBaseUrl().toExternalForm();

    private final String prodOrg;
    private final EnvType envType;
    private final String sessionId;
    private final String instanceUrl;
    private final String orgId;

    private SFAuthHelper(){} // no default construction

    public SFAuthHelper(String prodOrg, EnvType envType) {
        this.prodOrg = prodOrg;
        this.envType = envType;

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(authorizeOrg().getBody());
        this.sessionId = (String) responseMap.get('access_token');
        this.instanceUrl = (String) responseMap.get('instance_url');

        List<String> orgIdURLList = ((String) responseMap.get('id')).split('/');
        this.orgId = orgIdURLList[4];
    }

    public HttpResponse authorizeOrg() {
        ProductionOrgs__c prodOrgSetting = ProductionOrgs__c.getInstance(prodOrg);
        Connected_App_Secrets__c secrets = Connected_App_Secrets__c.getOrgDefaults();

        String body = 'grant_type=password' +
                '&client_id=' + EncodingUtil.urlEncode(secrets.Client_Id__c, 'UTF-8') + '&client_secret=' + EncodingUtil.urlEncode(secrets.Client_Secret__c, 'UTF-8') +
                '&username=' + EncodingUtil.urlEncode(prodOrgSetting.get('username__c').toString(), 'UTF-8') + '&password=' + EncodingUtil.urlEncode(prodOrgSetting.get('password__c').toString(), 'UTF-8');

        HttpResponse res = sfClient.login(envType, body);
        System.debug('Auth Response====> ' + res.getBody());

        LoginError loginError = (LoginError)JSON.deserialize(res.getBody(), LoginError.class);

        if(res.getStatusCode() != 200) {
            throw new SandboxClient.ToolingAPIException('Error authenticating ' + prodOrg + ' Org: ' + loginError.error);
        }
        return res;
    }

    public class LoginError{
        private final String error;
        private final String error_description;
    }

    public String getInstanceUrl() {
        return this.instanceUrl;
    }

    public String getOrgId() {
        return this.orgId;
    }

    public String getSessionId() {
        return this.sessionId;
    }
}