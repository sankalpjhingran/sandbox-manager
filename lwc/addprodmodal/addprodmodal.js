/**
 * Created by sankalp.jhingran on 2/26/23.
 */

import LightningModal from 'lightning/modal';

export default class Addprodmodal extends LightningModal {
    @api content;

    handleOkay() {
        this.close('okay');
    }
}