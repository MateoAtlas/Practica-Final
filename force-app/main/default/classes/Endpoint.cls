@RestResource(urlMapping='/Endpoint/*')
global with sharing class Endpoint {

    @HttpPost
    global static String insertarRegistro(String nombre, String Idcar, String tipo) {
        Savepoint sp = Database.setSavepoint();
        try {
            List<Reparacion__c> vehiculoArreglarList = [SELECT Id, Name, Finalizado__c, Termino_de_uso__c, Vehiculo__c FROM Reparacion__c WHERE Vehiculo__c = :Idcar AND Finalizado__c = false LIMIT 1];
    
            if (!vehiculoArreglarList.isEmpty() && vehiculoArreglarList[0].Finalizado__c == false) {        
                /* Agregar log */        
                Log__c newLog = new Log__c();
                newLog.Name = nombre;
                newLog.Coche_arreglado__c = Idcar;
                newLog.Tipo__c = tipo;
                newLog.Ultima_actualizacion__c = Date.today();
                //flow aqui
                insert newLog;

                /* Finalizar reparaciones */
                vehiculoArreglarList[0].Finalizado__c = true;
                update vehiculoArreglarList;

                /* Actualizar terminos del coche y coche */
                List <Vehiculo__c> vehiculoArreglado = [SELECT Id, Averiado__c, Disponible__c FROM Vehiculo__c WHERE Id = :Idcar LIMIT 1];
                vehiculoArreglado[0].Averiado__c = false;

                List <Terminos_de_uso__c> listTermPausados = [SELECT Id, Name, Vehiculo__c, Finalizado__c, Mantenimiento__c, Fecha_entrega__c, Opportunity__c FROM Terminos_de_uso__c WHERE Vehiculo__c = :Idcar];
                Boolean terminoEnUso = false;
                for (Terminos_de_uso__c term : listTermPausados) {
                    term.Mantenimiento__c = false;
                    if (term.Fecha_entrega__c > Date.today()) {
                        sendMailOwner(term.Opportunity__c);
                        vehiculoArreglado[0].Disponible__c = false;
                        terminoEnUso = true;
                    } else {
                        term.Finalizado__c = true;
                        vehiculoArreglado[0].Disponible__c = (terminoEnUso == true ? false : true);
                    }
                }

                update listTermPausados;
                update vehiculoArreglado;
                Database.releaseSavepoint(sp);
                return 'Coche registrado, esperando su actualización...';
            } else {
                return 'El coche seleccionado no está para arreglar.';
            }
    
        } catch (Exception e) {
            return 'Hubo un error inesperado, intentelo de nuevo mas tarde.';
            Database.rollback(sp);
            Database.releaseSavepoint(sp);
        }
    }
    

    @HttpGet
    global static String obtenerVehiculos() {
        try {
            List<Reparacion__c> vehiculos = [SELECT Name, Id, Vehiculo__c FROM Reparacion__c WHERE Finalizado__c = false];
    
            if (vehiculos.isEmpty()) {
                return '[{"mensaje": "No hay coches averiados"}]';
            }
    
            List<String> vehiculosArray = new List<String>();
    
            for (Reparacion__c v : vehiculos) {
                String vehiculoJson = '{' +
                    '"Name": "' + v.Name + '",' + 
                    '"Id coche: ": "' + v.Vehiculo__c + '",' + 
                '}';
    
                vehiculosArray.add(vehiculoJson);
            }
    
            return '[' + String.join(vehiculosArray, ',') + ']';
    
        } catch (Exception e) {
            return '[{"Error": "' + e.getMessage() + '"}]';
        }
    }
    
    private static void sendMailOwner (String oppId){

        List <Opportunity> oppTerm = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :oppId LIMIT 1];

        List <User> userOwner = [SELECT Id, LastName, FirstName, Email FROM User WHERE Id = :oppTerm[0].OwnerId LIMIT 1];

        Messaging.reserveSingleEmailCapacity(2); //Guardar espacio para 2 correos
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //Crear la clase


        //Envio de mails
        String[] toAddresses = new String[] {'m.sanjuan@atlascloud.es', userOwner[0].Email}; 
        //Envio normal
        mail.setToAddresses(toAddresses);

        mail.setReplyTo('support@acme.com'); //A quien se responde
        
        mail.setSenderDisplayName('Atlas car'); //Nombre que se muestra

        mail.setSubject('¡Tu vehiculo ha sido reparado!'); //Asunto

        mail.setPlainTextBody('Hola ' + userOwner[0].FirstName + ',\n\n' +
        'Nos complace informarte que tu coche ha sido reparado satisfactoriamente y ya está listo para ser usado nuevamente. ' +
        'Nuestro equipo ha trabajado para asegurar que tu vehículo esté en perfectas condiciones.\n\n' +
        'Si tienes alguna pregunta sobre los detalles de la reparación o necesitas más información, no dudes en contactarnos. Estamos a tu disposición para ayudarte.\n\n' +
        '¡Gracias por confiar en nosotros!\n\n' +
        'Saludos cordiales,\nEl equipo de Atlas Car');

        // Cuerpo del correo en HTML
        mail.setHtmlBody('<p>Hola ' + userOwner[0].FirstName + ',</p>' +
            '<p>Nos complace informarte que tu coche ha sido reparado satisfactoriamente y ya está listo para ser usado nuevamente. ' +
            'Nuestro equipo ha trabajado para asegurar que tu vehículo esté en perfectas condiciones.</p>' +
            '<p>Si tienes alguna pregunta sobre los detalles de la reparación o necesitas más información, no dudes en contactarnos. Estamos a tu disposición para ayudarte.</p>' +
            '<p>¡Gracias por confiar en nosotros!</p>' +
            '<p>Saludos cordiales,</p>' +
            '<p>El equipo de Atlas Car</p>');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //Envio
    }
}
