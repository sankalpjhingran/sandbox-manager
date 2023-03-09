/**
 * Created by sankalp.jhingran on 2/20/23.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getAllProductionOrgs from '@salesforce/apex/SandboxController.getAllProductionOrgs';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class Home extends LightningElement {
    @api prodOrgs = [];
    @track error;
    @api selectedProd;

    @track initialRender = false;

    renderedCallback() {
        if(!this.initialRender) {
            this.selectedProd = { name: 'Home' };
        }
        this.initialRender = true;
    }

    @wire(getAllProductionOrgs)
    wiredAllProdOrgs({ error, data }) {
        if (data) {
            let orgs = [];

            let existingOrgs = JSON.parse(data);
            console.log('prod orgs====> ', existingOrgs);
            orgs.push( { name: 'Home' } );
            for (let org in existingOrgs) {
                orgs.push(existingOrgs[org]);
            }
            this.prodOrgs = orgs;
            console.log('this.prodOrgs====> ', JSON.stringify(this.prodOrgs));
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

    @api
    showProd(event) {
        console.log('showProd clicked====>', event.detail);
        this.selectedProd = event.detail;

        if(!this.isHome) {
            this.template.querySelector('c-productionorg').getProdAndAllSandboxes();
        }
    }

    get isHome() {
        return (this.selectedProd === 'Home');
    }
}