import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

import linkOpp from '@salesforce/apex/setLinkOpportunity.setLink';

import changeBox from '@salesforce/apex/setLinkOpportunity.changeCheckBox';

export default class SendPdfOpportunity extends LightningElement {
    @api recordId;
    vfPageUrl = '';
    @wire(CurrentPageReference) pageRef;

    connectedCallback () {
        if (this.recordId) {
            this.vfPageUrl = `/apex/opportunityPdfPage?recordId=${this.recordId}`;
        } else {
            this.recordId = this.pageRef.state.recordId;
            this.vfPageUrl = `/apex/opportunityPdfPage?recordId=${this.recordId}`;
            console.log(this.recordId + '---- ID OPP');
        }

        const urlPdf = `https://brave-badger-q3ht3t-dev-ed--c.trailblaze.vf.force.com/apex/opportunityPdfPage?recordId=${this.recordId}`;
        const urlPago = `https://brave-badger-q3ht3t-dev-ed.trailblaze.my.site.com/Testcomm/s/payment-page?recordId=${this.recordId}`;
        linkOpp ({link: urlPdf, idOpp: this.recordId, linkPage: urlPago})
            .then (result => {
                console.log('entro');
            })
    }

    enviarPresupuesto () {
        changeBox ({idOpp: this.recordId})
        .then (result => {
            console.log('entro');
            location.reload();
        })
        .catch (er => {
            console.log('errr');
            console.log(er);
        })
    }
}