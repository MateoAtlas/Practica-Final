public with sharing class CountdownController {
    @AuraEnabled(cacheable=true)
    public static Date getFechaPagoEnviado(Id opportunityId) {
        Opportunity opp = [SELECT Fecha_pago_enviado__c FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
        return opp.Fecha_pago_enviado__c;
    }
}