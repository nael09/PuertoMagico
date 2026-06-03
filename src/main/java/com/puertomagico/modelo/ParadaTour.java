package com.puertomagico.modelo;

import java.math.BigDecimal;
import java.time.LocalTime;

/*
  Representa una parada dentro del itinerario de un tour.
  Las paradas se ordenan por el campo "orden" para
  mostrarlas en secuencia en la ficha del tour.
 
  Una parada puede ser obligatoria u opcional.
  Si es opcional, tiene un precio extra que se suma
  al precio base cuando el cliente la selecciona.
 */
public class ParadaTour {

    private Integer id;
    private Integer tourId;
    // Numero de secuencia: 1, 2, 3...
    private Integer orden;
    private String lugar;
    // Hora de llegada a la parada
    private LocalTime hora;
    // Cuanto tiempo se pasa en la parada
    private Integer duracionMin;
    // Costo adicional si la parada es opcional
    private BigDecimal precioExtra;
    // Si el cliente puede elegir no incluirla
    private Boolean opcional;
    private String descripcion;

    public ParadaTour() {}

    public ParadaTour(Integer id, Integer tourId, Integer orden,
                      String lugar, LocalTime hora,
                      Integer duracionMin, BigDecimal precioExtra,
                      Boolean opcional, String descripcion) {
        this.id = id;
        this.tourId = tourId;
        this.orden = orden;
        this.lugar = lugar;
        this.hora = hora;
        this.duracionMin = duracionMin;
        this.precioExtra = precioExtra;
        this.opcional    = opcional;
        this.descripcion = descripcion;
    }

    public Integer getId(){ 
        return id;
    }
    public void setId(Integer id){ 
        this.id = id; 
    }

    public Integer getTourId(){ 
        return tourId;
    }
    public void setTourId(Integer tourId){ 
        this.tourId = tourId; 
    }

    public Integer getOrden() { 
        return orden; 
    }
    public void setOrden(Integer orden){ 
        this.orden = orden; 
    }

    public String getLugar(){
        return lugar; 
    }
    public void setLugar(String lugar){ 
        this.lugar = lugar;
    }

    public LocalTime getHora(){ 
        return hora; 
    }
    public void setHora(LocalTime hora){
        this.hora = hora; 
    }

    public Integer getDuracionMin(){
        return duracionMin;
    }
    public void       setDuracionMin(Integer d){
        this.duracionMin = d; 
    }

    public BigDecimal getPrecioExtra() { 
        return precioExtra;
    }
    public void setPrecioExtra(BigDecimal p){ 
        this.precioExtra = p;
    }

    public Boolean getOpcional() {
        return opcional; }
    public void setOpcional(Boolean opcional){ 
        this.opcional = opcional; 
    }

    public String getDescripcion(){ 
        return descripcion; 
    }
    public void setDescripcion(String d){ 
        this.descripcion = d;
    }

    @Override
    public String toString() {
        return "ParadaTour{id=" + id + ", orden=" + orden +
               ", lugar='" + lugar + "'}";
    }
}