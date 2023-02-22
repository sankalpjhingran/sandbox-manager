/**
 * Created by sankalp.jhingran on 2/20/23.
 */

public with sharing class SandboxProcess {
    private final Attributes attributes;
    private final String ActivatedById;
    private final Datetime ActivatedDate;
    private final String ApexClassId;
    private final Boolean AutoActivate;
    private final Boolean CopyArchivedActivities;
    private final Boolean CopyChatter;
    private final Integer CopyProgress;
    private final String Description;
    private final Datetime EndDate;
    private final Integer HistoryDays;
    private final LicenseType LicenseType;
    private final String RefreshAction;
    private final String SandboxInfoId;
    private final String SandboxName;
    private final String SandboxOrganization;
    private final String SourceId;
    private final Datetime StartDate;
    private final String Status;
    private final String TemplateId;

    public SandboxProcess parse(String json){
        return (SandboxProcess) System.JSON.deserialize(json, SandboxProcess.class);
    }

    public List<SandboxProcess> parseSandboxProcesses(String json){
        return (List<SandboxProcess>) System.JSON.deserialize(json, List<SandboxProcess>.class);
    }

    private with sharing class Attributes {
        private final String type;
        private final String url;
    }
}