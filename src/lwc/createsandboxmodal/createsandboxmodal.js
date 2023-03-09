/**
 * Created by sankalp.jhingran on 3/5/23.
 */

import {api, LightningElement, track, wire} from 'lwc';
import LightningModal from 'lightning/modal';
import createSandbox from '@salesforce/apex/SandboxController.createSandbox';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class Createsandboxmodal extends LightningModal {

    @track sandboxInfo = {
        ApexClassId: 'John',
        AutoActivate: false
    };

    handleChange(event) {
        console.log(event.target.name, event.target.value);
        const { name, value } = event.target;
        this.sandboxInfo = { ...this.sandboxInfo, [name]: value };
    }

    handleSave() {
        console.log('Ok pressed====>', this.sandboxInfo.apexClassId);
        console.log('Ok pressed====>', this.sandboxInfo.autoActivate);
        // this.createSandboxInfo();
    }

    createSandboxInfo() {
        createSandbox({ prodOrg: this.prodOrg, sandboxInfo: this.sandboxInfo })
            .then(data => {
                console.log('data====> ' + data);

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

    handleCancel() {
        console.log('Cancel pressed====>');
        this.close('okay');
    }
}