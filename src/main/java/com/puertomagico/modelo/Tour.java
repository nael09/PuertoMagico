package com.puertomagico.modelo;

import java.math.BigDecimal;

/*GUARDAR DATOS
 no tiene lógica de negocio ni conexión a la base de datos,
 Cada atributo de esta clase corresponde a una columna
 en la tabla "tours" 
 Cuando el DAO consulta la BD, crea objetos Tour y los
 llena con los datos que trajo de la base de datos.*/
public class Tour {

    private Integer id;
    private Integer destinoId;
    private Integer vehiculoId;
    private String nombre;
    private String descripcion;
    private Integer duracionHoras;
    private BigDecimal precioBase;
    private Integer cupoMaximo;
    private String dificultad;
    private Boolean activo;
    private String nombreDestino;
    private String nombreVehiculo;

    /*Es necesario tenerlo porque Gson (la librería que convierte
      objetos a JSON) lo usa para crear instancias vacías
      y luego llenarlas con los datos.
     */
    public Tour() {
    }
    /*Constructor completo
      Lo usamos en el DAO cuando traemos un tour de la BD
      y queremos crear el objeto con todos sus datos de una vez.*/
    public Tour(Integer id, Integer destinoId, Integer vehiculoId, String nombre,
                String descripcion, Integer duracionHoras, BigDecimal precioBase,
                Integer cupoMaximo, String dificultad, Boolean activo) {
        this.id = id;
        this.destinoId = destinoId;
        this.vehiculoId = vehiculoId;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.duracionHoras = duracionHoras;
        this.precioBase = precioBase;
        this.cupoMaximo = cupoMaximo;
        this.dificultad = dificultad;
        this.activo = activo;
    }

    // GETTERS Y SETTERS 
    // Los getters permiten LEER el valor de un atributo privado
    // Los setters permiten CAMBIAR el valor de un atributo privado

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getDestinoId() {
        return destinoId;
    }

    public void setDestinoId(Integer destinoId) {
        this.destinoId = destinoId;
    }

    public Integer getVehiculoId() {
        return vehiculoId;
    }

    public void setVehiculoId(Integer vehiculoId) {
        this.vehiculoId = vehiculoId;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Integer getDuracionHoras() {
        return duracionHoras;
    }

    public void setDuracionHoras(Integer duracionHoras) {
        this.duracionHoras = duracionHoras;
    }

    public BigDecimal getPrecioBase() {
        return precioBase;
    }

    public void setPrecioBase(BigDecimal precioBase) {
        this.precioBase = precioBase;
    }

    public Integer getCupoMaximo() {
        return cupoMaximo;
    }

    public void setCupoMaximo(Integer cupoMaximo) {
        this.cupoMaximo = cupoMaximo;
    }

    public String getDificultad() {
        return dificultad;
    }

    public void setDificultad(String dificultad) {
        this.dificultad = dificultad;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }

    public String getNombreDestino() {
        return nombreDestino;
    }

    public void setNombreDestino(String nombreDestino) {
        this.nombreDestino = nombreDestino;
    }

    public String getNombreVehiculo() {
        return nombreVehiculo;
    }

    public void setNombreVehiculo(String nombreVehiculo) {
        this.nombreVehiculo = nombreVehiculo;
    }
    /* Convierte el objeto a texto legible.
      Muy útil para depurar cuando imprimes un Tour
      en consola ves sus datos en lugar de algo como
      "com.puertomagico.modelo.Tour@3a4b5c6d"
     */
    @Override
    public String toString() {
        return "Tour{" +
               "id=" + id +
               ", nombre='" + nombre + '\'' +
               ", destino='" + nombreDestino + '\'' +
               ", precio=" + precioBase +
               ", duracion=" + duracionHoras + "hrs" +
               ", activo=" + activo +
               '}';
    }
}