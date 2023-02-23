/**
 * Created by sankalp.jhingran on 2/22/23.
 */

public with sharing class PostInstall implements InstallHandler{
    public void onInstall(InstallContext ctx) {
        System.debug(ctx.organizationId());
        System.debug(ctx.installerId());
        System.debug(ctx.isPush());
        System.debug(ctx.isUpgrade());
        System.debug(ctx.previousVersion());

        // TODO: implement logic for
    }
}