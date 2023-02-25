/**
 * Created by sankalp.jhingran on 2/10/23.
 */

public with sharing class SandboxController {
    private static final List<String> SANDBOX_INFO_FIELD_LIST = new List<String> {
            'id', 'ApexClassId', 'AutoActivate', 'CopyChatter', 'Description', 'HistoryDays', 'IsNonPreview',
            'IsPreRelease', 'IsPreview', 'LicenseType', 'SandboxName', 'SourceId', 'TemplateId'
    };

    @AuraEnabled(Cacheable=true)
    public static List<String> getAllProductionOrgs() {
        Map<String, ProductionOrgs__c> prodOrgs = ProductionOrgs__c.getAll();
        List<String> orgNames = new List<String>();
        orgNames.addAll(prodOrgs.keySet());
        return orgNames;
    }

    @AuraEnabled(Cacheable=true)
    public static String getAllSandboxes(String prodOrg) {
        // prepare request
        String query = 'SELECT+' + String.join(SANDBOX_INFO_FIELD_LIST, ',') + '+FROM+SandboxInfo';

        SFAuthHelper authHelper = new SFAuthHelper(prodOrg, EnvType.PROD);
        System.debug('authHelper====> ' + authHelper.getOrgId());
        SandboxClient sandboxClient = new SandboxClient(authHelper);
        return JSON.serialize(sandboxClient.listSandboxes(query));
    }

    @AuraEnabled
    public static String getProdOrgDetails(String prodOrg) {
        SFAuthHelper authHelper = new SFAuthHelper(prodOrg, EnvType.PROD);
        String query = 'SELECT+Id,Name,OrganizationType,IsSandbox,InstanceName+FROM+Organization';
        SandboxClient sandboxClient = new SandboxClient(authHelper);
        return JSON.serialize(sandboxClient.getProdDetail(query));
    }

    @AuraEnabled
    public static String createSandbox(String prodOrg) {
        SFAuthHelper authHelper = new SFAuthHelper(prodOrg, EnvType.PROD);
        SandboxClient toolingAPIClient = new SandboxClient(authHelper);



        // call doGet and return
        SandboxInfo si = new SandboxInfo.Builder()
                .withActivationUserGroupId('test')
                .build();
        toolingAPIClient.createSandbox(si);
        return '';
    }

    @AuraEnabled
    public static String scheduleSandboxCreation(String prodOrg, SandboxInfo sandboxInfo, String cronExpression) {
        SFAuthHelper authHelper = new SFAuthHelper(prodOrg, EnvType.PROD);
        SandboxClient sandboxClient = new SandboxClient(authHelper);
        sandboxClient.scheduleSandboxCreate(sandboxInfo, cronExpression);
        return '';
    }

    @AuraEnabled
    public static String scheduleSandboxRefresh(String prodOrg, String sandboxId, String cronExpression) {
        SFAuthHelper authHelper = new SFAuthHelper(prodOrg, EnvType.PROD);
        SandboxClient sandboxClient = new SandboxClient(authHelper);
        sandboxClient.scheduleSandboxRefresh(sandboxId, cronExpression);
        return '';
    }

}