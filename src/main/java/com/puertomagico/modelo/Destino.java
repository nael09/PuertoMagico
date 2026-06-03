package com.puertomagico.modelo;

/*
  Representa un lugar turístico de México.
  Cada tour pertenece a un destino.
 */
public class Destino {

    private Integer id;
    private String  nombre;
    private String  estado;
    private String  descripcion;
    private Boolean activo;

    public Destino() {}

    public Destino(Integer id, String nombre, String estado,
                   String descripcion, Boolean activo) {
        this.id = id;
        this.nombre = nombre;
        this.estado = estado;
        this.descripcion = descripcion;
        this.activo = activo;
    }

    public Integer getId(){ 
        return id; 
    }
    public void setId(Integer id) { 
        this.id = id; 
    }

    public String getNombre(){ 
        return nombre;
    }
    public void setNombre(String nombre){ 
        this.nombre = nombre; 
    }

    public String getEstado(){ 
        return estado; 
    }
    public void setEstado(String estado){
        this.estado = estado;
    }

    public String getDescripcion(){ 
        return descripcion; 
    }
    public void setDescripcion(String descripcion){
        this.descripcion = descripcion; 
    }

    public Boolean getActivo() {
        return activo; 
    }
    public void setActivo(Boolean activo){ 
        this.activo = activo; 
    }

    @Override
    public String toString() {
        return "Destino{id=" + id + ", nombre='" + nombre + "'}";
    }
}