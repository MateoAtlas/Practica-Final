public with sharing class pdfController {
    @AuraEnabled
    public static Account getAccountDetails(String recordId) {
        try {
            // Consulta la cuenta y otros campos que necesites
            Account acc = [SELECT Id, Name, Industry, Phone, Website FROM Account WHERE Id = :recordId LIMIT 1];
            return acc;
        } catch (Exception e) {
            throw new AuraHandledException('Error al obtener la cuenta: ' + e.getMessage());
        }
    }
}
