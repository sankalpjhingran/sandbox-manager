/**
 * Created by sankalp.jhingran on 2/10/23.
 */

public with sharing class SandboxInfo {
    private final String id;
    private final String ActivationUserGroupId;
    private final String ApexClassId;
    private final Boolean AutoActivate;
    private final Boolean CopyArchivedActivities;
    private final Boolean CopyChatter;
    private final String Description;
    private final Integer HistoryDays;
    private final Boolean IsNonPreview;
    private final Boolean IsPreRelease;
    private final Boolean IsPreview;
    private final String LicenseType;
    private final String SandboxName;
    private final String SourceId;
    private final String TemplateId;

    private SandboxInfo(SandboxInfo.Builder builder) {
        this.id = builder.id;
        this.ActivationUserGroupId = builder.ActivationUserGroupId;
        this.AutoActivate = builder.AutoActivate;
        this.CopyArchivedActivities = builder.CopyArchivedActivities;
        this.CopyChatter = builder.CopyChatter;
        this.Description = builder.Description;
        this.HistoryDays = builder.HistoryDays;
        this.IsNonPreview = builder.IsNonPreview;
        this.IsPreRelease = builder.IsPreRelease;
        this.IsPreview = builder.IsPreview;
        this.LicenseType = builder.LicenseType;
        this.SandboxName = builder.SandboxName;
        this.SourceId = builder.SourceId;
        this.TemplateId = builder.TemplateId;
    }

    public SandboxInfo parse(String json) {
        return (SandboxInfo) System.JSON.deserialize(json, SandboxInfo.class);
    }

    public List<SandboxInfo> parseSandboxInfos(String json) {
        return (List<SandboxInfo>) System.JSON.deserialize(json, List<SandboxInfo>.class);
    }

    public class Builder {
        private String id;
        private String ActivationUserGroupId;
        private String ApexClassId;
        private Boolean AutoActivate;
        private Boolean CopyArchivedActivities;
        private Boolean CopyChatter;
        private String Description;
        private Integer HistoryDays;
        private Boolean IsNonPreview;
        private Boolean IsPreRelease;
        private Boolean IsPreview;
        private String LicenseType;
        private String SandboxName;
        private String SourceId;
        private String TemplateId;

        public Builder withId(String id) {
            this.id = id;
            return this;
        }

        public Builder withActivationUserGroupId(String activationUserGroupId) {
            this.ActivationUserGroupId = activationUserGroupId;
            return this;
        }

        public Builder withApexClassId(String apexClassId) {
            this.ApexClassId = apexClassId;
            return this;
        }

        public Builder withAutoActivate(Boolean autoActivate) {
            this.AutoActivate = autoActivate;
            return this;
        }

        public Builder withCopyArchivedActivities(Boolean copyArchivedActivities) {
            this.CopyArchivedActivities = copyArchivedActivities;
            return this;
        }

        public Builder withCopyChatter(Boolean copyChatter) {
            this.CopyChatter = copyChatter;
            return this;
        }

        public Builder withDescription(String description) {
            this.Description = description;
            return this;
        }

        public Builder withHistoryDays(Integer historyDays) {
            this.HistoryDays = historyDays;
            return this;
        }

        public Builder withIsNonPreview(Boolean isNonPreview) {
            this.IsNonPreview = isNonPreview;
            return this;
        }

        public Builder withIsPreRelease(Boolean isPreRelease) {
            this.IsPreRelease = isPreRelease;
            return this;
        }

        public Builder withIsPreview(Boolean isPreview) {
            this.IsPreview = isPreview;
            return this;
        }

        public Builder withLicenseType(String licenseType) {
            this.LicenseType = licenseType;
            return this;
        }

        public Builder withSandboxName(String sandboxName) {
            this.SandboxName = sandboxName;
            return this;
        }

        public Builder withSourceId(String sourceId) {
            this.SourceId = sourceId;
            return this;
        }

        public Builder withTemplateId(String templateId) {
            this.TemplateId = templateId;
            return this;
        }

        public SandboxInfo build() {
            return new SandboxInfo(this);
        }
    }
}