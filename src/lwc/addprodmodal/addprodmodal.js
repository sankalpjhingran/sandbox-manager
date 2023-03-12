/**
 * Created by sankalp.jhingran on 2/26/23.
 */

import {api, track} from 'lwc';
import LightningModal from 'lightning/modal';
import validateProdOrg from '@salesforce/apex/SandboxController.validateProdOrg';
import addProductionOrg from '@salesforce/apex/SandboxController.addProductionOrg';
import updateProductionOrg from '@salesforce/apex/SandboxController.updateProductionOrg';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class Addprodmodal extends LightningModal {
    @api productionOrg = {
        name: '',
        username: '',
        password: '',
        securityToken: ''
    };

    @api purpose;

    handleChange(event) {
        console.log(event.target.name, event.target.value);
        const { name, value } = event.target;
        this.productionOrg = { ...this.productionOrg, [name]: value };
    }

    isInputValid() {
        return this.productionOrg.name && this.productionOrg.username && this.productionOrg.password
    }

    handleValidate() {
        console.log('this.productionOrg=====> ', JSON.stringify(this.productionOrg));
        if(!this.isInputValid()) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Invalid input, please provide values for required fields',
                    variant: 'error'
                }),
            );
            return;
        }

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
        if(!this.isInputValid()) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Invalid input',
                    variant: 'error'
                }),
            );
            return;
        }

        if(this.purpose === 'new') {
            this.handleSaveNew();
        } else if(this.purpose === 'edit') {
            this.handleSaveEdit();
        }
    }

    handleSaveNew() {
        if(!this.isInputValid()) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Invalid input',
                    variant: 'error'
                }),
            );
            return;
        }

        let { name, username, password, securityToken } = this.productionOrg;

        addProductionOrg( { name: name, username: username, password: password, securityToken: securityToken })
            .then(data => {
                console.log(data);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Successfully added production org!',
                        variant: 'success'
                    }),
                );
                this.close();
            })
            .catch(error => {
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error adding Production Org: ' + this.error.body.message,
                        variant: 'error'
                    }),
                );
            })
        console.log('this.productionOrg=====> ', JSON.stringify(this.productionOrg));
    }

    handleSaveEdit() {
        if(!this.isInputValid()) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Invalid input',
                    variant: 'error'
                }),
            );
            return;
        }

        let { name, username, password, securityToken } = this.productionOrg;

        updateProductionOrg( { name: name, username: username, password: password, securityToken: securityToken })
            .then(data => {
                console.log(data);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Successfully updated production org!',
                        variant: 'success'
                    }),
                );
                this.close();
            })
            .catch(error => {
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error updating Production Org: ' + this.error.body.message,
                        variant: 'error'
                    }),
                );
            })
        console.log('this.productionOrg=====> ', JSON.stringify(this.productionOrg));
    }

    handleCancel() {
        this.close('okay');
    }
}