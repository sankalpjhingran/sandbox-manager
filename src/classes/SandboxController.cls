/**
 * Created by sankalp.jhingran on 2/10/23.
 */

public with sharing class SandboxController {
    private static final ToolingAPIClient toolingAPIClient = new ToolingAPIClient();
    private static final List<String> SANDBOX_INFO_FIELD_LIST = new List<String> {
            'id', 'ApexClassId', 'AutoActivate', 'CopyChatter', 'Description', 'HistoryDays', 'IsNonPreview',
            'IsPreRelease', 'IsPreview', 'LicenseType', 'SandboxName', 'SourceId', 'TemplateId'
    };

    @AuraEnabled(cacheable=true)
    public static String getAllSandboxes() {
        // prepare request
        String query = 'SELECT+' + String.join(SANDBOX_INFO_FIELD_LIST, ',') + '+FROM+SandboxInfo';

        // call doGet and return
        // System.debug('Tooling api query response===> ' + toolingAPIClient.listSandboxes(query));

        // Code for POC begins
        /*List<SandboxInfo> sandboxInfos = new List<SandboxInfo>();
        SandboxInfo s1 = new SandboxInfo.Builder().withSandboxName('Sandbox#1').withId('test1').build();
        SandboxInfo s2 = new SandboxInfo.Builder().withSandboxName('Sandbox#2').withId('test2').build();
        SandboxInfo s3 = new SandboxInfo.Builder().withSandboxName('Sandbox#3').withId('test3').build();
        sandboxInfos.add(s1);
        sandboxInfos.add(s2);
        sandboxInfos.add(s3);*/

        /*if(true) {
            throw new ToolingAPIClient.ToolingAPIException('Error Processing the request');
        }*/
        return JSON.serialize(toolingAPIClient.listSandboxes(query));
    }

    @AuraEnabled
    public static String createSandbox() {
        // prepare request
        String query = 'SELECT Id, Name, Body FROM ApexClass';

        // call doGet and return
        SandboxInfo si = new SandboxInfo.Builder()
                .withActivationUserGroupId('test')
                .build();
        toolingAPIClient.createSandbox(si);
        return '';
    }

    @AuraEnabled
    public static String scheduleSandboxCreation(SandboxInfo sandboxInfo, String cronExpression) {
        toolingAPIClient.scheduleSandboxCreate(sandboxInfo, cronExpression);
        return '';
    }

    @AuraEnabled
    public static String scheduleSandboxRefresh(String sandboxId, String cronExpression) {
        toolingAPIClient.scheduleSandboxRefresh(sandboxId, cronExpression);
        return '';
    }

}