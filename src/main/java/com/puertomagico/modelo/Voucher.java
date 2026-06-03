package com.puertomagico.modelo;

import java.time.LocalDateTime;

/*
  Boleto digital generado cuando el pago es aprobado.
 
  El voucher contiene un codigo QR unico que el guia
  escanea al inicio del tour para validar la asistencia.
 
  Estados del voucher:
    GENERADO -> se creo correctamente, no usado aun
    USADO    -> el guia ya lo escaneo
    VENCIDO  -> la fecha del tour paso sin escanearse
 */
public class Voucher {

    private Integer id;
    private Integer reservaId;
    // Folio unico que se codifica en la imagen QR
    private String codigoQr;
    private String estado;
    private LocalDateTime generadoAt;
    // Se llena cuando el guia escanea el QR
    private LocalDateTime escaneadoAt;

    public Voucher() {}

    public Voucher(Integer id, Integer reservaId, String codigoQr,
                   String estado, LocalDateTime generadoAt,
                   LocalDateTime escaneadoAt) {
        this.id = id;
        this.reservaId = reservaId;
        this.codigoQr = codigoQr;
        this.estado = estado;
        this.generadoAt = generadoAt;
        this.escaneadoAt = escaneadoAt;
    }

    /*
      Verifica si el voucher ya fue escaneado por el guia.
      Evita que el mismo QR se use dos veces.
     */
    public boolean isUsado() {
        return "USADO".equals(this.estado);
    }

    /*
      Verifica si el voucher ya expiro.
      lo marca como VENCIDO si la fecha
      del tour paso sin que el guia lo escaneara.
     */
    public boolean isVencido() {
        return "VENCIDO".equals(this.estado);
    }

    /*
      Cambia el estado a USADO y registra la hora del escaneo.
      Se llama cuando el guia valida el voucher en el tour.
     */
    public void marcarComoUsado() {
        this.estado = "USADO";
        this.escaneadoAt = LocalDateTime.now();
    }

    public Integer getId(){
        return id;
    }
    public void setId(Integer id){ 
        this.id = id; 
    }

    public Integer getReservaId(){ 
        return reservaId; 
    }
    public void setReservaId(Integer r){ 
        this.reservaId = r;
    }

    public String getCodigoQr(){ 
        return codigoQr;
    }
    public void setCodigoQr(String c){ 
        this.codigoQr = c; 
    }

    public String getEstado(){
        return estado; 
    }
    public void setEstado(String estado){ 
        this.estado = estado;
    }

    public LocalDateTime getGeneradoAt(){
        return generadoAt; 
    }
    public void setGeneradoAt(LocalDateTime g) { 
        this.generadoAt = g; 
    }

    public LocalDateTime getEscaneadoAt(){ 
        return escaneadoAt; 
    }
    public void setEscaneadoAt(LocalDateTime e){
        this.escaneadoAt = e; 
    }

    @Override
    public String toString() {
        return "Voucher{id=" + id + ", codigo='" + codigoQr +
               "', estado='" + estado + "'}";
    }
}