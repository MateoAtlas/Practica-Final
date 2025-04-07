public with sharing class ListaController {
    @AuraEnabled(cacheable=false)
    public static Terminos_de_uso__c [] getAll(String idOpp) {
        return [
            SELECT Id, Vehiculo__r.Name, Fecha_salida__c, Fecha_entrega__c, Name, Precio_total__c
            FROM Terminos_de_uso__c 
            WHERE Opportunity__c = :idOpp
        ];
    }

    @AuraEnabled
    public static Integer updateRecord (String idOpp) {
        List <Opportunity> Opportunities =  [SELECT Id, Name, Total_de_coches__c FROM Opportunity WHERE Id = :idOpp];

        List <Terminos_de_uso__c> terminosOpp = getAll(idOpp);

        Opportunity oppActual = Opportunities[0];
        oppActual.Total_de_coches__c = terminosOpp.size();
        update oppActual;
        return terminosOpp.size();
    }

    @AuraEnabled
    public static String deleteRecord(String termId){
        Terminos_de_uso__c termToDelete = [SELECT Id FROM Terminos_de_uso__c WHERE Id = :termId LIMIT 1];

        delete termToDelete;

        return 'ole y ole';
    }
}