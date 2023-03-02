/**
 * Created by sankalp.jhingran on 2/26/23.
 */

import {LightningElement} from 'lwc';
import MyModal from 'c/addprodmodal';
export default class Admin extends LightningElement {
    async handleClick() {
        const result = await MyModal.open({
            // `label` is not included here in this example.
            // it is set on lightning-modal-header instead
            size: 'large',
            description: 'Accessible description of modal\'s purpose',
            content: 'Passed into content api',
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }
}