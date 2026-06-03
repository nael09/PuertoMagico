package com.puertomagico.modelo;

import java.util.List;

/*
  Representa el transporte asignado a un tour.
  Define la capacidad y el layout del mapa de asientos.
 */
public class Vehiculo {

    private Integer id;
    // "VAN", "MINIBUS" o "AUTOBUS"
    private String  tipo;
    private Integer capacidad;
    private Object  layoutMapa;
    private String  descripcion;

    public Vehiculo() {}

    public Vehiculo(Integer id, String tipo, Integer capacidad,
                    Object layoutMapa, String descripcion) {
        this.id = id;
        this.tipo = tipo;
        this.capacidad = capacidad;
        this.layoutMapa = layoutMapa;
        this.descripcion = descripcion;
    }

    public Integer getId() { 
        return id; 
    }
    public void  setId(Integer id) { 
        this.id = id; 
    }

    public String  getTipo(){ 
        return tipo; 
    }
    public void setTipo(String tipo) {
        this.tipo = tipo; 
    }

    public Integer getCapacidad() { 
        return capacidad;
    }
    public void setCapacidad(Integer c){ 
        this.capacidad = c; 
    }

    public Object getLayoutMapa() {
        return layoutMapa; 
    }
    public void  setLayoutMapa(Object l){ 
        this.layoutMapa = l; 
    }

    public String getDescripcion() { 
        return descripcion; 
    }
    public void setDescripcion(String d){ 
        this.descripcion = d; 
    }

    @Override
    public String toString() {
        return "Vehiculo{id=" + id + ", tipo='" + tipo +
               "', capacidad=" + capacidad + "}";
    }
}