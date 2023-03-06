/**
 * Created by sankalp.jhingran on 3/4/23.
 */

import {api, LightningElement} from 'lwc';

export default class SandboxItem extends LightningElement {
    @api sandboxItem;

    showSandboxDetails() {
        console.log('Selected sandbox item===> ');
        console.log(this.sandboxItem);
        let sandboxEvent = new CustomEvent('sandboxselected', { bubbles: true, composed: true, detail: JSON.stringify(this.sandboxItem) });
        this.dispatchEvent(sandboxEvent);
    }
}