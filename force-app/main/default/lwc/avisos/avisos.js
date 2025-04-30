import { LightningElement, api, wire } from 'lwc';
import { subscribe } from 'c/pubsub';
import LightningToast from 'lightning/toast';
import { CurrentPageReference } from 'lightning/navigation';
import loadIdVehiculos from '@salesforce/apex/getIdCarsOpp.getIds';
import getVehiculosBloqueadosPorOtrasOpp from '@salesforce/apex/getIdCarsOpp.getVehiculosBloqueadosPorOtrasOpp';
import deleteTerms from '@salesforce/apex/getIdCarsOpp.deleteTerms';


export default class Avisos extends LightningElement {
    @api recordId;
    msg = '';
    vehiculosOppId = [];
    unsubscribe;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.unsubscribe = subscribe('recordUpdated', this.handleRecordUpdated.bind(this));
    }

    connectedCallback() {
        this.verificarVehiculosReservadosPorOtros();
    }

    disconnectedCallback() {
        if (this.unsubscribe) {
            this.unsubscribe();
        }
    }

    handleRecordUpdated(eventData) {
        if (eventData.recordId === this.recordId && eventData.tipo === 'opportunity') {
            this.verificarVehiculosReservadosPorOtros();
        } else if (eventData.tipo === 'termino') {
            this.verificarVehiculosReservadosPorOtros();
        }
    }

    verificarVehiculosReservadosPorOtros() {
      Promise.all([
          loadIdVehiculos({ idOpp: this.recordId }),
          getVehiculosBloqueadosPorOtrasOpp({ idOpp: this.recordId })
      ])
      .then(([misVehiculos, reservadosOtros]) => {
        this.vehiculosOppId = misVehiculos;

        function fechasSolapan(f1Inicio, f1Fin, f2Inicio, f2Fin) {
            return f1Inicio <= f2Fin && f1Fin >= f2Inicio;
        }
        
        const idsReservados = reservadosOtros.map(item => item.vehiculoId);
        
        // Filtrar coincidencias de vehículos
        const coincidencias = misVehiculos.filter(v => {
            return reservadosOtros.some(bloq => {
                return bloq.vehiculoId === v.vehiculoId && 
                       fechasSolapan(
                         v.fechaSalida,    // Fecha de salida del vehículo actual
                         v.fechaEntrega,   // Fecha de entrega del vehículo actual
                         bloq.fechaSalida, // Fecha de salida del vehículo bloqueado
                         bloq.fechaEntrega // Fecha de entrega del vehículo bloqueado
                       );
            });
        });
        
        if (coincidencias.length > 0) {
            // Recopilar los detalles de los términos específicos que deben eliminarse
            const detallesConflictos = coincidencias.map(v => {
                const conflicto = reservadosOtros.find(bloq => bloq.vehiculoId === v.vehiculoId);
        
                // Si no se encuentra un conflicto para el vehículo, muestra un mensaje
                if (!conflicto) {
                    console.log(`No se encontró conflicto para el vehículo: ${v.vehiculoName}`);
                }
                const fechaConflicto = `Desde: ${conflicto ? conflicto.fechaSalida : 'Desconocida'} Hasta: ${conflicto ? conflicto.fechaEntrega : 'Desconocida'}`;                
                return {
                    vehiculoId: v.vehiculoId,
                    fechaSalida: conflicto ? conflicto.fechaSalida : null,
                    fechaEntrega: conflicto ? conflicto.fechaEntrega : null,
                    vehiculoName: v.vehiculoName,
                    conflictoMensaje: `${v.vehiculoName} (Fechas bloqueadas: ${fechaConflicto})`
                };
            });
        
            console.log("Términos bloqueados:");
            console.log(detallesConflictos.map(conf => conf.fechaSalida).join(', '));
            console.log(detallesConflictos.map(conf => conf.fechaEntrega).join(', '));
            console.log(detallesConflictos.map(conf => conf.vehiculoName).join(', '));
            console.log(detallesConflictos.map(conf => conf.conflictoMensaje).join(', '));
            console.log(detallesConflictos.map(conf => conf.vehiculoId).join(', '));
            console.log("Termine");
            
            //eliminarTerminosConflictos(detallesConflictos);
            //this.msg = `El coche ${detallesConflictos.map(conf => conf.conflictoMensaje).join(', ')} ha sido reservado por otra oportunidad y ha sido eliminado de la tuya.`;
      
            //this.mostrarToast(this.msg); // Llamar al método para mostrar el toast
            deleteTerms({ detallesConflictosDatos: detallesConflictos, recordOpp: this.recordId })
            .then(result => {
                console.log('Términos eliminados con éxito.');
                this.msg = `El coche ${detallesConflictos.map(conf => conf.conflictoMensaje).join(', ')} ha sido reservado por otra oportunidad y ha sido eliminado de la tuya.`;
                this.mostrarToast(this.msg); // Mostrar el mensaje de confirmación
            })
            .catch(error => {
                console.error('Error al eliminar los términos:', error);
                this.msg = 'Hubo un error al intentar eliminar los vehículos.';
                this.mostrarToast(this.msg); // Mostrar un mensaje de error
            });
          } else {
              this.msg = 'Todos los vehículos están disponibles para esta oportunidad.';
              console.log(this.msg);
          }
      })
      .catch(error => {
          console.error('Error al verificar vehículos reservados por otras oportunidades', error);
      });
  }
  
  
    
      // Método para mostrar el Toast
      mostrarToast(message) {
        LightningToast.show({
          label: 'Notificación de vehículos',
          message: message,
          mode: 'sticky', // Puedes cambiar el modo si deseas que el Toast sea "dismisible" o permanezca visible
          variant: 'info', // Puedes usar 'info', 'success', 'warning' o 'error'
        }, this);
      }    
}
