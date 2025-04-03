import { NavigationMixin } from 'lightning/navigation';
import { publish, MessageContext } from 'lightning/messageService';
import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';


import buscarCoches from '@salesforce/apex/BuscadorController.buscarCoches';

import agregarCoches from '@salesforce/apex/BuscadorController.agregarCoche';

import buscarCocheFiltrado from '@salesforce/apex/BuscadorController.buscarCoche';

import getOpp from '@salesforce/apex/BuscadorController.getOpportunity';

export default class Buscador extends NavigationMixin(LightningElement) {
    searchTerm = '';
    cars;
    concesionarioId = '';
    conceOptions = [];

    @api recordId;
    //Trigger mejorar estructura

    //FECHAS
    fechaSalida = '';
    fechaEntrega = '';


    // @wire (getOpp) loadConcesionario (result) {
    //     console.table(result);
    //     console.log('-----------' + this.recordId);
    // }


    loadData (e) {
        console.log(this.recordId);
        getOpp ({IdOpp: this.recordId})
            .then(result => {
                this.concesionarioId = result[0].Concesionario__c;
                this.loadCars();
            })
            .catch (error => {
                console.log('Err', error);
            })
    }

    loadCars () {
        buscarCoches({searchTerm: this.searchTerm, IdConce: this.concesionarioId})
        .then(result => {
            if (result && result.length > 0) {
                this.cars = result.map(car => {
                    const logoMatch = car.Logo_marca__c.match(/src="([^"]+)"/);
                    const logoUrl = logoMatch ? logoMatch[1] : '';
    
                    return {
                        ...car,
                        logoUrl: logoUrl
                    };
                });
                console.log('Cargue');
            } else {
                console.log('Error al cargar');
            }
        });
    
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
            this.loadCars();
        }, 300);
    }
    
    get hasResults() {
        return (this.cars && this.cars.length > 0);
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

    agregar (event) {
        let idNewCar = event.target.dataset.id;
        console.log(idNewCar);
        agregarCoches({ 
            idCoche: idNewCar, idConce: this.concesionarioId, idOpp: this.recordId, 
            fechaEntrega: this.fechaEntrega, fechaSalida: this.fechaSalida})
            .then (result => {
                console.log('Resultado ', result);
            })
            .catch (error => {
                console.log('Err', error);
            })
    }

    fechaSalidaChage (e) {
        this.fechaSalida = e.target.value;
    }

    fechaEntregaChange (e) {
        this.fechaEntrega = e.target.value;
    }

    searchCars(event) {
        console.log(this.fechaEntrega + "////" + this.fechaSalida);
        if (this.fechaEntrega != '' && this.fechaSalida != '') {
            console.log('detro del if')
            buscarCocheFiltrado({ fechaSalida: this.fechaSalida, fechaEntrega: this.fechaEntrega, conceId:  this.concesionarioId})
                .then(result => {
                    if (result && result.length > 0) {
                        this.cars = result.map(car => {
                            const logoMatch = car.Logo_marca__c.match(/src="([^"]+)"/);
                            const logoUrl = logoMatch ? logoMatch[1] : '';
            
                            return {
                                ...car,
                                logoUrl: logoUrl
                            };
                        });
                        console.log('Cargue');
                    } else {
                        console.log('Error al cargar');
                    }
                })
                .catch(error => {
                    console.log(error);
                    this.cars = [];
                });
        }
    }

    deleteFilter(event) {
        this.fechaEntrega = '';
        this.fechaSalida = '';
        this.searchTerm = '';
        this.loadCars();
    }

    conceChange (e) {
        this.concesionarioId = e.detail.value;
        this.loadCars();
    }
}