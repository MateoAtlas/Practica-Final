public with sharing class DVehiculo {
    
    public String Name { get; set; }
    public String Marca { get; set; }
    public Decimal PrecioDia { get; set; }
    public Decimal Kilometros { get; set; }
    public String Modelo_coche { get; set; }
    public String Concesionario { get; set; }
    
    // Constructor
    public DVehiculo(String name, String marca, Decimal precioDia, Decimal kilometros, String modelo, String concesionario) {
        this.Name = name;
        this.Marca = marca;
        this.PrecioDia = precioDia;
        this.Kilometros = kilometros;
        this.Modelo_coche = modelo;
        this.Concesionario = concesionario;
    }
}
