/**
 * Created by sankalp.jhingran on 2/20/23.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getAllSandboxes from '@salesforce/apex/SandboxController.getAllSandboxes';
import LightningAlert from "lightning/alert";
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class SandboxList extends LightningElement {
    @track sandboxes;
    @track error;
    loadingData = true;

    @wire(getAllSandboxes)
    wiredAllSandboxes({ error, data }) {
        if (data) {
            this.sandboxes = JSON.parse(data);;
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
        this.loadingData = false;
    }

    handleClick() {
        console.log('Sandbox details clicked====>');
    }
}