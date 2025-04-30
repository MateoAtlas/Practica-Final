import { NavigationMixin } from 'lightning/navigation';
import { MessageContext } from 'lightning/messageService';
import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { subscribe, publish } from 'c/pubsub';
import { updateRecord } from 'lightning/uiRecordApi';


import buscarCoches from '@salesforce/apex/BuscadorController.buscarCoches';

import buscarCochesFecha from '@salesforce/apex/BuscadorController.buscarCochesFecha';

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

    error = '';
    msg = '';
    botonBuscar = false;

    filtroError = 'move';
    divClass = 'carslist';


    // @wire (getOpp) loadConcesionario (result) {
    //     console.table(result);
    //     console.log('-----------' + this.recordId);
    // }


    connectedCallback (e) {
        console.log(this.recordId);
        getOpp ({IdOpp: this.recordId})
            .then(result => {
                this.concesionarioId = result[0].Concesionario__c;
                this.loadCars();
            })
            .catch (error => {
                console.log("connected callback");
                console.log('Err', error);
            })
    }

    loadCars () {
        buscarCochesFecha({searchTerm: this.searchTerm, IdConce: this.concesionarioId, fechaEntrega: this.fechaEntrega, fechaSalida: this.fechaSalida})
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
                const texto = result.length + ' coches cargados';
                this.msg = (this.botonBuscar) ? texto + ' - ' + this.msg : texto;
                this.error = '';
            } else {
                console.log('Error al cargar');
                this.error = 'No se encontraron coches';
                this.msg = '';
                this.cars = [];
            }
        });
    
    }

    buscarCoche (event) {
        window.clearTimeout(this.delayTimeout);
        const searchTerm = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.searchTerm = searchTerm;
            this.loadCars();
        }, 300);
    }

    agregar (event) {
        let idNewCar = event.target.dataset.id;
        if (this.fechaEntrega != '' && this.fechaSalida != '') {
            if (this.botonBuscar) {
                agregarCoches({ 
                    idCoche: idNewCar, idConce: this.concesionarioId, idOpp: this.recordId, 
                    fechaEntrega: this.fechaEntrega, fechaSalida: this.fechaSalida})
                    .then (result => {
                        this.msg = 'Coche agregado a la oportunidad con éxito';
                        this.error = '';
                        this.loadCars();
                        console.log("Publish");
                        console.log(publish);
                        publish('recordUpdated', {
                            recordId: this.recordId,   // ID de la opp
                            tipo: 'opportunity'            // Aclarar que es un opp
                        });   
                        //Id coche idNewCard
                        //Id termino result
                    })
                    .catch (error => {
                        console.log("agregando");
                        console.log('Err', error);
                    })
            } else {
                this.msg = '';
                this.error = 'Busque por fecha para poder agregar vehículos';
                this.divClass = 'carslist ' +  this.filtroError;
            }
        } else {
            this.msg = '';
            this.error = 'Seleccione una fecha para agregar un vehiculo';
            this.divClass = 'carslist ' +  this.filtroError;
        }

        setTimeout (() => {
            this.divClass = 'carslist ';
        }, 2000);
    }

    fechaSalidaChage (e) {
        this.fechaSalida = e.target.value;
    }

    fechaEntregaChange (e) {
        this.fechaEntrega = e.target.value;
    }

    searchCars(event) {
        if (this.fechaEntrega != '' && this.fechaSalida != '') {
            if (this.fechaEntrega > this.fechaSalida) {
                this.botonBuscar = true;
                this.error = '';
                console.log(this.fechaEntrega + "////" + this.fechaSalida);
                console.log('detro del if')
                buscarCocheFiltrado({ fechaSalida: this.fechaSalida, fechaEntrega: this.fechaEntrega, conceId:  this.concesionarioId})
                    .then(result => {
                        console.log(result);
                        if (result && result.length > 0) {
                            this.cars = result.map(car => {
                                const logoMatch = car.Logo_marca__c.match(/src="([^"]+)"/);
                                const logoUrl = logoMatch ? logoMatch[1] : '';
                
                                return {
                                    ...car,
                                    logoUrl: logoUrl
                                };
                            });
                            this.msg = result.length + ' coches cargados';
                            this.error = '';
                        } else {
                            this.error = 'No se han encontrado vehículos';
                            this.botonBuscar = false;
                            this.msg = '';
                            this.cars = [];
                        }
                    })
                    .catch(error => {
                        console.log(error);
                        this.cars = [];
                    });
            } else {
                this.error = 'La fecha de entrega no puede ser inferior a la de salida';
                this.divClass = 'carslist ' +  this.filtroError;
            }
        } else if (this.fechaEntrega == '' && this.fechaSalida == '') {
            this.error = 'Seleccione una fecha';
            this.divClass = 'carslist ' +  this.filtroError;
        } else if (this.fechaSalida == '') {
            this.error = 'Seleccione una fecha de salida';
            this.divClass = 'carslist ' +  this.filtroError;
        } else if (this.fechaEntrega == '' ) {
            this.error = 'Seleccione una fecha de entrega';
            this.divClass = 'carslist ' +  this.filtroError;
        } 

        setTimeout (() => {
            this.divClass = 'carslist ';
        }, 2000);
    }

    deleteFilter(event) {
        this.fechaEntrega = '';
        this.fechaSalida = '';
        this.searchTerm = '';
        this.loadCars();
        this.error = '';
        this.msg = '';
        this.botonBuscar = false;
    }

    conceChange (e) {
        this.concesionarioId = e.detail.value;
        this.loadCars();
    }
}