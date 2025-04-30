public with sharing class getIdCarsOpp {

    @AuraEnabled
    //Coger datos de los coches y terminos asociados a una oportunidad
    public static List<Map<String, String>> getIds(Id idOpp) {
        List<Terminos_de_uso__c> termsOpp = [
            SELECT Id, Vehiculo__c, Vehiculo__r.Name, Fecha_salida__c, Fecha_entrega__c, Opportunity__c
            FROM Terminos_de_uso__c 
            WHERE Opportunity__c = :idOpp
        ];
        
        List<Map<String, String>> vehiculos = new List<Map<String, String>>();
        
        for (Terminos_de_uso__c term : termsOpp) {
            Map<String, String> vehiculo = new Map<String, String>();
            vehiculo.put('vehiculoId', String.valueOf(term.Vehiculo__c));
            vehiculo.put('vehiculoName', term.Vehiculo__r.Name);
            vehiculo.put('fechaSalida', String.valueOf(term.Fecha_salida__c)); 
            vehiculo.put('fechaEntrega', String.valueOf(term.Fecha_entrega__c)); 
            vehiculo.put('oppId', String.valueOf(term.Opportunity__c));
            
            vehiculos.add(vehiculo);
            
        }
        
        return vehiculos;
    }

    @AuraEnabled
    //Devolver los terminos bloqueados por otras oportunidades
    public static List<Map<String, Object>> getVehiculosBloqueadosPorOtrasOpp(Id idOpp) {
        List<Terminos_de_uso__c> terms = [
            SELECT Vehiculo__c, Vehiculo__r.Name, Fecha_salida__c, Fecha_entrega__c, Opportunity__c
            FROM Terminos_de_uso__c
            WHERE Bloqueado__c = true AND Opportunity__c != :idOpp
        ];

        List<Map<String, Object>> resultado = new List<Map<String, Object>>();
        for (Terminos_de_uso__c t : terms) {
            Map<String, Object> item = new Map<String, Object>();
            item.put('vehiculoId', t.Vehiculo__c);
            item.put('vehiculoName', t.Vehiculo__r.Name);
            item.put('fechaSalida', t.Fecha_salida__c);
            item.put('fechaEntrega', t.Fecha_entrega__c);
            item.put('oppId', t.Opportunity__c);
            resultado.add(item);
        }

        return resultado;
    }
    
    @AuraEnabled
    //Eliminar los terminos de uso que estén en el mismo rango que otros terminos en uso
    public static void deleteTerms(List<Map<String, String>> detallesConflictosDatos, Id recordOpp) {
        List<Terminos_de_uso__c> terminosAEliminar = new List<Terminos_de_uso__c>();
        
        // Iterar sobre los detalles de los conflictos
        for (Map<String, String> conflicto : detallesConflictosDatos) {
            Id vehiculoId = Id.valueOf(conflicto.get('vehiculoId'));
            Date fechaSalida = Date.valueOf(conflicto.get('fechaSalida'));
            Date fechaEntrega = Date.valueOf(conflicto.get('fechaEntrega'));

            //System.debug('Procesando vehículo: ' + vehiculoId + ' con salida ' + fechaSalida + ' y entrega ' + fechaEntrega);
    
   
            List<Terminos_de_uso__c> encontrados = [
                SELECT Id, Name, Fecha_salida__c, Vehiculo__c, Fecha_entrega__c, Opportunity__c 
                FROM Terminos_de_uso__c 
                WHERE Opportunity__c = :recordOpp
                AND Vehiculo__c = :vehiculoId
                AND Fecha_salida__c <= :fechaEntrega
                AND Fecha_entrega__c >= :fechaSalida
            ];
    
            terminosAEliminar.addAll(encontrados);
        }
    
        //System.debug('aL IF que va');
        
        if (!terminosAEliminar.isEmpty()) {
            delete terminosAEliminar;
            System.debug('Se eliminaron los términos con los siguientes Ids: ' + terminosAEliminar);
        } else {
            System.debug('No se encontraron términos que coincidan con los criterios.');
        }
    }
    
    
    
}
