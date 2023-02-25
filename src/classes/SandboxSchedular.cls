/**
 * Created by sankalp.jhingran on 2/15/23.
 */

public with sharing class SandboxSchedular implements Schedulable {
    private final String sandboxId;
    private final SandboxAction action;
    private final SandboxInfo sandboxInfo;
    private final String prodOrg;

    private SandboxSchedular() {} // no empty construction

    public SandboxSchedular(String sandboxId, SandboxInfo sandboxInfo, SandboxAction action) {
        this.sandboxId = sandboxId;
        this.sandboxInfo = sandboxInfo;
        this.action = action;

        if(action.equals(SandboxAction.CREATE) && sandboxInfo == null) {
            throw new SandboxClient.ToolingAPIException('SandboxInfo cannot be null when CREATE action is used.');
        }

        if(action.equals(SandboxAction.REFRESH) || action.equals(SandboxAction.REMOVE)  && sandboxId == null) {
            throw new SandboxClient.ToolingAPIException('SandboxInfo cannot be null when CREATE action is used.');
        }
    }

    public void execute(SchedulableContext param1) {
        SalesforceOAuth authHelper = new SalesforceOAuth(prodOrg, EnvType.PROD);
        SandboxClient toolingAPIClient = new SandboxClient(authHelper);
        switch on action {
            when CREATE {
                toolingAPIClient.createSandbox(sandboxInfo);
            }
            when REFRESH {
                toolingAPIClient.refreshSandbox(sandboxId);
            }
            when REMOVE {
                toolingAPIClient.deleteSandbox(sandboxId);
            }
        }
    }
}