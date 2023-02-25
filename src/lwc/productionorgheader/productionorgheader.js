/**
 * Created by sankalp.jhingran on 2/24/23.
 */

import {api, LightningElement, wire} from 'lwc';
import createSandbox from '@salesforce/apex/SandboxController.createSandbox';

export default class Productionorgheader extends LightningElement {
    @api org;
    @api prodOrgInfo;

    createSandbox() {
        createSandbox({ prodOrg : this.org })
            .then(data => {
                console.log(data);
            })
            .catch(error => {
                console.log(error);
            })
    }
}