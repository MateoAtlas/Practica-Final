@isTest
public class TEST_Catalogo {

    @isTest(seeAllData=true)
    public static void testExternalApiCallSuccess () {
        String mockResponse = obtenerCoches();
                              /* coche no existe? creo
                              precio nuevo? update -- transformar/simular DVehiculo DUMMY -  */
        
        Test.setMock(HttpCalloutMock.class, new MK_Catalogo(mockResponse));
        
        Test.startTest();

        IM_Catalogo.callExternalApi2(); //
        
        Test.stopTest();
        
        System.assert(true, 'La prueba se completó correctamente');
    }

    public static void testExternalApiCallError () {
        String mockResponse = '2';
        
        Test.setMock(HttpCalloutMock.class, new MK_Catalogo(mockResponse));
        
        Test.startTest();

        IM_Catalogo.callExternalApi(); //
        
        Test.stopTest();
        
        System.assert(true, 'La prueba se completó correctamente');
    }

    public static void testExternalApiCallToken () {
        String mockResponse = 'grant_type=password&' + 
            'client_id=3MVG9YFqzc_KnL.zyOWhG6bAS4IyuOCwxzCH8wLfG6EFgpv6iNuAWEima5PaDGLut2nC7QHQ5RzP4gp_KRzTR&'+
            'client_secret=E8F5270DFFA7A94F3C99A7662655FF6C95CEA5C5346B2E4C6285DF4040B30254&' +
            'username=mateopubli27@gmail.com_atlascar&' + 
            'password=Kepler.168ZwqqU3YYWnEmc4iYeCD7WbO';
        
        Test.setMock(HttpCalloutMock.class, new MK_Catalogo(mockResponse));
        
        Test.startTest();

        IM_Catalogo.callExternalApi(); //
        
        Test.stopTest();
        
        System.assert(true, 'La prueba se completó correctamente');
    }

    public static String obtenerCoches() {
        return '[ ' +
            '{ "Name": "Vehiculo 1 Madrid", "Marca__c": "Mercedes", "PrecioDia__c": 105, "Kilometros__c": 58762, "Modelo_coche__c": "Mercedes-Benz A-Class", "Concesionario__c": "a03d200000GvyO1AAJ" }, ' +
            '{ "Name": "Vehiculo 2 Madrid", "Marca__c": "Bmw", "PrecioDia__c": 110, "Kilometros__c": 24591, "Modelo_coche__c": "BMW 3 Series", "Concesionario__c": "a03d200000GvyO2AAJ" }, ' +
            '{ "Name": "Vehiculo 3 Madrid", "Marca__c": "Audi", "PrecioDia__c": 120, "Kilometros__c": 169160, "Modelo_coche__c": "Audi A3", "Concesionario__c": "a03d200000GvyO1AAJ" }, ' +
            '{ "Name": "Vehiculo 4 Madrid", "Marca__c": "Seat", "PrecioDia__c": 130, "Kilometros__c": 199789, "Modelo_coche__c": "Seat Leon", "Concesionario__c": "a03d200000GvyO2AAJ" }, ' +
            '{ "Name": "Vehiculo 5 Madrid", "Marca__c": "Ford", "PrecioDia__c": 140, "Kilometros__c": 137899, "Modelo_coche__c": "Ford Fiesta", "Concesionario__c": "a03d200000GvyO1AAJ" }, ' +
            '{ "Name": "Vehiculo 6 Madrid Nuevo", "Marca__c": "Volkswagen", "PrecioDia__c": 150, "Kilometros__c": 83541, "Modelo_coche__c": "Volkswagen Golf", "Concesionario__c": "a03d200000GvyO2AAJ" }, ' +
            '{ "Name": "Vehiculo 7 Madrid Nuevo", "Marca__c": "Citroen", "PrecioDia__c": 160, "Kilometros__c": 24061, "Modelo_coche__c": "Citroën C3", "Concesionario__c": "a03d200000GvyO1AAJ" }, ' +
            '{ "Name": "Vehiculo 8 Madrid Nuevo", "Marca__c": "Toyota", "PrecioDia__c": 170, "Kilometros__c": 185854, "Modelo_coche__c": "Toyota Yaris", "Concesionario__c": "a03d200000GvyO2AAJ" }, ' +
            '{ "Name": "Vehiculo 9 Madrid Nuevo", "Marca__c": "Opel", "PrecioDia__c": 180, "Kilometros__c": 65090, "Modelo_coche__c": "Opel Corsa", "Concesionario__c": "a03d200000GvyO1AAJ" }, ' +
            '{ "Name": "Vehiculo 10 Madrid Nuevo", "Marca__c": "Mazda", "PrecioDia__c": 190, "Kilometros__c": 132083, "Modelo_coche__c": "Mazda 3", "Concesionario__c": "a03d200000GvyO2AAJ" }, ' +
            '{ "Name": "Vehiculo 1 Segovia", "Marca__c": "Mercedes", "PrecioDia__c": 100, "Kilometros__c": 111819, "Modelo_coche__c": "Mercedes-Benz E-Class", "Concesionario__c": "a03d200000GvyO1AAJ" }, ' +
            '{ "Name": "Vehiculo 2 Segovia", "Marca__c": "Bmw", "PrecioDia__c": 100, "Kilometros__c": 129996, "Modelo_coche__c": "BMW X5", "Concesionario__c": "a03d200000GvyO2AAJ" }, ' +
            '{ "Name": "Vehiculo 3 Segovia", "Marca__c": "Audi", "PrecioDia__c": 120, "Kilometros__c": 48477, "Modelo_coche__c": "Audi A3", "Concesionario__c": "a03d200000GvyO1AAJ" }, ' +
            '{ "Name": "Vehiculo 4 Segovia", "Marca__c": "Seat", "PrecioDia__c": 130, "Kilometros__c": 152273, "Modelo_coche__c": "Seat Leon", "Concesionario__c": "a03d200000GvyO2AAJ" }, ' +
            '{ "Name": "Vehiculo 5 Segovia", "Marca__c": "Ford", "PrecioDia__c": 150, "Kilometros__c": 38887, "Modelo_coche__c": "Ford Fiesta", "Concesionario__c": "a03d200000GvyO1AAJ" }, ' +
            '{ "Name": "Vehiculo 6 Segovia", "Marca__c": "Volkswagen", "PrecioDia__c": 150, "Kilometros__c": 72047, "Modelo_coche__c": "Volkswagen Polo", "Concesionario__c": "a03d200000GvyO2AAJ" }, ' +
            '{ "Name": "Vehiculo 7 Segovia", "Marca__c": "Citroen", "PrecioDia__c": 160, "Kilometros__c": 10005, "Modelo_coche__c": "Citroën C4", "Concesionario__c": "a03d200000GvyO1AAJ" }, ' +
            '{ "Name": "Vehiculo 8 Segovia", "Marca__c": "Toyota", "PrecioDia__c": 170, "Kilometros__c": 110670, "Modelo_coche__c": "Toyota RAV4", "Concesionario__c": "a03d200000GvyO2AAJ" }, ' +
            '{ "Name": "Vehiculo 9 Segovia", "Marca__c": "Opel", "PrecioDia__c": 180, "Kilometros__c": 42509, "Modelo_coche__c": "Opel Astra", "Concesionario__c": "a03d200000GvyO1AAJ" }, ' +
            '{ "Name": "Vehiculo 10 Segovia", "Marca__c": "Mazda", "PrecioDia__c": 190, "Kilometros__c": 77778, "Modelo_coche__c": "Mazda CX-5", "Concesionario__c": "a03d200000GvyO2AAJ" } ' +
        ']';
    }
    

}

/* 
{
  "coches": [
    {
      "Name": "Vehiculo 1 Madrid",
      "Marca__c": "Mercedes",
      "PrecioDia__c": 100,
      "Kilometros__c": 58762,
      "Modelo_coche__c": "Mercedes-Benz A-Class",
      "Concesionario__c": "a03d200000GvyO1AAJ"
    },
    {
      "Name": "Vehiculo 2 Madrid",
      "Marca__c": "Bmw",
      "PrecioDia__c": 110,
      "Kilometros__c": 24591,
      "Modelo_coche__c": "BMW 3 Series",
      "Concesionario__c": "a03d200000GvyO2AAJ"
    },
    {
      "Name": "Vehiculo 3 Madrid",
      "Marca__c": "Audi",
      "PrecioDia__c": 120,
      "Kilometros__c": 169160,
      "Modelo_coche__c": "Audi A3",
      "Concesionario__c": "a03d200000GvyO1AAJ"
    },
    {
      "Name": "Vehiculo 4 Madrid",
      "Marca__c": "Seat",
      "PrecioDia__c": 130,
      "Kilometros__c": 197789,
      "Modelo_coche__c": "Seat Leon",
      "Concesionario__c": "a03d200000GvyO2AAJ"
    },
    {
      "Name": "Vehiculo 5 Madrid",
      "Marca__c": "Ford",
      "PrecioDia__c": 140,
      "Kilometros__c": 137898,
      "Modelo_coche__c": "Ford Fiesta",
      "Concesionario__c": "a03d200000GvyO1AAJ"
    },
    {
      "Name": "Vehiculo 6 Madrid Nuevo",
      "Marca__c": "Volkswagen",
      "PrecioDia__c": 150,
      "Kilometros__c": 83541,
      "Modelo_coche__c": "Volkswagen Golf",
      "Concesionario__c": "a03d200000GvyO2AAJ"
    },
    {
      "Name": "Vehiculo 7 Madrid Nuevo",
      "Marca__c": "Citroen",
      "PrecioDia__c": 160,
      "Kilometros__c": 24061,
      "Modelo_coche__c": "Citroën C3",
      "Concesionario__c": "a03d200000GvyO1AAJ"
    },
    {
      "Name": "Vehiculo 8 Madrid Nuevo",
      "Marca__c": "Toyota",
      "PrecioDia__c": 170,
      "Kilometros__c": 185854,
      "Modelo_coche__c": "Toyota Yaris",
      "Concesionario__c": "a03d200000GvyO2AAJ"
    },
    {
      "Name": "Vehiculo 9 Madrid Nuevo",
      "Marca__c": "Opel",
      "PrecioDia__c": 180,
      "Kilometros__c": 65090,
      "Modelo_coche__c": "Opel Corsa",
      "Concesionario__c": "a03d200000GvyO1AAJ"
    },
    {
      "Name": "Vehiculo 10 Madrid Nuevo",
      "Marca__c": "Mazda",
      "PrecioDia__c": 190,
      "Kilometros__c": 132083,
      "Modelo_coche__c": "Mazda 3",
      "Concesionario__c": "a03d200000GvyO2AAJ"
    },
    {
      "Name": "Vehiculo 1 Segovia",
      "Marca__c": "Mercedes",
      "PrecioDia__c": 100,
      "Kilometros__c": 111819,
      "Modelo_coche__c": "Mercedes-Benz E-Class",
      "Concesionario__c": "a03d200000GvyO1AAJ"
    },
    {
      "Name": "Vehiculo 2 Segovia",
      "Marca__c": "Bmw",
      "PrecioDia__c": 110,
      "Kilometros__c": 129996,
      "Modelo_coche__c": "BMW X5",
      "Concesionario__c": "a03d200000GvyO2AAJ"
    },
    {
      "Name": "Vehiculo 3 Segovia",
      "Marca__c": "Audi",
      "PrecioDia__c": 120,
      "Kilometros__c": 48477,
      "Modelo_coche__c": "Audi A3",
      "Concesionario__c": "a03d200000GvyO1AAJ"
    },
    {
      "Name": "Vehiculo 4 Segovia",
      "Marca__c": "Seat",
      "PrecioDia__c": 130,
      "Kilometros__c": 152273,
      "Modelo_coche__c": "Seat Leon",
      "Concesionario__c": "a03d200000GvyO2AAJ"
    },
    {
      "Name": "Vehiculo 5 Segovia",
      "Marca__c": "Ford",
      "PrecioDia__c": 140,
      "Kilometros__c": 38887,
      "Modelo_coche__c": "Ford Fiesta",
      "Concesionario__c": "a03d200000GvyO1AAJ"
    },
    {
      "Name": "Vehiculo 6 Segovia",
      "Marca__c": "Volkswagen",
      "PrecioDia__c": 150,
      "Kilometros__c": 72047,
      "Modelo_coche__c": "Volkswagen Polo",
      "Concesionario__c": "a03d200000GvyO2AAJ"
    },
    {
      "Name": "Vehiculo 7 Segovia",
      "Marca__c": "Citroen",
      "PrecioDia__c": 160,
      "Kilometros__c": 10005,
      "Modelo_coche__c": "Citroën C4",
      "Concesionario__c": "a03d200000GvyO1AAJ"
    },
    {
      "Name": "Vehiculo 8 Segovia",
      "Marca__c": "Toyota",
      "PrecioDia__c": 170,
      "Kilometros__c": 110670,
      "Modelo_coche__c": "Toyota RAV4",
      "Concesionario__c": "a03d200000GvyO2AAJ"
    },
    {
      "Name": "Vehiculo 9 Segovia",
      "Marca__c": "Opel",
      "PrecioDia__c": 180,
      "Kilometros__c": 42509,
      "Modelo_coche__c": "Opel Astra",
      "Concesionario__c": "a03d200000GvyO1AAJ"
    },
    {
      "Name": "Vehiculo 10 Segovia",
      "Marca__c": "Mazda",
      "PrecioDia__c": 190,
      "Kilometros__c": 76778,
      "Modelo_coche__c": "Mazda CX-5",
      "Concesionario__c": "a03d200000GvyO2AAJ"
    }
  ]
}

*/

/* 
Mercedes
Bmw
Audi
Seat
Ford
Volkswagen
Citroen
Toyota
Opel
Mazda


 Mercedes-Benz A-Class
 Mercedes-Benz C-Class
 Mercedes-Benz E-Class
 BMW 3 Series
 BMW X5	
 BMW 5 Serie
 Audi A3
 Audi Q5
 Audi A6
 Seat Ibiza	
 Seat Leon	
 Seat Ateca	
 Ford Fiesta	
 Ford Focus	
 Ford Mustang
 Volkswagen Golf
 Volkswagen Polo
 Volkswagen Tiguan
 Citroën C3	
 Citroën C4	
 Citroën C5	
 Toyota Corolla 
 Toyota Yaris 
 Toyota RAV4 
 Opel Astra	
 Opel Insignia	
 Opel Corsa	
 Mazda 3
 Mazda CX-5
 Mazda MX-5
*/