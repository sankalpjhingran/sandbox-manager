/**
 * Created by sankalp.jhingran on 2/26/23.
 */

import {api, track} from 'lwc';
import LightningModal from 'lightning/modal';
import validateProdOrg from '@salesforce/apex/SandboxController.validateProdOrg';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class Addprodmodal extends LightningModal {
    @track productionOrg = {
        name: '',
        username: '',
        password: '',
        securityToken: ''
    };

    handleChange(event) {
        console.log(event.target.name, event.target.value);
        const { name, value } = event.target;
        this.productionOrg = { ...this.productionOrg, [name]: value };
    }

    handleValidate() {
        console.log('this.productionOrg=====> ', JSON.stringify(this.productionOrg));

        validateProdOrg({ username: this.productionOrg.username, password: this.productionOrg.password, securityToken: this.productionOrg.securityToken})
            .then(data => {
                console.log(data);
                if(data === true) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Validation success!',
                            variant: 'success'
                        }),
                    );
                }
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

    handleSave() {
        console.log('this.productionOrg=====> ', JSON.stringify(this.productionOrg));
    }

    handleCancel() {
        this.close('okay');
    }
}