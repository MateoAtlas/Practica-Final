import { NavigationMixin } from 'lightning/navigation';
import { publish, MessageContext } from 'lightning/messageService';
import { LightningElement, wire } from 'lwc';

import buscarCoches from '@salesforce/apex/BuscadorController.buscarCoches';



export default class Buscador extends NavigationMixin(LightningElement) {
    searchTerm = '';
    cars;
    @wire(MessageContext) messageContext;

	@wire(buscarCoches, {searchTerm: '$searchTerm'}) loadCars(result) {
    this.cars = result;
    if (result.data) {
        const message = {
        cars: result.data
        };
        //publish(this.messageContext, BEAR_LIST_UPDATE_MESSAGE, message);
    }
    }
    buscarCoche (event) {
        // Debouncing this method: do not update the reactive property as
        // long as this function is being called within a delay of 300 ms.
        // This is to avoid a very large number of Apex method calls.
        window.clearTimeout(this.delayTimeout);
        const searchTerm = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.searchTerm = searchTerm;
        }, 300);
    }
    get hasResults() {
        return (this.cars.data.length > 0);
    }
    handleCarView(event) {
        // Get bear record id from bearview event
        const carId = event.detail;
        // Navigate to bear record page
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: carId,
                objectApiName: 'Vehiculo__c',
                actionName: 'view',
            },
        });
    }
}