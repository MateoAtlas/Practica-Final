public with sharing class pdfController {
    public Opportunity opp { get; set; }

    public pdfController(ApexPages.StandardController controller) {
        this.opp = (Opportunity)controller.getRecord();
    }   
}
