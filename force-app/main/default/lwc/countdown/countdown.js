import { LightningElement, api, wire } from 'lwc';
import getFechaPagoEnviado from '@salesforce/apex/CountdownController.getFechaPagoEnviado';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Countdown extends LightningElement {
    @api recordId;
    targetDate;
    timeRemaining = '';
    error;
    intervalId;

    @wire(getFechaPagoEnviado, { opportunityId: '$recordId' })
    wiredFechaPagoEnviado({ error, data }) {
        if (data) {
            let fechaEnvio = new Date(data);
            fechaEnvio.setDate(fechaEnvio.getDate() + 5);
            this.targetDate = fechaEnvio;

            // Inicializar la cuenta atrás
            this.startCountdown();
        } else if (error) {
            this.error = error;
            this.showErrorToast();
        }
    }

    startCountdown() {
        this.intervalId = setInterval(() => {
            const now = new Date();
            const timeDiff = this.targetDate - now;
            if (timeDiff <= 0) {
                clearInterval(this.intervalId);
                this.timeRemaining = 'La cuenta atrás ha terminado.';
            } else {
                const days = Math.floor(timeDiff / (1000 * 60 * 60 * 24));
                const hours = Math.floor((timeDiff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const minutes = Math.floor((timeDiff % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((timeDiff % (1000 * 60)) / 1000);
                this.timeRemaining = `${days}d ${hours}h ${minutes}m ${seconds}s`;
            }
        }, 1000);
    }

    showErrorToast() {
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'No se pudo obtener la fecha de pago enviado.',
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
}
