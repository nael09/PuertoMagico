package com.puertomagico.modelo;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/*Representa un asiento físico dentro del vehículo asignado
  a un tour específico.
  Esta es la clase más crítica del sistema porque maneja
  el problema de CONCURRENCIA evitar que dos personas
  reserven el mismo asiento al mismo tiempo*/
public class Asiento {
   
    private Integer id;
    private Integer tourId;
    private Integer vehiculoId;
    // ID de la reserva asignada 
    // Se llena cuando alguien completa el pago
    private Integer reservaId;
    // Número o letra del asiento: "1", "2A", "12B"
    // Es lo que se muestra visualmente en el mapa de asientos
    private String numero;
    // Tipo de asiento afecta el precio
    // "ESTANDAR"   precio normal
    // "PREMIUM"    precio mayor, mejor ubicación
    // "ACCESIBLE"  para personas con movilidad reducida
    private String tipo;
    private BigDecimal precioExtra;
    // Estado actual del asiento en tiempo real
    private String estado;
    // Fecha y hora hasta cuando está bloqueado
    // Solo tiene valor cuando estado = "EN_PROCESO"
    // Ejemplo: si alguien lo seleccionó a las 14:00,
    // bloqueadoHasta = 14:10 (10 minutos después)
    // Si a las 14:10 no pagó, el DAO lo libera automáticamente
    private LocalDateTime bloqueadoHasta;

    
    public Asiento() {
    }

    public Asiento(Integer id, Integer tourId, Integer vehiculoId,
                   Integer reservaId, String numero, String tipo,
                   BigDecimal precioExtra, String estado,
                   LocalDateTime bloqueadoHasta) {
        this.id = id;
        this.tourId = tourId;
        this.vehiculoId = vehiculoId;
        this.reservaId = reservaId;
        this.numero = numero;
        this.tipo = tipo;
        this.precioExtra = precioExtra;
        this.estado = estado;
        this.bloqueadoHasta = bloqueadoHasta;
    }

  
    /*Devuelve true si el asiento se puede reservar.
      Este método lo usamos en el Servlet ANTES de intentar
      bloquear el asiento  si no está disponible, le decimos
      al cliente que elija otro.*/
    public boolean isDisponible() {
        return "DISPONIBLE".equals(this.estado);
    }

      //Devuelve true si alguien más está pagando este asiento.
      //En el mapa visual se muestra en amarillo 
     
    public boolean isEnProceso() {
        return "EN_PROCESO".equals(this.estado);
    }

    
      //Devuelve true si el asiento ya fue pagado.
      //En el mapa visual se muestra en rojo no se puede tocar.
     
    public boolean isReservado() {
        return "RESERVADO".equals(this.estado) || "CONFIRMADO".equals(this.estado);
    }

    /*Cambia el estado a EN_PROCESO y establece el tiempo
      de expiración del bloqueo (10 minutos desde ahora).
      
      Este método se llama cuando el cliente hace clic en
      un asiento disponible y avanza al formulario de pago.
      
      Aunque cambiamos el estado aquí en Java,
      el cambio real se guarda en la BD desde el DAO usando
      una operación (SELECT FOR UPDATE) que garantiza
      que solo un usuario puede bloquear el asiento a la vez.
     */
    public void bloquear() {
        this.estado = "EN_PROCESO";
        this.bloqueadoHasta = LocalDateTime.now().plusMinutes(10);
    }
    
    /*Regresa el asiento a DISPONIBLE.
      Se llama cuando:
        1.El pago falló o fue rechazado
        2.El cliente canceló el proceso
        3.Detectó que bloqueadoHasta ya expiró*/
    
    public void liberar() {
        this.estado = "DISPONIBLE";
        this.bloqueadoHasta = null;  // null = sin tiempo de expiración
        this.reservaId = null;  // null = sin reserva asignada
    }

    /*Marca el asiento como RESERVADO cuando el pago es exitoso.
      A partir de este momento el asiento ya no se puede liberar
      automáticamente solo el admin puede cancelarlo.*/
    public void confirmar(Integer reservaId) {
        this.estado = "RESERVADO";
        this.reservaId = reservaId;
        this.bloqueadoHasta = null; // Ya no necesita tiempo de expiración
    }

    /*
      Verifica si el tiempo de bloqueo ya venció
      Lo usa el DAO para identificar asientos que hay que liberar.
     */
    public boolean bloqueadoExpirado() {
        // Si no hay fecha de bloqueo, no está expirado
        if (this.bloqueadoHasta == null) return false;
        // isAfter = compara si ahora es posterior al tiempo de bloqueo
        return LocalDateTime.now().isAfter(this.bloqueadoHasta);
    }

    
    // GETTERS Y SETTERS

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getTourId() {
        return tourId;
    }

    public void setTourId(Integer tourId) {
        this.tourId = tourId;
    }

    public Integer getVehiculoId() {
        return vehiculoId;
    }

    public void setVehiculoId(Integer vehiculoId) {
        this.vehiculoId = vehiculoId;
    }

    public Integer getReservaId() {
        return reservaId;
    }

    public void setReservaId(Integer reservaId) {
        this.reservaId = reservaId;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public BigDecimal getPrecioExtra() {
        return precioExtra;
    }

    public void setPrecioExtra(BigDecimal precioExtra) {
        this.precioExtra = precioExtra;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public LocalDateTime getBloqueadoHasta() {
        return bloqueadoHasta;
    }

    public void setBloqueadoHasta(LocalDateTime bloqueadoHasta) {
        this.bloqueadoHasta = bloqueadoHasta;
    }

    
    @Override
    public String toString() {
        return "Asiento{" +
               "id=" + id +
               ", numero='" + numero + '\'' +
               ", tipo='" + tipo + '\'' +
               ", estado='" + estado + '\'' +
               ", bloqueadoHasta=" + bloqueadoHasta +
               '}';
    }
}