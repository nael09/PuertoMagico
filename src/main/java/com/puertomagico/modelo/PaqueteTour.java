package com.puertomagico.modelo;

/*
  Tabla intermedia de la relacion muchos a muchos
  entre Paquete y Tour.
  Un paquete incluye varios tours y un tour
  puede estar en varios paquetes.
  Los campos diaNumero y orden definen en que dia
  del paquete se realiza cada tour y en que secuencia.
 */
public class PaqueteTour {

    private Integer id;
    private Integer paqueteId;
    private Integer tourId;
    // En que dia del paquete se realiza este tour
    private Integer diaNumero;
    // Si hay varios tours el mismo dia, cual va primero
    private Integer orden;
    // Datos adicionales para mostrar en pantalla
    private String nombreTour;
    private String nombrePaquete;

    public PaqueteTour() {}

    public PaqueteTour(Integer id, Integer paqueteId, Integer tourId,
                       Integer diaNumero, Integer orden) {
        this.id = id;
        this.paqueteId = paqueteId;
        this.tourId = tourId;
        this.diaNumero = diaNumero;
        this.orden = orden;
    }

    public Integer getId(){
        return id; 
    }
    public void setId(Integer id) { 
        this.id = id; 
    }

    public Integer getPaqueteId(){ 
        return paqueteId; 
    }
    public void setPaqueteId(Integer p){
        this.paqueteId = p; 
    }

    public Integer getTourId(){ 
        return tourId; 
    }
    public void setTourId(Integer tourId){ 
        this.tourId = tourId;
    }

    public Integer getDiaNumero(){
        return diaNumero; 
    }
    public void setDiaNumero(Integer d){
        this.diaNumero = d; 
    }

    public Integer getOrden(){ 
        return orden;
    }
    public void setOrden(Integer orden){ 
        this.orden = orden;
    }

    public String getNombreTour() { 
        return nombreTour; 
    }
    public void setNombreTour(String n) {
        this.nombreTour = n; 
    }

    public String getNombrePaquete() {
        return nombrePaquete; 
    }
    public void setNombrePaquete(String n){
        this.nombrePaquete = n;
    }

    @Override
    public String toString() {
        return "PaqueteTour{paqueteId=" + paqueteId +
               ", tourId=" + tourId + ", dia=" + diaNumero + "}";
    }
}