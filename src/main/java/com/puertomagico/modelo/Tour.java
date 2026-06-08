package com.puertomagico.modelo;

import java.math.BigDecimal;

/**
 * Tour.java — JavaBean / Modelo
 *
 * Representa un tour turístico de la agencia.
 * Solo guarda datos — no tiene lógica de negocio
 * ni conexión a la base de datos.
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
    private String     nombreDestino;
    private String     nombreVehiculo;

    // Fecha preestablecida por la agencia (como String)
    private String fechaSalida;

    // Ciudades desde donde sale el transporte
    private String puntosSalida;

    /**
     * Constructor vacío — requerido por Gson.
     */
    public Tour() {}

    /**
     * Constructor completo.
     */
    public Tour(Integer id, Integer destinoId, Integer vehiculoId,
                String nombre, String descripcion,
                Integer duracionHoras, BigDecimal precioBase,
                Integer cupoMaximo, String dificultad,
                Boolean activo) {
        this.id            = id;
        this.destinoId     = destinoId;
        this.vehiculoId    = vehiculoId;
        this.nombre        = nombre;
        this.descripcion   = descripcion;
        this.duracionHoras = duracionHoras;
        this.precioBase    = precioBase;
        this.cupoMaximo    = cupoMaximo;
        this.dificultad    = dificultad;
        this.activo        = activo;
    }

    // ── GETTERS Y SETTERS ─────────────────────────────────

    public Integer getId()                     { return id; }
    public void    setId(Integer id)           { this.id = id; }

    public Integer getDestinoId()              { return destinoId; }
    public void    setDestinoId(Integer d)     { this.destinoId = d; }

    public Integer getVehiculoId()             { return vehiculoId; }
    public void    setVehiculoId(Integer v)    { this.vehiculoId = v; }

    public String  getNombre()                 { return nombre; }
    public void    setNombre(String n)         { this.nombre = n; }

    public String  getDescripcion()            { return descripcion; }
    public void    setDescripcion(String d)    { this.descripcion = d; }

    public Integer getDuracionHoras()          { return duracionHoras; }
    public void    setDuracionHoras(Integer d) { this.duracionHoras = d; }

    public BigDecimal getPrecioBase()          { return precioBase; }
    public void setPrecioBase(BigDecimal p)    { this.precioBase = p; }

    public Integer getCupoMaximo()             { return cupoMaximo; }
    public void    setCupoMaximo(Integer c)    { this.cupoMaximo = c; }

    public String  getDificultad()             { return dificultad; }
    public void    setDificultad(String d)     { this.dificultad = d; }

    public Boolean getActivo()                 { return activo; }
    public void    setActivo(Boolean a)        { this.activo = a; }

    public String  getNombreDestino()          { return nombreDestino; }
    public void    setNombreDestino(String n)  { this.nombreDestino = n; }

    public String  getNombreVehiculo()         { return nombreVehiculo; }
    public void    setNombreVehiculo(String n) { this.nombreVehiculo = n; }

    /**
     * fechaSalida — guardada como String "2026-07-13"
     * para evitar problemas de serialización con Gson.
     */
    public String getFechaSalida()           { return fechaSalida; }
    public void   setFechaSalida(String f)   { this.fechaSalida = f; }

    /**
     * puntosSalida — ciudades desde donde sale el transporte.
     * Ejemplo: "Veracruz, Cardel, Xalapa"
     */
    public String getPuntosSalida()          { return puntosSalida; }
    public void   setPuntosSalida(String p)  { this.puntosSalida = p; }

    /**
     * toString() — útil para depuración en consola.
     */
    @Override
    public String toString() {
        return "Tour{" +
               "id="          + id            +
               ", nombre='"   + nombre        + '\'' +
               ", destino='"  + nombreDestino + '\'' +
               ", precio="    + precioBase    +
               ", fecha="     + fechaSalida   +
               ", activo="    + activo        +
               '}';
    }
}