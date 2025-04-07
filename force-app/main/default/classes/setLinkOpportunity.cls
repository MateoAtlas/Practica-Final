public with sharing class setLinkOpportunity {
    @AuraEnabled
    public static void setLink(String link, String idOpp) {
        List <Opportunity> oppUpdate  = [SELECT Id, Name, Link_presupuesto__c FROM Opportunity WHERE Id = :idOpp];

        Opportunity opp = oppUpdate[0];

        opp.Link_presupuesto__c = link;
        update opp;
    }

    @AuraEnabled
    public static void changeCheckBox(String idOpp) {
        List <Opportunity> oppUpdate  = [SELECT Id, Name, Presupuesto_enviado__c FROM Opportunity WHERE Id = :idOpp];

        Opportunity opp = oppUpdate[0];

        opp.Presupuesto_enviado__c = true;
        update opp;
    }
}