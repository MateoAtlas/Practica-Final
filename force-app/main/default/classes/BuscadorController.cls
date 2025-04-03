public with sharing class BuscadorController {
    @AuraEnabled(cacheable=true scope='global')
    public static Vehiculo__c[] getAllCars(String Id) {
        return [
            SELECT Id, Name, Marca__c, PrecioDia__c, Kilometros__c, Modelo_coche__c, Logo_marca__c 
            FROM Vehiculo__c
            WHERE Concesionario__c = :Id
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true scope='global')
    public static Vehiculo__c [] buscarCoches(String searchTerm, String IdConce) {
        // Return all bears when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllCars(IdConce);
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';
        // Execute search query
        return [
            SELECT Id, Name, Marca__c, PrecioDia__c, Kilometros__c, Modelo_coche__c, Logo_marca__c 
            FROM Vehiculo__c
            WHERE 
                (Name LIKE :searchTerm OR 
                Marca__c LIKE :searchTerm OR
                Modelo_coche__c LIKE :searchTerm)
                AND Concesionario__c = :IdConce
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true scope='global')
    public static List<Terminos_de_uso__c> agregarCoche (String idCoche, String idConce, String idOpp, Date fechaEntrega, Date fechaSalida) {        
        Vehiculo__c vehiculo = [SELECT Name FROM Vehiculo__c WHERE Id = :idCoche LIMIT 1];

        System.debug('Vehiculo Name: ' + vehiculo.Name);

        List <Terminos_de_uso__c> newTerms = new List <Terminos_de_uso__c>();

        Terminos_de_uso__c newTermino = new Terminos_de_uso__c (
            Name = 'Test' + vehiculo.Name,
            Concesionario__c = idConce,
            Opportunity__c = idOpp,     
            Vehiculo__c = vehiculo.Id,          
            Fecha_entrega__c = fechaEntrega,
            Fecha_salida__c = fechaSalida
        );
        newTerms.add(newTermino);
        
            System.debug('Entrando');
            return newTerms;
    }

    @AuraEnabled(cacheable=true scope='global')
    public static Vehiculo__c [] buscarCoche (String fechaSalida, String fechaEntrega, String conceId) {
        Date fechaSalidaDate = Date.valueOf(fechaSalida);
        Date fechaEntregaDate = Date.valueOf(fechaEntrega);
        
        List <Terminos_de_uso__c> terminosRango = [
            SELECT Id, Fecha_salida__c, Fecha_entrega__c, Name, Vehiculo__c
            FROM Terminos_de_uso__c
            WHERE (Fecha_salida__c <= :fechaEntregaDate AND Fecha_entrega__c >= :fechaSalidaDate) AND Concesionario__c = :conceId
            LIMIT 50
        ];

        Set <Id> vehiculosRango = new Set <Id>();
        for (Terminos_de_uso__c tdu : terminosRango) {
            vehiculosRango.add(tdu.Vehiculo__c);
        }

        return [
            SELECT Name, Marca__c, PrecioDia__c, Kilometros__c, Modelo_coche__c, Logo_marca__c 
            FROM Vehiculo__c
            WHERE Concesionario__c = :conceId
            AND Id NOT IN :vehiculosRango
        ];
    }
    @AuraEnabled(cacheable=true scope='global')
    public static Opportunity [] getOpportunity (String IdOpp) {
        return [
            SELECT Id, Name, Concesionario__c
            FROM Opportunity
            WHERE Id = :IdOpp
        ];
    }
}
