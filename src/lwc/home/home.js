/**
 * Created by sankalp.jhingran on 2/20/23.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getAllProductionOrgs from '@salesforce/apex/SandboxController.getAllProductionOrgs';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class Home extends LightningElement {
    @track prodOrgs;
    @track error;
    @api selectedProd;

    @wire(getAllProductionOrgs)
    wiredAllProdOrgs({ error, data }) {
        console.log('wiredAllProdOrgs====>');
        if (data) {
            console.log('data====>', data);
            this.prodOrgs = data;
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

    showProd(event) {
        console.log('showProd clicked====>');
        console.log(event.detail.name);
        this.selectedProd = event.detail.name;
    }
}