/**
 * Created by sankalp.jhingran on 3/19/23.
 */

import {api, LightningElement} from 'lwc';
import LightningModal from 'lightning/modal';
import addConnectedAppDetails from '@salesforce/apex/SandboxController.addConnectedAppDetails';
import {ShowToastEvent} from "lightning/platformShowToastEvent";


export default class Connectedappmodal extends LightningModal {
    @api
    connectedAppDetails = {
        clientId: '',
        clientSecret: ''
    }

    @api purpose;

    handleChange(event) {
        console.log(event.target.name, event.target.value);
        const { name, value } = event.target;
        this.connectedAppDetails = { ...this.connectedAppDetails, [name]: value };
    }

    async handleSave() {
        console.log('Save clicked...', JSON.stringify(this.connectedAppDetails));
        console.log('clientId===> ', this.connectedAppDetails.clientId);
        console.log('clientSecret===> ', this.connectedAppDetails.clientSecret);

        await addConnectedAppDetails({ clientId: this.connectedAppDetails.clientId, clientSecret: this.connectedAppDetails.clientSecret })
            .then(result => {
                if(result === true) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Successfully added Connected App details!',
                            variant: 'success'
                        }),
                    );
                }
            })
            .catch(err => {
                console.log(err);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error: ' + err.message,
                        variant: 'error'
                    }),
                );
            })
    }

    handleCancel() {
        console.log('Cancel clicked...');
        this.disableClose = false;
        this.close();
    }
}