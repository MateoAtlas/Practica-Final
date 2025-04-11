public with sharing class setLinkOpportunity {
    @AuraEnabled
    public static void setLink(String link, String idOpp, String linkPage) {
        List <Opportunity> oppUpdate  = [SELECT Id, Name, Link_presupuesto__c, Link_Pago__c FROM Opportunity WHERE Id = :idOpp];

        Opportunity opp = oppUpdate[0];

        opp.Link_presupuesto__c = link;
        opp.Link_Pago__c = linkPage;
        update opp;
    }

    @AuraEnabled
    public static void changeCheckBox(String idOpp) {
        /* OPORTUNIDAD */
        List <Opportunity> oppUpdate  = [SELECT Id, Name, Presupuesto_enviado__c FROM Opportunity WHERE Id = :idOpp];
        Opportunity opp = oppUpdate[0];
        opp.Presupuesto_enviado__c = true;
        opp.StageName = 'Reserva';
        opp.Fecha_pago_enviado__c = System.today();
        update opp;
        /* TERMINOS DE USO BLOQUEO */
        List <Terminos_de_uso__c> termsOpp = [SELECT Id, Bloqueado__c, Opportunity__c
                                            FROM Terminos_de_uso__c
                                            WHERE Opportunity__c = :idOpp];
        for (Terminos_de_uso__c termino : termsOpp) {
            termino.Bloqueado__c = true;
        }

        update termsOpp;

        sendMail2(idOpp);
    }


    private static void sendMail (String recordId){
        Opportunity opp = [SELECT Id, Link_presupuesto__c, Link_Pago__c FROM Opportunity WHERE Id = :recordId LIMIT 1];

        Messaging.reserveSingleEmailCapacity(2); //Guardar espacio para 2 correos
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //Crear la clase


        //Envio de mails
        String[] toAddresses = new String[] {'m.sanjuan@atlascloud.es'}; 
        //Envio normal
        mail.setToAddresses(toAddresses);

        mail.setReplyTo('support@acme.com'); //A quien se responde
        
        mail.setSenderDisplayName('Salesforce Support'); //Nombre que se muestra

        mail.setSubject('¡Tu presupuesto y opciones de pago están listos!'); //Asunto
        mail.setPlainTextBody('Hola, \n\nGracias por tu interés en nuestros productos. Nos complace informarte que tu presupuesto está listo para ser revisado. ' +
            'Puedes ver los detalles completos del presupuesto a través del siguiente enlace: \n\n' +
            opp.Link_presupuesto__c +  // Usamos el Link_presupuesto__c de la Opportunity
            '\n\nAdemás, si deseas proceder con el pago, puedes hacerlo de manera rápida y segura a través del siguiente enlace: \n\n' +
            opp.Link_Pago__c +  // Usamos el Link_Pago__c de la Opportunity
            '\n\nSi tienes alguna pregunta o necesitas más información, no dudes en contactarnos. Estamos a tu disposición para ayudarte. \n\n' +
            '¡Esperamos poder servirte pronto! \n\n' +
            'Saludos cordiales, \nEl equipo de Atlas Car');

        // Cuerpo del correo en HTML
        mail.setHtmlBody('<p>Hola,</p>' +
            '<p>Gracias por tu interés en nuestros productos. Nos complace informarte que tu presupuesto está listo para ser revisado. ' +
            'Puedes ver los detalles completos del presupuesto a través del siguiente enlace:</p>' +
            '<p><a href="' + opp.Link_presupuesto__c + '">Ver presupuesto</a></p>' +
            '<p>Además, si deseas proceder con el pago, puedes hacerlo de manera rápida y segura a través del siguiente enlace:</p>' +
            '<p><a href="' + opp.Link_Pago__c + '">Hacer pago</a></p>' +
            '<p>Si tienes alguna pregunta o necesitas más información, no dudes en contactarnos. Estamos a tu disposición para ayudarte.</p>' +
            '<p>¡Esperamos poder servirte pronto!</p>' +
            '<p>Saludos cordiales,</p>' +
            '<p>El equipo de Atlas Car</p>');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //Envio
    }

    private static void sendMail2(String recordId) {
        try {
            // Obtener la oportunidad
            Opportunity opp = [SELECT Id, Link_presupuesto__c, Link_Pago__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
    
            // Reservar espacio para 2 correos electrónicos
            Messaging.reserveSingleEmailCapacity(2);
    
            // Crear el correo electrónico
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
            // Generar el PDF de la página Visualforce
            PageReference pagePdf = new PageReference('/apex/opportunityPdfPage');
            pagePdf.getParameters().put('recordId', opp.Id);
            Blob fileBlob = pagePdf.getContentAsPDF();
            System.debug('URL de PDF: ' + pagePdf.getUrl());
            System.debug('Record ID de la oportunidad: ' + opp.Id);
            
            // Crear archivo adjunto
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('Atlas Car presupuesto.pdf');
            attachment.setBody(fileBlob);
            attachment.setContentType('application/pdf');
    
            // Configuración del correo
            String[] toAddresses = new String[] {'m.sanjuan@atlascloud.es', 'j.delacruz@atlascloud.es'}; 
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('support@acme.com');
            mail.setSenderDisplayName('Salesforce Support');
            mail.setSubject('¡Tu presupuesto y opciones de pago están listos!');
            
            // Cuerpo del correo en texto plano
            mail.setPlainTextBody('Hola, \n\nGracias por tu interés en nuestros productos. Nos complace informarte que tu presupuesto está listo para ser revisado. ' +
                'Puedes ver los detalles completos del presupuesto en el archivo adjunto aquí abajo\n\n' +
                '\n\nAdemás, si deseas proceder con el pago, puedes hacerlo de manera rápida y segura a través del siguiente enlace: \n\n' +
                opp.Link_Pago__c +  // Usamos el Link_Pago__c de la Opportunity
                '\n\nSi tienes alguna pregunta o necesitas más información, no dudes en contactarnos. Estamos a tu disposición para ayudarte. \n\n' +
                '¡Esperamos poder servirte pronto! \n\n' +
                'Saludos cordiales, \nEl equipo de Atlas Car');
    
            // Cuerpo del correo en HTML
            mail.setHtmlBody('<p>Hola,</p>' +
                '<p>Gracias por tu interés en nuestros productos. Nos complace informarte que tu presupuesto está listo para ser revisado. ' +
                'Puedes ver los detalles completos del presupuesto en el archivo adjunto aquí abajo</p>' +
                '<p>Además, si deseas proceder con el pago, puedes hacerlo de manera rápida y segura a través del siguiente enlace:</p>' +
                '<p><a href="' + opp.Link_Pago__c + '">Hacer pago</a></p>' +
                '<p>Si tienes alguna pregunta o necesitas más información, no dudes en contactarnos. Estamos a tu disposición para ayudarte.</p>' +
                '<p>¡Esperamos poder servirte pronto!</p>' +
                '<p>Saludos cordiales,</p>' +
                '<p>El equipo de Atlas Car</p>');
    
            // Adjuntar el archivo PDF
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
    
            // Enviar el correo
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
            System.debug('Correo enviado con el PDF adjunto.');
        } catch (Exception e) {
            System.debug('Error al enviar el correo: ' + e.getMessage());
        }
    }
    
}

/*
    private static void sendMail (String recordId){
        System.debug('ENTRO');
        Opportunity opp = [SELECT Id, Link_presupuesto__c, Link_Pago__c, Concesionario__c FROM Opportunity WHERE Id = :recordId LIMIT 1];

        // Ahora, podemos acceder al Id del Concesionario relacionado
        Id concesionarioId = opp.Concesionario__c;
        
        // Hacemos otra consulta para obtener información del Concesionario
        Concesionario__c concesionario = [SELECT Id, Name FROM Concesionario__c WHERE Id = :concesionarioId LIMIT 1];
        Messaging.reserveSingleEmailCapacity(2); //Guardar espacio para 2 correos
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //Crear la clase

        // Generar pdf
        //https://brave-badger-q3ht3t-dev-ed--c.trailblaze.vf.force.com/apex/opportunityPdfPage?recordId=006d2000005kQMRAA2
        PageReference pagePdf = new PageReference('apex/opportunityPdfPage?recordId=' + recordId);
        //pagePdf.getParameters().put('recordId', opp.Id);
        Blob fileBlob = pagePdf.getContentAsPDF();
        // Crear archivo adjunto
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Atlas Car presupuesto.pdf');
        attachment.setBody(fileBlob);
        attachment.setContentType('application/pdf');
        System.debug('aa');
        //Envio de mails
        String[] toAddresses = new String[] {'m.sanjuan@atlascloud.es'}; 
        //Envio normal
        mail.setToAddresses(toAddresses);

        mail.setReplyTo('support@acme.com'); //A quien se responde
        
        mail.setSenderDisplayName('Atlas Car ' + concesionario.Name); //Nombre que se muestra

        mail.setSubject('¡Tu presupuesto y opciones de pago están listos!'); //Asunto
        mail.setPlainTextBody('Hola, \n\nGracias por tu interés en nuestros productos. Nos complace informarte que tu presupuesto está listo para ser revisado. ' +
            'Puedes ver los detalles completos del presupuesto a través del siguiente enlace: \n\n' +
            opp.Link_presupuesto__c +  // Usamos el Link_presupuesto__c de la Opportunity
            '\n\nAdemás, si deseas proceder con el pago, puedes hacerlo de manera rápida y segura a través del siguiente enlace: \n\n' +
            opp.Link_Pago__c +  // Usamos el Link_Pago__c de la Opportunity
            '\n\nSi tienes alguna pregunta o necesitas más información, no dudes en contactarnos. Estamos a tu disposición para ayudarte. \n\n' +
            '¡Esperamos poder servirte pronto! \n\n' +
            'Saludos cordiales, \nEl equipo de Atlas Car');

        // Cuerpo del correo en HTML
        mail.setHtmlBody('<p>Hola,</p>' +
            '<p>Gracias por tu interés en nuestros productos. Nos complace informarte que tu presupuesto está listo para ser revisado. ' +
            'Puedes ver los detalles completos del presupuesto a través del siguiente enlace:</p>' +
            '<p><a href="' + opp.Link_presupuesto__c + '">Ver presupuesto</a></p>' +
            '<p>Además, si deseas proceder con el pago, puedes hacerlo de manera rápida y segura a través del siguiente enlace:</p>' +
            '<p><a href="' + opp.Link_Pago__c + '">Hacer pago</a></p>' +
            '<p>Si tienes alguna pregunta o necesitas más información, no dudes en contactarnos. Estamos a tu disposición para ayudarte.</p>' +
            '<p>¡Esperamos poder servirte pronto!</p>' +
            '<p>Saludos cordiales,</p>' +
            '<p>El equipo de Atlas Car</p>');
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment}); //Adjuntar el pdf
        System.debug('ok');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //Envio
    }
*/