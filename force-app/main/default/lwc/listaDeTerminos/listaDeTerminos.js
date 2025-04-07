import { LightningElement, api } from 'lwc';

import getAllTerms from '@salesforce/apex/ListaController.getAll';

import update from '@salesforce/apex/ListaController.updateRecord';

import deleteTerm from '@salesforce/apex/ListaController.deleteRecord';


export default class ListaDeTerminos extends LightningElement {
    @api recordId;

    vehiculos;

    connectedCallback () {
        this.loadVehiculos();
        this.updateOpp();
    }

    loadVehiculos () {
        getAllTerms ({idOpp: this.recordId})
            .then (result => {
                console.log(result);
                this.vehiculos = result;
            })
            .catch (error => {
                console.log('err' + error);
            })
    }

    updateOpp () {
        update ({idOpp: this.recordId})
            .then (result => {
                console.log('TOOTAL ' + result);
            })
    }

    refresh () {
        this.loadVehiculos();
        this.updateOpp();
    }

    deleteTermSelect (event) {
        const termSelect = event.currentTarget.dataset.termid;
        console.log('estoy aquii -> ' + termSelect)
        deleteTerm ({termId: termSelect})
            .then (result => {
                console.log('Epale ');
                this.loadVehiculos();
                this.updateOpp();
            })
            .catch (err => {
                console.log('err ' + err)
            })
    }
}