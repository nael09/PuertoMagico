package com.puertomagico.modelo;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

/* Registro del intento de pago asociado a una reserva.
  El pago esta separado de la reserva para que en el futuro
  se pueda conectar con una pasarela real (Stripe, MercadoPago)
  sin modificar la logica de reservas.

  Estados del pago:
    PROCESANDO:se esta intentando cobrar
    APROBADO: cobro exitoso, se genera el voucher QR
    RECHAZADO: fallo el cobro, se liberan los asientos
 */
public class Pago {

    private Integer id;
    private Integer reservaId;
    private BigDecimal monto;
    // "TARJETA", "TRANSFERENCIA" o "EFECTIVO"
    private String metodo;
    private String estado;
    // Folio simulado
    private String referencia;
    // 0 = contado. 3, 6 o 12 para meses sin intereses
    private Integer mesesSinIntereses;
    private LocalDateTime fechaPago;

    public Pago() {}

    public Pago(Integer id, Integer reservaId, BigDecimal monto,
                String metodo, String estado, String referencia,
                Integer mesesSinIntereses, LocalDateTime fechaPago) {
        this.id = id;
        this.reservaId = reservaId;
        this.monto = monto;
        this.metodo = metodo;
        this.estado = estado;
        this.referencia = referencia;
        this.mesesSinIntereses = mesesSinIntereses;
        this.fechaPago = fechaPago;
    }

    /*
      Verifica si el pago fue exitoso.
      Si es true, el sistema genera el voucher QR.
     */
    public boolean isAprobado() {
        return "APROBADO".equals(this.estado);
    }

    /* Crea un folio unico para el pago simulado.
      Ejemplo: PM-2026-A3F8B2
     */
    public String generarReferencia() {
        return "PM-" + java.time.Year.now().getValue() + "-" +
               UUID.randomUUID().toString()
                   .substring(0, 6)
                   .toUpperCase();
    }

    public Integer getId(){
        return id;
    }
    public void setId(Integer id){ 
        this.id = id;
    }
    public Integer getReservaId(){
        return reservaId; }
    public void  setReservaId(Integer r){ 
        this.reservaId = r; 
    }

    public BigDecimal getMonto() {
        return monto;
    }
    public void setMonto(BigDecimal monto){ 
        this.monto = monto;
    }

    public String getMetodo(){ 
        return metodo; 
    }
    public void setMetodo(String metodo){ 
        this.metodo = metodo; 
    }

    public String getEstado(){ 
        return estado; 
    }
    public void setEstado(String estado){ 
        this.estado = estado;
    }

    public String getReferencia(){ 
        return referencia; 
    }
    public void setReferencia(String r){ 
        this.referencia = r;
    }

    public Integer getMesesSinIntereses(){ 
        return mesesSinIntereses;
    }
    public void  setMesesSinIntereses(Integer m){
        this.mesesSinIntereses = m;
    }

    public LocalDateTime getFechaPago(){ 
        return fechaPago;
    }
    public void setFechaPago(LocalDateTime f){ 
        this.fechaPago = f;
    }

    @Override
    public String toString() {
        return "Pago{id=" + id + ", reservaId=" + reservaId +
               ", monto=" + monto + ", estado='" + estado + "'}";
    }
}