/**
 * Created by sankalp.jhingran on 2/10/23.
 */

public with sharing class SandboxController {

    private static final List<String> SANDBOX_INFO_FIELD_LIST = new List<String> {
            'id', 'ApexClassId', 'AutoActivate', 'CopyChatter', 'Description', 'HistoryDays', 'IsNonPreview',
            'IsPreRelease', 'IsPreview', 'LicenseType', 'SandboxName', 'SourceId', 'TemplateId'
    };

    // SandboxAdmin
    public static void getConnectedAppDetails() {
        MetadataService.MetadataPort service = createService();
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        MetadataService.ListMetadataQuery queryApp = new MetadataService.ListMetadataQuery();
        queryApp.type_x = 'ConnectedApp';
        queries.add(queryApp);
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        for(MetadataService.FileProperties fileProperty : fileProperties)
            System.debug(fileProperty.fullName);
    }

    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }

    @AuraEnabled
    public static Boolean validateProdOrg(String username, String password, String securityToken) {
        ProductionOrg prodOrg = new ProductionOrg.Builder()
                                            .withUsername(username)
                                            .withPassword(password)
                                            .withSecurityToken(securityToken)
                                            .build();
        try {
            SalesforceOAuth oAuth = new SalesforceOAuth(prodOrg);
            if(oAuth.getSessionId() != null) {
                return true;
            }
        }catch(Exception ex) {
            throw ex;
        }
        return false;
    }

    @AuraEnabled(Cacheable=true)
    public static String getAllProductionOrgs() {
        List<ProductionOrg> prodOrgs = new List<ProductionOrg>();
        for(ProductionOrgs__c org : ProductionOrgs__c.getAll().values()) {
            prodOrgs.add( new ProductionOrg.Builder()
                                    .withName(org.Name)
                                    .withUsername(org.Username__c)
                                    .build()
            );
        }
        return JSON.serialize(prodOrgs);
    }

    @AuraEnabled(Cacheable=true)
    public static String getAllSandboxes(String prodOrg) {
        // prepare request
        String query = 'SELECT+' + String.join(SANDBOX_INFO_FIELD_LIST, ',') + '+FROM+SandboxInfo';

        SalesforceOAuth authHelper = new SalesforceOAuth(prodOrg, EnvType.PROD);
        System.debug('authHelper====> ' + authHelper.getOrgId());
        SandboxClient sandboxClient = new SandboxClient(authHelper);
        return JSON.serialize(sandboxClient.listSandboxes(query));
    }

    @AuraEnabled
    public static String getProdOrgDetails(String prodOrg) {
        SalesforceOAuth authHelper = new SalesforceOAuth(prodOrg, EnvType.PROD);
        String query = 'SELECT+Id,Name,OrganizationType,IsSandbox,InstanceName+FROM+Organization';
        SandboxClient sandboxClient = new SandboxClient(authHelper);
        return JSON.serialize(sandboxClient.getProdDetail(query));
    }

    @AuraEnabled
    public static String createSandbox(String prodOrg, SandboxInfo sandboxInfo) {
        SalesforceOAuth authHelper = new SalesforceOAuth(prodOrg, EnvType.PROD);
        SandboxClient toolingAPIClient = new SandboxClient(authHelper);

        // call doGet and return
        toolingAPIClient.createSandbox(sandboxInfo);
        return '';
    }

    @AuraEnabled
    public static String scheduleSandboxCreation(String prodOrg, SandboxInfo sandboxInfo, String cronExpression) {
        SalesforceOAuth authHelper = new SalesforceOAuth(prodOrg, EnvType.PROD);
        SandboxClient sandboxClient = new SandboxClient(authHelper);
        sandboxClient.scheduleSandboxCreate(sandboxInfo, cronExpression);
        return '';
    }

    @AuraEnabled
    public static String scheduleSandboxRefresh(String prodOrg, String sandboxId, String cronExpression) {
        SalesforceOAuth authHelper = new SalesforceOAuth(prodOrg, EnvType.PROD);
        SandboxClient sandboxClient = new SandboxClient(authHelper);
        sandboxClient.scheduleSandboxRefresh(sandboxId, cronExpression);
        return '';
    }

}