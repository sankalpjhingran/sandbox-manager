/**
 * Created by sankalp.jhingran on 3/5/23.
 */

import {api, LightningElement} from 'lwc';

export default class Verticalnavitem extends LightningElement {
    @api item;

    @api active;

    get navItemClass() {
        return this.active ? 'slds-nav-vertical__item slds-is-active' : 'slds-nav-vertical__item';
    }

    selectItem() {
        console.log('Item selected====> ', this.item);
        let itemSelectEvent = new CustomEvent("itemselected", { bubbles: true, composed: true, detail: this.item });
        this.dispatchEvent(itemSelectEvent);
        this.active = true;
    }
}