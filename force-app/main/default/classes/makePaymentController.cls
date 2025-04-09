public class makePaymentController {
    public Opportunity Opportunity { get; set; }
    public List<Terminos_de_uso__c> TerminosDeUso { get; set; }
    public List<Vehiculo__c> Vehiculos { get; set; }
    public Concesionario__c Concesionario { get; set; }
    public Contact Contact { get; set; }
    public Account Account { get; set; }
    
    public String realizado {get; set;}

    public makePaymentController() {
        System.debug('pin pan');
        System.debug('ID recordId -> '+ ApexPages.currentPage().getParameters().get('id'));

        String opportunityId = ApexPages.currentPage().getParameters().get('id');
        // Verificar que la oportunidad existe
        Opportunity = [SELECT Id, Name, Concesionario__c, Precio_total__c, AccountId, Presupuesto_aceptado__c
                       FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
        if (Opportunity == null) {
            realizado = 'Oportunidad no encontrada';
        } else if (Opportunity.Presupuesto_aceptado__c) {
            realizado = 'Pago ya realizado';
        } else {
            loadData(opportunityId, Opportunity);
        }
    }

    private void loadData (String opportunityId, Opportunity Opportunity) {
        // Cargar términos de uso relacionados con la oportunidad
        TerminosDeUso = [SELECT Id, Name, Fecha_entrega__c, Fecha_salida__c, Vehiculo__c, 
                                Concesionario__c, Opportunity__c, Precio_total__c, 
                                Vehiculo__r.Name // Añadimos la relación a Vehiculo__c
                         FROM Terminos_de_uso__c WHERE Opportunity__c = :opportunityId];

        // Verificar que se obtuvieron términos de uso
        if (TerminosDeUso.isEmpty()) {
            // Si no hay términos de uso, lanzar un error o manejarlo
            throw new AuraHandledException('No se encontraron términos de uso para esta oportunidad.');
        }

        // Cargar vehículos relacionados con los términos de uso
        List<Id> vehiculoIds = new List<Id>();
        for (Terminos_de_uso__c termino : TerminosDeUso) {
            if (termino.Vehiculo__c != null) {
                vehiculoIds.add(termino.Vehiculo__c);
            }
        }

        // Si hay vehículos relacionados, hacer la consulta
        if (!vehiculoIds.isEmpty()) {
            Vehiculos = [SELECT Id, Name, Marca__c, PrecioDia__c, Kilometros__c, Concesionario__c, Logo_marca__c
                         FROM Vehiculo__c WHERE Id IN :vehiculoIds];
        }

        // Cargar el concesionario, si existen términos de uso
        if (!TerminosDeUso.isEmpty()) {
            Concesionario = [SELECT Id, Name FROM Concesionario__c WHERE Id = :TerminosDeUso[0].Concesionario__c LIMIT 1];
        }

        Id accountId = Opportunity.AccountId;

        Account = [SELECT Id, Name, Opportunity__c FROM Account WHERE Id = :accountId];

        Contact = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId = :accountId];
    }

    public PageReference procesarPago() {
        Opportunity.Presupuesto_aceptado__c = true;
        Opportunity.StageName = 'Closed won';
        update Opportunity;
        realizado = 'Pago realizado con éxito';
        return null;
    }

}