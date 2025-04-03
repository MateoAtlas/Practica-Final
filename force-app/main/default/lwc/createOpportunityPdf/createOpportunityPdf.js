import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

export default class CreateOpportunityPdf extends LightningElement {
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
    }

    //Metodo para llamar desde un boton
    // crearPresupuesto() {
    //     const pdfUrl = `/apex/opportunityPdfPage?recordId=${this.recordId}`;

    //     const newTab = window.open(pdfUrl, '_blank');
    //     if (!newTab) {
    //         console.error('La nueva pestaña fue bloqueada por el navegador.');
    //     }
    // }
}