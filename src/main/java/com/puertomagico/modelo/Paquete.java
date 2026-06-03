package com.puertomagico.modelo;

import java.math.BigDecimal;

public class Paquete {

    private Integer id;
    private String nombre;
    private String descripcion;
    private Integer duracionDias;
    // Precio total del paquete por persona
    private BigDecimal precioBase;
    private Integer cupoMaximo;
    private String categoria;
    private Boolean activo;

    public Paquete() {
    }

    public Paquete(Integer id, String nombre, String descripcion,
                   Integer duracionDias, BigDecimal precioBase,
                   Integer cupoMaximo, String categoria, Boolean activo) {
        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.duracionDias = duracionDias;
        this.precioBase = precioBase;
        this.cupoMaximo = cupoMaximo;
        this.categoria = categoria;
        this.activo = activo;
    }

    //Devuelve la duración en formato legible para el usuario.
    //Ejemplo: si duracionDias = 5, devuelve "5 días / 4 noches"
    public String getDuracionTexto() {
        int noches = this.duracionDias - 1;
        return this.duracionDias + " días / " + noches + " noches";
    }

    /*Verifica si el paquete pertenece a una categoría específica 
      Uso en el Servlet cuando el cliente filtra por categoría*/
    public boolean esDeCategoria(String categoria) {
        return this.categoria.equalsIgnoreCase(categoria);
    }

    // GETTERS Y SETTERS 

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public Integer getDuracionDias() {
        return duracionDias;
    }

    public void setDuracionDias(Integer duracionDias) {
        this.duracionDias = duracionDias;
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

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }

    @Override
    public String toString() {
        return "Paquete{" +
               "id=" + id +
               ", nombre='" + nombre + '\'' +
               ", duracion='" + getDuracionTexto() + '\'' +
               ", precio=" + precioBase +
               ", categoria='" + categoria + '\'' +
               ", activo=" + activo +
               '}';
    }
}