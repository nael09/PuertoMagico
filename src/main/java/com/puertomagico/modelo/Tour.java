package com.puertomagico.modelo;

import java.math.BigDecimal;

/**
 * Tour.java — JavaBean / Modelo
 *
 * Representa un tour turístico de la agencia.
 * Solo guarda datos — no tiene lógica de negocio
 * ni conexión a la base de datos.
 *
 * Cada atributo corresponde a una columna en la
 * tabla "tours" de PostgreSQL.
 *
 * Cuando el DAO consulta la BD, crea objetos Tour
 * y los llena con los datos traídos de la base de datos.
 */
public class Tour {

    private Integer    id;
    private Integer    destinoId;
    private Integer    vehiculoId;
    private String     nombre;
    private String     descripcion;
    private Integer    duracionHoras;
    private BigDecimal precioBase;
    private Integer    cupoMaximo;
    private String     dificultad;
    private Boolean    activo;

    // Campos adicionales traídos con JOIN desde otras tablas
    private String     nombreDestino;
    private String     nombreVehiculo;

    // Fecha preestablecida por la agencia para este tour
    private java.time.LocalDate fechaSalida;

    // Ciudades desde donde sale el transporte
    // Ejemplo: "Veracruz, Cardel, Xalapa"
    private String     puntosSalida;

    /**
     * Constructor vacío — requerido por Gson.
     * Gson lo usa para crear instancias vacías
     * y luego llenarlas con los datos del JSON.
     */
    public Tour() {}

    /**
     * Constructor completo.
     * Lo usamos en el DAO cuando traemos un tour de la BD
     * y queremos crear el objeto con todos sus datos de una vez.
     */
    public Tour(Integer id, Integer destinoId, Integer vehiculoId,
                String nombre, String descripcion,
                Integer duracionHoras, BigDecimal precioBase,
                Integer cupoMaximo, String dificultad,
                Boolean activo) {
        this.id           = id;
        this.destinoId    = destinoId;
        this.vehiculoId   = vehiculoId;
        this.nombre       = nombre;
        this.descripcion  = descripcion;
        this.duracionHoras= duracionHoras;
        this.precioBase   = precioBase;
        this.cupoMaximo   = cupoMaximo;
        this.dificultad   = dificultad;
        this.activo       = activo;
    }

    // ── GETTERS Y SETTERS ─────────────────────────────────
    // Getters: permiten LEER el valor de un atributo privado
    // Setters: permiten CAMBIAR el valor de un atributo privado

    public Integer getId()                  { return id; }
    public void    setId(Integer id)        { this.id = id; }

    public Integer getDestinoId()           { return destinoId; }
    public void    setDestinoId(Integer d)  { this.destinoId = d; }

    public Integer getVehiculoId()          { return vehiculoId; }
    public void    setVehiculoId(Integer v) { this.vehiculoId = v; }

    public String  getNombre()              { return nombre; }
    public void    setNombre(String n)      { this.nombre = n; }

    public String  getDescripcion()         { return descripcion; }
    public void    setDescripcion(String d) { this.descripcion = d; }

    public Integer getDuracionHoras()       { return duracionHoras; }
    public void    setDuracionHoras(Integer d) {
        this.duracionHoras = d; }

    public BigDecimal getPrecioBase()       { return precioBase; }
    public void       setPrecioBase(BigDecimal p) {
        this.precioBase = p; }

    public Integer getCupoMaximo()          { return cupoMaximo; }
    public void    setCupoMaximo(Integer c) { this.cupoMaximo = c; }

    public String  getDificultad()          { return dificultad; }
    public void    setDificultad(String d)  { this.dificultad = d; }

    public Boolean getActivo()              { return activo; }
    public void    setActivo(Boolean a)     { this.activo = a; }

    public String  getNombreDestino()       { return nombreDestino; }
    public void    setNombreDestino(String n) {
        this.nombreDestino = n; }

    public String  getNombreVehiculo()      { return nombreVehiculo; }
    public void    setNombreVehiculo(String n) {
        this.nombreVehiculo = n; }

    /**
     * getFechaSalida() / setFechaSalida()
     * Fecha en que sale el tour según la agencia.
     * El cliente no puede modificarla — es fija.
     */
    public java.time.LocalDate getFechaSalida() {
        return fechaSalida;
    }
    public void setFechaSalida(java.time.LocalDate f) {
        this.fechaSalida = f;
    }

    /**
     * getPuntosSalida() / setPuntosSalida()
     * Ciudades desde donde sale el transporte.
     * Ejemplo: "Veracruz, Cardel, Xalapa"
     */
    public String getPuntosSalida()           { return puntosSalida; }
    public void   setPuntosSalida(String p)   { this.puntosSalida = p; }

    /**
     * toString()
     * Convierte el objeto a texto legible para depuración.
     * Útil cuando imprimes un Tour en consola — ves sus datos
     * en lugar de algo como "com.puertomagico.modelo.Tour@3a4b5c6d"
     */
    @Override
    public String toString() {
        return "Tour{" +
               "id="       + id +
               ", nombre='"     + nombre       + '\'' +
               ", destino='"    + nombreDestino + '\'' +
               ", precio="      + precioBase   +
               ", duracion="    + duracionHoras + "hrs" +
               ", fechaSalida=" + fechaSalida  +
               ", activo="      + activo       +
               '}';
    }
}