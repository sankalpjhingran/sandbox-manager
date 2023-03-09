/**
 * Created by sankalp.jhingran on 2/26/23.
 */

import {api, LightningElement, wire} from 'lwc';
import getAllProductionOrgs from '@salesforce/apex/SandboxController.getAllProductionOrgs';
import MyModal from 'c/addprodmodal';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
export default class Admin extends LightningElement {
    @api prodOrgs;

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

    async handleClick() {
        const result = await MyModal.open({
            // `label` is not included here in this example.
            // it is set on lightning-modal-header instead
            size: 'small',
            description: 'Accessible description of modal\'s purpose',
            content: 'Passed into content api',
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }
}