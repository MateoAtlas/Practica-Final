import { LightningElement, api } from 'lwc';

export default class AccountPdfGenerator extends LightningElement {
    @api recordId;  // Este recordId lo recibes desde la página de registro

    generatePDF() {
        // Construir la URL pasando el recordId como parámetro
        const pdfUrl = `/apex/testPdf?recordId=${this.recordId}`;

        // Usamos window.open para abrir la nueva pestaña con la URL que incluye el parámetro
        const newTab = window.open(pdfUrl, '_blank');

        if (!newTab) {
            console.error('La nueva pestaña fue bloqueada por el navegador.');
        }
    }
}
