public with sharing class BuscadorController {
    @AuraEnabled(cacheable=true scope='global')
    public static Vehiculo__c[] getAllCars() {
        return [
            SELECT
                Id, Name, Marca__c, PrecioDia__c, Logo_marca__c, Kilometros__c, Modelo_coche__c
            FROM Vehiculo__c
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true scope='global')
    public static Vehiculo__c [] buscarCoches(String searchTerm) {
        // Return all bears when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllCars();
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';
        // Execute search query
        return [
            SELECT
                Id, Name, Marca__c, PrecioDia__c, Kilometros__c, Modelo_coche__c
            FROM Vehiculo__c
            WHERE 
                Name LIKE :searchTerm OR 
                Marca__c LIKE :searchTerm OR
                Modelo_coche__c LIKE :searchTerm
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 50
        ];
    }
}
