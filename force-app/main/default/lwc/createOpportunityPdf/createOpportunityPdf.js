import { LightningElement, api } from 'lwc';

export default class CreateOpportunityPdf extends LightningElement {
    @api recordId;

    crearPresupuesto() {
        const pdfUrl = `/apex/opportunityPdfPage?recordId=${this.recordId}`;

        const newTab = window.open(pdfUrl, '_blank');
        if (!newTab) {
            console.error('La nueva pestaña fue bloqueada por el navegador.');
        }
    }
}
