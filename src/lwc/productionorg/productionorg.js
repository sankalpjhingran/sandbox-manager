/**
 * Created by sankalp.jhingran on 2/23/23.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getAllSandboxes from '@salesforce/apex/SandboxController.getAllSandboxes';
import getProdOrgDetails from '@salesforce/apex/SandboxController.getProdOrgDetails';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class ProductionOrg extends LightningElement {
    @api prodOrg;
    @api prodOrgInfo;
    @api sandboxes;
    @track error;
    @api selectedSandbox;
    @api loadingData = false;

    @api
    getProdAndAllSandboxes() {
        this.getProdOrgInfo();
        this.showSandboxes();
    }

    getProdOrgInfo() {
        if(this.prodOrg !== 'Home') {
            this.loadingData = true;
            getProdOrgDetails({ prodOrg: this.prodOrg })
                .then(data => {
                    console.log('Sandbox====> ');
                    console.log(data);
                    this.prodOrgInfo = JSON.parse(data)[0];
                    console.log(this.prodOrgInfo);
                })
                .catch(error => {
                    this.error = error;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: this.error.body.message,
                            variant: 'error'
                        }),
                    );
                    this.loadingData = false;
                })
        }
    }

    showSandboxes() {
        if(this.prodOrg !== 'Home') {
            console.log('Sandbox details clicked====>', this.prodOrg, (this.prodOrg !== 'Home'));
            getAllSandboxes({ prodOrg: this.prodOrg })
                .then(data => {
                    console.log('data====> ' + data);
                    this.sandboxes = JSON.parse(data);
                    this.loadingData = false;
                })
                .catch(error => {
                    this.error = error;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: this.error.body.message,
                            variant: 'error'
                        }),
                    );
                    this.loadingData = false;
                });
        }
    }

    displaySandboxDetails(event) {
        console.log('sandbox details event received====> ', JSON.parse(event.detail));
        this.selectedSandbox = JSON.parse(event.detail);
        console.log(this.selectedSandbox);
    }
}