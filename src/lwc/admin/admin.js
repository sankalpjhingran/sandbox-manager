/**
 * Created by sankalp.jhingran on 2/26/23.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getAllProductionOrgs from '@salesforce/apex/SandboxController.getAllProductionOrgs';
import deleteProdOrg from '@salesforce/apex/SandboxController.deleteProdOrg';
import MyModal from 'c/addprodmodal';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
export default class Admin extends LightningElement {
    @api prodOrgs;

    @track selectProdOrg;

    @wire(getAllProductionOrgs)
    wiredAllProdOrgs({ error, data }) {
        if (data) {
            console.log('Data===> ', JSON.parse(data));
            this.prodOrgs = JSON.parse(data);
        } else if (error) {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: this.error.body.message,
                    variant: 'error'
                }),
            );
        }
    }

    async handleNew() {
        const result = await MyModal.open({
            label: 'New Production Org',
            size: 'small',
            description: 'Accessible description of modal\'s purpose',
            purpose: 'new'
        });
    }

    async handleEdit(event) {
        console.log('handle click modal====>', JSON.stringify(event.target.value));
        const result = await MyModal.open({
            label: 'Edit Production Org',
            size: 'small',
            description: 'Accessible description of modal\'s purpose',
            productionOrg: event.target.value,
            purpose: 'edit'
        });
    }

    handleDel(event) {
        console.log('value to delete===>', JSON.stringify(event.target.value));
        deleteProdOrg({ prodOrgName: event.target.value.name })
            .then(data => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Successfully deleted Production Org!',
                        variant: 'success'
                    }),
                );
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
}