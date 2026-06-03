package com.puertomagico.modelo;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/*Representa la contratación de un tour o paquete por parte
  de un cliente, conecta al usuario con el servicio que compro.*/
public class Reserva {

    private Integer id;
    private Integer usuarioId;
    private String tipoServicio;
    private Integer tourId;
    private Integer paqueteId;
    private LocalDate fechaViaje;
    private Integer personas;
    private BigDecimal total;
    private String estado;
    private LocalDateTime createdAt;
    // DATOS ADICIONALES PARA MOSTRAR EN PANTALLA 
    // Estos campos no están en la tabla reservas directamente,
    // los traemos con JOIN cuando consultamos la BD para no
    // hacer múltiples consultas desde el frontend
    private String nombreUsuario;
    // Nombre del tour o paquete reservado
    private String nombreServicio;

    
    public Reserva() {
    }

    public Reserva(Integer id, Integer usuarioId, String tipoServicio,
                   Integer tourId, Integer paqueteId, LocalDate fechaViaje,
                   Integer personas, BigDecimal total, String estado,
                   LocalDateTime createdAt) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.tipoServicio = tipoServicio;
        this.tourId = tourId;
        this.paqueteId = paqueteId;
        this.fechaViaje = fechaViaje;
        this.personas = personas;
        this.total = total;
        this.estado = estado;
        this.createdAt = createdAt;
    }

    /*Indica si la reserva puede cancelarse.
      Solo se puede cancelar si está PENDIENTE o PAGADA.
      Una reserva CONFIRMADA ya no se puede cancelar desde
      el sistema el admin debe intervenir.*/
   
    public boolean isCancelable() {
        return "PENDIENTE".equals(this.estado) || "PAGADA".equals(this.estado);
    }

    public boolean esTour() {
        return "TOUR".equals(this.tipoServicio);
    }
  
    //Devuelve true si la reserva es de un paquete completo.
    public boolean esPaquete() {
        return "PAQUETE".equals(this.tipoServicio);
    }
    

    //GETTERS Y SETTERS

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(Integer usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getTipoServicio() {
        return tipoServicio;
    }

    public void setTipoServicio(String tipoServicio) {
        this.tipoServicio = tipoServicio;
    }

    public Integer getTourId() {
        return tourId;
    }

    public void setTourId(Integer tourId) {
        this.tourId = tourId;
    }

    public Integer getPaqueteId() {
        return paqueteId;
    }

    public void setPaqueteId(Integer paqueteId) {
        this.paqueteId = paqueteId;
    }

    public LocalDate getFechaViaje() {
        return fechaViaje;
    }

    public void setFechaViaje(LocalDate fechaViaje) {
        this.fechaViaje = fechaViaje;
    }

    public Integer getPersonas() {
        return personas;
    }

    public void setPersonas(Integer personas) {
        this.personas = personas;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getNombreServicio() {
        return nombreServicio;
    }

    public void setNombreServicio(String nombreServicio) {
        this.nombreServicio = nombreServicio;
    }
    
    //
    @Override
    public String toString() {
        return "Reserva{" +
               "id=" + id +
               ", usuario='" + nombreUsuario + '\'' +
               ", servicio='" + nombreServicio + '\'' +
               ", fechaViaje=" + fechaViaje +
               ", personas=" + personas +
               ", total=" + total +
               ", estado='" + estado + '\'' +
               '}';
    }
}