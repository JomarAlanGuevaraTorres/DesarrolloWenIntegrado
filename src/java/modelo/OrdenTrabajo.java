package modelo;

import java.util.Date;

public class OrdenTrabajo {
    private String idOT;
    private int idVehiculo;
    private String placa;
    private int idTecnico;
    private String nombreTecnico;
    private String tipo;
    private int kilometraje;
    private String estado;
    private Date fechaEmision;
    private Date fechaFin;
    private String diagnostico;
    private String observaciones;
    
    // Constructor vacío
    public OrdenTrabajo() {
    }
    
    // Constructor completo
    public OrdenTrabajo(String idOT, int idVehiculo, String placa, int idTecnico, 
                       String nombreTecnico, String tipo, int kilometraje, String estado,
                       Date fechaEmision, Date fechaFin, String diagnostico, String observaciones) {
        this.idOT = idOT;
        this.idVehiculo = idVehiculo;
        this.placa = placa;
        this.idTecnico = idTecnico;
        this.nombreTecnico = nombreTecnico;
        this.tipo = tipo;
        this.kilometraje = kilometraje;
        this.estado = estado;
        this.fechaEmision = fechaEmision;
        this.fechaFin = fechaFin;
        this.diagnostico = diagnostico;
        this.observaciones = observaciones;
    }
    
    // Getters y Setters
    public String getIdOT() {
        return idOT;
    }
    
    public void setIdOT(String idOT) {
        this.idOT = idOT;
    }
    
    public int getIdVehiculo() {
        return idVehiculo;
    }
    
    public void setIdVehiculo(int idVehiculo) {
        this.idVehiculo = idVehiculo;
    }
    
    public String getPlaca() {
        return placa;
    }
    
    public void setPlaca(String placa) {
        this.placa = placa;
    }
    
    public int getIdTecnico() {
        return idTecnico;
    }
    
    public void setIdTecnico(int idTecnico) {
        this.idTecnico = idTecnico;
    }
    
    public String getNombreTecnico() {
        return nombreTecnico;
    }
    
    public void setNombreTecnico(String nombreTecnico) {
        this.nombreTecnico = nombreTecnico;
    }
    
    public String getTipo() {
        return tipo;
    }
    
    public void setTipo(String tipo) {
        this.tipo = tipo;
    }
    
    public int getKilometraje() {
        return kilometraje;
    }
    
    public void setKilometraje(int kilometraje) {
        this.kilometraje = kilometraje;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public Date getFechaEmision() {
        return fechaEmision;
    }
    
    public void setFechaEmision(Date fechaEmision) {
        this.fechaEmision = fechaEmision;
    }
    
    public Date getFechaFin() {
        return fechaFin;
    }
    
    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }
    
    public String getDiagnostico() {
        return diagnostico;
    }
    
    public void setDiagnostico(String diagnostico) {
        this.diagnostico = diagnostico;
    }
    
    public String getObservaciones() {
        return observaciones;
    }
    
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
}