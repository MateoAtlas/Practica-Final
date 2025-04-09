import { LightningElement } from 'lwc';

export default class Countdown extends LightningElement {
    countdown;

    connectedCallback() {
        const targetDate = new Date();
        targetDate.setDate(targetDate.getDate() + 5);

        this.updateCountdown(targetDate);
        setInterval(() => {
            this.updateCountdown(targetDate);
        }, 1000);
    }

    // Función para actualizar la cuenta atrás
    updateCountdown(targetDate) {
        const now = new Date();
        const timeRemaining = targetDate - now;

        if (timeRemaining <= 0) {
            this.countdown = "¡El tiempo ha expirado!";
        } else {
            const days = Math.floor(timeRemaining / (1000 * 60 * 60 * 24));
            const hours = Math.floor((timeRemaining % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((timeRemaining % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((timeRemaining % (1000 * 60)) / 1000);

            this.countdown = `${days} días, ${hours} horas, ${minutes} minutos, ${seconds} segundos`;
        }
    }
}
