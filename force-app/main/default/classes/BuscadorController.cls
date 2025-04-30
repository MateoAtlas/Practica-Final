public with sharing class BuscadorController {
    @AuraEnabled(cacheable=false)
    public static String agregarCoche (String idCoche, String idConce, String idOpp, Date fechaEntrega, Date fechaSalida) {
        Vehiculo__c vehiculo = [SELECT Name FROM Vehiculo__c WHERE Id = :idCoche LIMIT 1];
        System.debug('Vehículo recuperado: ' + vehiculo.Name);

        // Crea el nuevo término de uso
        List <Terminos_de_uso__c> newTerms = new List <Terminos_de_uso__c>();

        String shortFechaEntrega = fechaEntrega.format().substring(0, 5);  // Formato 'DD/MM'
        String shortFechaSalida = fechaSalida.format().substring(0, 5); 

        String nombreTermino = '_Veh_' +  vehiculo.Name + 
                               '_Ent_' + shortFechaEntrega + '_Sal_' + shortFechaSalida;

        // Crea el nuevo registro de Terminos_de_uso__c
        Terminos_de_uso__c newTermino = new Terminos_de_uso__c (
            Name = nombreTermino,
            Concesionario__c = idConce,
            Opportunity__c = idOpp,
            Vehiculo__c = idCoche,         
            Fecha_entrega__c = fechaEntrega,
            Fecha_salida__c = fechaSalida
        );
        newTerms.add(newTermino);

        // Depura los valores antes del insert
        System.debug('Valores antes del insert: ' + newTerms);

        // Realiza el insert
        insert newTerms;
        System.debug('Insertado correctamente: ' + newTerms[0].Id);

        // Devuelve el ID del término de uso insertado
        return newTerms[0].Id;
    }
    

    @AuraEnabled(cacheable=true scope='global')
    public static Vehiculo__c [] buscarCoche (String fechaSalida, String fechaEntrega, String conceId) {
        Date fechaSalidaDate = Date.valueOf(fechaSalida);
        Date fechaEntregaDate = Date.valueOf(fechaEntrega);
        
        List <Terminos_de_uso__c> terminosRango = [
            SELECT Id, Fecha_salida__c, Fecha_entrega__c, Name, Vehiculo__c
            FROM Terminos_de_uso__c
            WHERE (Fecha_salida__c <= :fechaEntregaDate AND Fecha_entrega__c >= :fechaSalidaDate AND Bloqueado__c = true) AND Concesionario__c = :conceId
            LIMIT 50
        ];

        Set <Id> vehiculosRango = new Set <Id>();
        for (Terminos_de_uso__c tdu : terminosRango) {
            vehiculosRango.add(tdu.Vehiculo__c);
        }

        return [
            SELECT Name, Marca__c, PrecioDia__c, Kilometros__c, Modelo_coche__c, Logo_marca__c, Averiado__c
            FROM Vehiculo__c
            WHERE Concesionario__c = :conceId
            AND Id NOT IN :vehiculosRango AND Averiado__c = false
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

    /* BUSCADOR CON FILTROS DE FECHA */
    @AuraEnabled(cacheable=true scope='global')
    public static Vehiculo__c [] buscarCochesFecha(String searchTerm, String IdConce, String fechaEntrega, String fechaSalida) {
        Date fechaSalidaDate = null;
        Date fechaEntregaDate = null;
        
        if (fechaSalida != null && fechaSalida != '') {
            fechaSalidaDate = Date.valueOf(fechaSalida);
        }
        
        if (fechaEntrega != null && fechaEntrega != '') {
            fechaEntregaDate = Date.valueOf(fechaEntrega);
        }

        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllCarsDate(IdConce, fechaEntregaDate, fechaSalidaDate);
        }
        
        System.debug('Salida -> ' + fechaSalida);
        System.debug('Entrega -> ' + fechaEntrega);
    
        searchTerm = '%' + searchTerm + '%';
    
        
        // Construir la consulta
        String query = 'SELECT Id, Name, Marca__c, PrecioDia__c, Kilometros__c, Modelo_coche__c, Logo_marca__c, Averiado__c ' +
                       'FROM Vehiculo__c ' +
                       'WHERE (Name LIKE :searchTerm OR Marca__c LIKE :searchTerm OR Modelo_coche__c LIKE :searchTerm) ' +
                       'AND Concesionario__c = :IdConce AND Averiado__c = false';
        
        // Si hay fecha agregada meto la consulta
        if (fechaEntregaDate != null && fechaSalidaDate != null) {
            query += 'AND Id NOT IN (SELECT Vehiculo__c ' +
                     'FROM Terminos_de_uso__c ' +
                     'WHERE Fecha_salida__c <= :fechaEntregaDate ' +
                     'AND Fecha_entrega__c >= :fechaSalidaDate ' +
                     'AND Concesionario__c = :IdConce' +
                     'AND Bloqueado__c = true)';
        }
        
        query += ' ORDER BY Name LIMIT 50';
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true scope='global')
    public static Vehiculo__c[] getAllCarsDate(String Id, Date fechaEntrega, Date fechaSalida) {
        String query = 'SELECT Id, Name, Marca__c, PrecioDia__c, Kilometros__c, Modelo_coche__c, Logo_marca__c, Averiado__c ' +
                       'FROM Vehiculo__c ' +
                       'WHERE Concesionario__c = :Id  AND Averiado__c = false ';
        
        // Si las fechas no están vacías, meto el filtro de fechas
        if (fechaEntrega != null && fechaSalida != null) {
            query += 'AND Id NOT IN ( ' +
                     'SELECT Vehiculo__c ' +
                     'FROM Terminos_de_uso__c ' +
                     'WHERE (Fecha_salida__c <= :fechaEntrega AND Fecha_entrega__c >= :fechaSalida) ' +
                     'AND Concesionario__c = :Id ' +
                     ') ';
        }
        
        query += 'WITH SECURITY_ENFORCED ' +
                 'ORDER BY Name ' +
                 'LIMIT 50';
    
        return Database.query(query);
    }

    /* BUSCADOR SIN FECHA */
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
}
