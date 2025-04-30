import { LightningElement, api, wire } from 'lwc';
import { subscribe } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import getAllTerms from '@salesforce/apex/ListaController.getAll';
import update from '@salesforce/apex/ListaController.updateRecord';
import deleteTerm from '@salesforce/apex/ListaController.deleteRecord';

export default class ListaDeTerminos extends LightningElement {
    @api recordId;
    vehiculos;
    isVisible = false; // Variable para controlar visibilidad del lwc

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.unsubscribe = subscribe('recordUpdated', this.handleRecordUpdated.bind(this));
    }

    handleRecordUpdated(eventData) {
        if (eventData.recordId === this.recordId && eventData.tipo === 'opportunity') {
            console.log("Hubo un cambio");
            this.loadVehiculos();
        }
    }

    // Cuando la pestaña se vuelve visible
    connectedCallback() {
        //console.log('Componente cargado');
        this.isVisible = true;
        this.loadVehiculos();
    }

    // Método para cargar términos
    loadVehiculos() {
        if (this.isVisible) {
            getAllTerms({ idOpp: this.recordId })
                .then(result => {
                    //console.log(result);
                    this.vehiculos = result;
                })
                .catch(error => {
                    console.error('Error cargando términos: ' + error);
                });
        }
    }

    // Método para actualizar la oportunidad
    updateOpp() {
        update({ idOpp: this.recordId })
            .then(result => {
                console.log('Oportunidad actualizada: ' + result);
            })
            .catch(error => {
                console.error('Error actualizando oportunidad: ' + error);
            });
    }

    // Método para eliminar un término
    deleteTermSelect(event) {
        const termSelect = event.currentTarget.dataset.termid;
        //console.log('Término seleccionado para eliminar: ' + termSelect);
        deleteTerm({ termId: termSelect })
            .then(result => {
                //console.log('Término eliminado');
                this.loadVehiculos();
                this.updateOpp();
            })
            .catch(error => {
                console.error('Error eliminando término: ' + error);
            });
    }

    // Método de limpieza cuando el componente se desconecte
    disconnectedCallback() {
        if (this.unsubscribe) {
            this.unsubscribe();
        }
    }
}
