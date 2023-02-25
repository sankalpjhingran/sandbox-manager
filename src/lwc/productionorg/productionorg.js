/**
 * Created by sankalp.jhingran on 2/23/23.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getAllSandboxes from '@salesforce/apex/SandboxController.getAllSandboxes';
import getProdOrgDetails from '@salesforce/apex/SandboxController.getProdOrgDetails';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class ProductionOrg extends LightningElement {
    @api orgName;
    @api prodOrgInfo;
    @track sandboxes;
    @track error;
    @track selectedSandbox;
    @api loadingData = false;
    @track initialRender = false;

    renderedCallback() {
        console.log('getProdAndAllSandboxes1=====>');
        if(!this.initialRender) {
            console.log('getProdAndAllSandboxes2=====>');
            this.getProdAndAllSandboxes();
            this.initialRender = true;
        }
    }

    getProdAndAllSandboxes() {
        this.getProdOrgInfo();
        this.showSandboxes();
    }

    getProdOrgInfo() {
        getProdOrgDetails({ prodOrg: this.orgName })
            .then(data => {
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
            })
    }

    showSandboxes() {
        this.loadingData = true;
        console.log('Sandbox details clicked====>');
        getAllSandboxes({ prodOrg: this.orgName })
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
            });
    }

    showSandboxDetails(event) {
        this.selectedSandbox = event.target.value;
        console.log(this.selectedSandbox);
    }
}