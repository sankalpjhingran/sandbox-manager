/**
 * Created by sankalp.jhingran on 2/24/23.
 */

public with sharing class SalesforceOAuth {
    private static final SalesforceClient sfClient = new SalesforceClient();
    private static final String BASE_URL = System.Url.getSalesforceBaseUrl().toExternalForm();

    private final String prodOrg;
    private final EnvType envType;
    private final String sessionId;
    private final String instanceUrl;
    private final String orgId;

    private SalesforceOAuth(){} // no default construction

    public SalesforceOAuth(String prodOrg, EnvType envType) {
        this.prodOrg = prodOrg;
        this.envType = envType;

        System.debug('prodOrg====> ' + prodOrg);
        ProductionOrgs__c prodOrgSetting = ProductionOrgs__c.getInstance(prodOrg);
        ProductionOrg prodOrgInstance = new ProductionOrg.Builder()
                                                    .withUsername(prodOrgSetting.Username__c)
                                                    .withPassword(prodOrgSetting.Password__c)
                                                    .withSecurityToken(prodOrgSetting.Security_Token__c)
                                                    .build();

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(authorizeOrg(prodOrgInstance).getBody());
        this.sessionId = (String) responseMap.get('access_token');
        this.instanceUrl = (String) responseMap.get('instance_url');

        List<String> orgIdURLList = ((String) responseMap.get('id')).split('/');
        this.orgId = orgIdURLList[4];
    }

    public SalesforceOAuth(ProductionOrg prodOrg) {
        System.debug('prodOrg====> ' + prodOrg);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(authorizeOrg(prodOrg).getBody());
        this.sessionId = (String) responseMap.get('access_token');
        this.instanceUrl = (String) responseMap.get('instance_url');
    }

    public HttpResponse authorizeOrg(ProductionOrg prodOrg) {
        Connected_App_Secrets__c secrets = Connected_App_Secrets__c.getOrgDefaults();

        String clientId = urlEncode(secrets.Client_Id__c);
        String clientSecret = urlEncode(secrets.Client_Secret__c);
        String username = urlEncode(prodOrg.getUsername());
        String password = urlEncode(prodOrg.getPassword());
        String body = 'grant_type=password' +
                '&client_id=' + clientId +
                '&client_secret=' + clientSecret +
                '&username=' + username +
                '&password=' + password + urlEncode(prodOrg.getSecurityToken());

        HttpResponse res = sfClient.login(envType, body);
        System.debug('Auth Response====> ' + res.getBody());

        LoginError loginError = (LoginError)JSON.deserialize(res.getBody(), LoginError.class);

        if(res.getStatusCode() != 200) {
            throw new SandboxClient.ToolingAPIException('Error authenticating org. Please check your credentials and the security token. If you have recently updated your security token, then update the token and try again: ' + loginError.error);
        }
        return res;
    }

    private String urlEncode(String toEncode) {
        return EncodingUtil.urlEncode(toEncode, 'UTF-8');
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