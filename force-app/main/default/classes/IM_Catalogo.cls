public with sharing class IM_Catalogo {

    public static String getAccessToken() {
        try {
            String authUrl = 'https://login.salesforce.com/services/oauth2/token';
        
            // Crear la solicitud HTTP
            HttpRequest req = new HttpRequest();
            req.setEndpoint(authUrl);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            req.setBody('grant_type=password&' + 
            'client_id=3MVG9YFqzc_KnL.zyOWhG6bAS4IyuOCwxzCH8wLfG6EFgpv6iNuAWEima5PaDGLut2nC7QHQ5RzP4gp_KRzTR&'+
            'client_secret=E8F5270DFFA7A94F3C99A7662655FF6C95CEA5C5346B2E4C6285DF4040B30254&' +
            'username=mateopubli27@gmail.com_atlascar&' + 
            'password=Kepler.168ZwqqU3YYWnEmc4iYeCD7WbO');
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                System.debug(JSON.deserializeUntyped(res.getBody()));
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                return (String) responseMap.get('access_token');
            } else {
                System.debug('Error al obtener el token: ' + res.getStatus());
                return null;
            }
        } catch (Exception e) {
            System.debug('eRR');
            return null;
        }
    }

    @InvocableMethod
    public static void callExternalApi () {
        String token = getAccessToken();
        System.debug(token);
        System.debug('token probando');
        if (token != null) {
            String apiUrl = 'https://brave-badger-q3ht3t-dev-ed.trailblaze.my.salesforce.com/services/apexrest/Endpoint/';
            System.debug('http request');
            HttpRequest req = new HttpRequest();
            req.setEndpoint(apiUrl);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + token);
            
            System.debug('Enviar');
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                System.debug('Respuesta de la API: ' + res.getBody());
            } else {
                System.debug('Error en la llamada API: ' + res.getStatus());
            }
        } else {
            System.debug('No hay token');
        }
    }


    public static String getAccessToken2() {
        try {
            String authUrl = 'https://login.salesforce.com/services/oauth2/token';
        
            // Crear la solicitud HTTP
            HttpRequest req = new HttpRequest();
            req.setEndpoint(authUrl);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                return res.getBody();
            } else {
                System.debug('Error al obtener el token: ' + res.getStatus());
                return null;
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            return null;
        }
    }
    

    public static void callExternalApi2 () {
        String body = getAccessToken2();
        //System.debug(body);
        //System.debug('intento 345645');
    
        List<Object> vehiculosObject = (List<Object>) JSON.deserializeUntyped(body);
        
        // Convertir cada objeto a un Map<String, Object>
        List<Map<String, Object>> vehiculos = new List<Map<String, Object>>();
        
        for (Object obj : vehiculosObject) {
            Map<String, Object> vehiculoMap = (Map<String, Object>) obj;
            vehiculos.add(vehiculoMap);
        }
        
        //System.debug(vehiculos);
        List <DVehiculo> listVehiculosCatalogo = new List <DVehiculo> ();
    
        for (Map<String, Object> vehiculo : vehiculos) {
            String name = (String) vehiculo.get('Name');
            String marca = (String) vehiculo.get('Marca__c');
            Decimal precioDia = (Decimal) vehiculo.get('PrecioDia__c');
            Decimal kilometros = (Decimal) vehiculo.get('Kilometros__c');
            String modelo = (String) vehiculo.get('Modelo_coche__c');
            String concesionario = (String) vehiculo.get('Concesionario__c');
            
            DVehiculo vehiculoClase = new DVehiculo(name, marca, precioDia, kilometros, modelo, concesionario);
            listVehiculosCatalogo.add(vehiculoClase);
        }
        //System.debug(listVehiculosCatalogo);
        updateRegistos(listVehiculosCatalogo);
    }
    
    private static void updateRegistos (List <DVehiculo> listVehiculosCatalogo) {
        Boolean error = false;
        Map<String, Vehiculo__c> vehiculosMap = new Map<String, Vehiculo__c>();

        try {
            List <Vehiculo__c> listVehiculosActuales = [SELECT Name, Marca__c, Modelo_coche__c, PrecioDia__c, Kilometros__c, Concesionario__c FROM Vehiculo__c];
            for (Vehiculo__c vehiculo : listVehiculosActuales) {
                vehiculosMap.put(vehiculo.Name, vehiculo);
            }
        } catch (Exception e) {
            error = true;
            System.debug('Error al recoger los vehiculos -> ' + e.getMessage());
        }
    
        if (!error) {
            List<Vehiculo__c> vehiculosParaInsertar = new List<Vehiculo__c>();
            List<Vehiculo__c> vehiculosParaActualizar = new List<Vehiculo__c>();
    
            for (DVehiculo dv : listVehiculosCatalogo) {
                if (vehiculosMap.containsKey(dv.Name)) {
                    // Vehículo existente
                    Vehiculo__c vehiculoExistente = vehiculosMap.get(dv.Name);
                    // Ver si los datos son nuevos y actualizamos registros
                    if (vehiculoExistente.PrecioDia__c != dv.PrecioDia || vehiculoExistente.Kilometros__c != dv.Kilometros) {
                        System.debug('Actualizar');
                        System.debug(dv.Name);
                        System.debug(vehiculoExistente.PrecioDia__c + ' _____ ' +dv.PrecioDia + ' ||||||||||| ' + (vehiculoExistente.PrecioDia__c != dv.PrecioDia));
                        System.debug(vehiculoExistente.Kilometros__c+ ' _____ ' + dv.Kilometros + ' ||||||||||| ' + (vehiculoExistente.Kilometros__c != dv.Kilometros));
                        System.debug('--------------------------------------------------------------');
                        
                        vehiculoExistente.PrecioDia__c = dv.PrecioDia;
                        vehiculoExistente.Kilometros__c = dv.Kilometros;
                        vehiculosParaActualizar.add(vehiculoExistente);
                    }
                } else {
                    // Nuevo vehiculo
                    Vehiculo__c nuevoVehiculo = new Vehiculo__c(
                        Name = dv.Name,
                        Marca__c = dv.Marca,
                        PrecioDia__c = dv.PrecioDia,
                        Kilometros__c = dv.Kilometros,
                        Modelo_coche__c = dv.Modelo_coche,
                        Concesionario__c = dv.Concesionario
                    );
                    vehiculosParaInsertar.add(nuevoVehiculo);
                    System.debug('Insertar');
                    System.debug(dv.Name);
                    System.debug('--------------------------------------------------------------');
                }
            }
    
            System.debug('Coches a actualizar ' + vehiculosParaActualizar.size() + ' :');
            System.debug(vehiculosParaActualizar);
            //update vehiculosParaActualizar;

            System.debug('Coches a insertar ' + vehiculosParaInsertar.size() + ' :');
            System.debug(vehiculosParaInsertar);
            //update vehiculosParaInsertar;
    
        } else {
            System.debug('Hubo un error al recoger los vehiculos');
        }
    }
    

}

/*
public static void updateOrInsertVehiculos(List<DVehiculo> vehiculos) {
    // Recoger vehículos existentes en Salesforce
    List<Vehicle__c> vehiculosExistentes = [SELECT Name, Marca__c, Modelo_coche__c, PrecioDia__c, Kilometros__c, Concesionario__c FROM Vehicle__c];
    Map<String, Vehicle__c> vehiculosMap = new Map<String, Vehicle__c>();
    
    for (Vehicle__c vehiculo : vehiculosExistentes) {
        vehiculosMap.put(vehiculo.Name, vehiculo);
    }
    
    List<Vehicle__c> vehiculosParaInsertar = new List<Vehicle__c>();
    List<Vehicle__c> vehiculosParaActualizar = new List<Vehicle__c>();
    
    for (DVehiculo dv : vehiculos) {
        if (vehiculosMap.containsKey(dv.Name)) {
            // Vehículo existente, lo actualizamos
            Vehicle__c vehiculoExistente = vehiculosMap.get(dv.Name);
            vehiculoExistente.PrecioDia__c = dv.PrecioDia__c;
            vehiculoExistente.Kilometros__c = dv.Kilometros__c;
            vehiculoExistente.Modelo_coche__c = dv.Modelo_coche__c;
            vehiculoExistente.Concesionario__c = dv.Concesionario__c;
            vehiculosParaActualizar.add(vehiculoExistente);
        } else {
            // Vehículo no existente, lo insertamos
            Vehicle__c nuevoVehiculo = new Vehicle__c(
                Name = dv.Name,
                Marca__c = dv.Marca__c,
                PrecioDia__c = dv.PrecioDia__c,
                Kilometros__c = dv.Kilometros__c,
                Modelo_coche__c = dv.Modelo_coche__c,
                Concesionario__c = dv.Concesionario__c
            );
            vehiculosParaInsertar.add(nuevoVehiculo);
        }
    }
    
    // Insertar los nuevos vehículos
    if (!vehiculosParaInsertar.isEmpty()) {
        insert vehiculosParaInsertar;
    }
    
    // Actualizar los vehículos existentes
    if (!vehiculosParaActualizar.isEmpty()) {
        update vehiculosParaActualizar;
    }
}

*/