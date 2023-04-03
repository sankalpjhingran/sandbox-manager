/**
 * Created by sankalp.jhingran on 2/26/23.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getAllProductionOrgs from '@salesforce/apex/SandboxController.getAllProductionOrgs';
import getRefreshedProductionOrgs from '@salesforce/apex/SandboxController.getRefreshedProductionOrgs';
import deleteProdOrg from '@salesforce/apex/SandboxController.deleteProdOrg';
import MyModal from 'c/addprodmodal';
import connectedAppModal from 'c/connectedappmodal';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';

export default class Admin extends LightningElement {
    @api prodOrgs;

    @api loading = false;

    @wire(getAllProductionOrgs)
    wiredAllProdOrgs({ error, data }) {
        this.loading = true;
        if (data) {
            console.log('Data===> ', JSON.parse(data));
            this.prodOrgs = JSON.parse(data);
            this.loading = false;
        } else if (error) {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: this.error.body.message,
                    variant: 'error'
                }),
            );
            this.loading = false;
        }
    }

    refreshProdOrgs() {
        console.log('Refreshing prod orgs====>');
        this.loading = true;
        getRefreshedProductionOrgs()
            .then(data => {
                console.log('New prod orgs1====> ', data);
                this.prodOrgs = JSON.parse(data);
                console.log('New prod orgs2====> ', this.prodOrgs);
                this.loading = false;
            })
        this.loading = false;
    }

    async handleNew() {
        const result = await MyModal.open({
            label: 'New Production Org',
            disableClose: true,
            size: 'small',
            description: 'Accessible description of modal\'s purpose',
            purpose: 'new',
            oncreatesuccess: (e) => {
                // stop further propagation of the event
                e.stopPropagation();
                // hand off to separate function to process
                // result of the event (see above in this example)
                // this.handleSelectEvent(e.detail);
                // or proxy to be handled above by dispatching
                // another custom event to pass on the event
                // this.dispatchEvent(e);
                console.log('Create successful====>');
                this.refreshProdOrgs();
            }
        });
    }

    async handleEdit(event) {
        console.log('handle click modal====>', JSON.stringify(event.target.value));
        const result = await MyModal.open({
            label: 'Edit Production Org',
            disableClose: true,
            size: 'small',
            description: 'Accessible description of modal\'s purpose',
            productionOrg: event.target.value,
            purpose: 'edit',
            onupdatesuccess: (e) => {
                // stop further propagation of the event
                e.stopPropagation();
                // hand off to separate function to process
                // result of the event (see above in this example)
                // this.handleSelectEvent(e.detail);
                // or proxy to be handled above by dispatching
                // another custom event to pass on the event
                // this.dispatchEvent(e);
                console.log('Update successful====>');
                this.refreshProdOrgs();
            }
        });
    }

    async confirmAndDelete(event) {
        let prodOrg = event.target.value.name

        const confirmResult = await LightningConfirm.open({
            message: 'Are you sure you want to delete this Production Org?',
            variant: 'header',
            label: 'Delete Production Org',
            theme: 'shade'
        });

        if(confirmResult) {
            this.handleDel(prodOrg);
        }
    }
    
    handleDel(orgName) {
        console.log('value to delete===>', orgName);
        deleteProdOrg({ prodOrgName: orgName })
            .then(data => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Successfully deleted Production Org!',
                        variant: 'success'
                    }),
                );
                this.refreshProdOrgs();
            })
            .catch(error => {
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error deleting Production Org: ' + this.error.body.message,
                        variant: 'error'
                    }),
                );
            })
    }

    async handleAddConnectedAppDetails() {
        console.log('Calling handleAddConnectedAppDetails...');
        const result = await connectedAppModal.open({
            label: 'Add Connected App Details',
            disableClose: true,
            size: 'small',
            description: 'Accessible description of modal\'s purpose',
            purpose: 'new'
        });
    }
}