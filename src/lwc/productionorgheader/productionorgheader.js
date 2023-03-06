/**
 * Created by sankalp.jhingran on 2/24/23.
 */

import {api, LightningElement, wire} from 'lwc';
import createSandbox from '@salesforce/apex/SandboxController.createSandbox';
import createSandboxModal from 'c/createsandboxmodal';

export default class Productionorgheader extends LightningElement {
    @api org;
    @api prodOrgInfo;

    async openCreateSandboxModal() {
        const result = await createSandboxModal.open({
            label: 'New Sandbox',
            size: 'small',
            description: 'Accessible description of modal\'s purpose',
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }
}