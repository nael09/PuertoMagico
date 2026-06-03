package com.puertomagico.modelo;

import java.time.LocalDateTime;

/*
  Opinion de un cliente sobre un tour o paquete.
 
  Una resena puede ser de un tour O de un paquete.
  Por eso tourId y paqueteId son opcionales (pueden ser null).
  Solo uno de los dos tendra valor segun lo que se reseno.
 
  La calificacion es del 1 al 5 y se valida en la BD
  con un CHECK CONSTRAINT.
 */
public class Resena {

    private Integer id;
    private Integer usuarioId;
    private Integer tourId;
    private Integer paqueteId;
    private Short calificacion;
    private String comentario;
    private LocalDateTime createdAt;
    private String  nombreUsuario;

    public Resena() {}

    public Resena(Integer id, Integer usuarioId, Integer tourId,
                  Integer paqueteId, Short calificacion,
                  String comentario, LocalDateTime createdAt) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.tourId = tourId;
        this.paqueteId = paqueteId;
        this.calificacion = calificacion;
        this.comentario = comentario;
        this.createdAt = createdAt;
    }

    public Integer getId(){
        return id;
    }
    public void setId(Integer id){
        this.id = id; 
    }

    public Integer getUsuarioId(){ 
        return usuarioId; 
    }
    public void setUsuarioId(Integer u){
        this.usuarioId = u; 
    }

    public Integer getTourId(){
        return tourId; 
    }
    public void setTourId(Integer tourId){ 
        this.tourId = tourId;
    }

    public Integer getPaqueteId(){ 
        return paqueteId; 
    }
    public void setPaqueteId(Integer p){
        this.paqueteId = p; 
    }

    public Short getCalificacion(){ 
        return calificacion;
    }
    public void  setCalificacion(Short c){ 
        this.calificacion = c; 
    }

    public String getComentario() {
        return comentario; 
    }
    public void setComentario(String c){ 
        this.comentario = c; 
    }

    public LocalDateTime getCreatedAt() { 
        return createdAt; 
    }
    public void setCreatedAt(LocalDateTime c){
        this.createdAt = c; 
    }

    public String getNombreUsuario() { 
        return nombreUsuario; 
    }
    public void setNombreUsuario(String n) { 
        this.nombreUsuario = n;
    }

    @Override
    public String toString() {
        return "Resena{id=" + id + ", calificacion=" +
               calificacion + ", usuario=" + nombreUsuario + "}";
    }
}