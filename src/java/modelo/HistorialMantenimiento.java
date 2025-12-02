package modelo;

import java.sql.Date;

public class HistorialMantenimiento {
    private int idHistorial;
    private int idVehiculo;
    private Date fechaMantenimiento;
    private String tipoMantenimiento;
    private int kilometraje;
    private String descripcion;
    private String detalleTrabajos;
    private String repuestosUsados;
    private double costoManoObra;
    private double costoRepuestos;
    private double costoTotal;
    private int idTecnico;
    private int idOT;
    private String estado;
    private String observaciones;
    
    // Campos adicionales para joins
    private String placaVehiculo;
    private String marcaVehiculo;
    private String modeloVehiculo;
    private String nombreTecnico;
    
    // Constructor vacío
    public HistorialMantenimiento() {
    }
    
    // Constructor completo
    public HistorialMantenimiento(int idHistorial, int idVehiculo, Date fechaMantenimiento, 
                                  String tipoMantenimiento, int kilometraje, String descripcion,
                                  String detalleTrabajos, String repuestosUsados, 
                                  double costoManoObra, double costoRepuestos, double costoTotal,
                                  int idTecnico, int idOT, String estado, String observaciones) {
        this.idHistorial = idHistorial;
        this.idVehiculo = idVehiculo;
        this.fechaMantenimiento = fechaMantenimiento;
        this.tipoMantenimiento = tipoMantenimiento;
        this.kilometraje = kilometraje;
        this.descripcion = descripcion;
        this.detalleTrabajos = detalleTrabajos;
        this.repuestosUsados = repuestosUsados;
        this.costoManoObra = costoManoObra;
        this.costoRepuestos = costoRepuestos;
        this.costoTotal = costoTotal;
        this.idTecnico = idTecnico;
        this.idOT = idOT;
        this.estado = estado;
        this.observaciones = observaciones;
    }

    // Getters y Setters
    public int getIdHistorial() {
        return idHistorial;
    }

    public void setIdHistorial(int idHistorial) {
        this.idHistorial = idHistorial;
    }

    public int getIdVehiculo() {
        return idVehiculo;
    }

    public void setIdVehiculo(int idVehiculo) {
        this.idVehiculo = idVehiculo;
    }

    public Date getFechaMantenimiento() {
        return fechaMantenimiento;
    }

    public void setFechaMantenimiento(Date fechaMantenimiento) {
        this.fechaMantenimiento = fechaMantenimiento;
    }

    public String getTipoMantenimiento() {
        return tipoMantenimiento;
    }

    public void setTipoMantenimiento(String tipoMantenimiento) {
        this.tipoMantenimiento = tipoMantenimiento;
    }

    public int getKilometraje() {
        return kilometraje;
    }

    public void setKilometraje(int kilometraje) {
        this.kilometraje = kilometraje;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getDetalleTrabajos() {
        return detalleTrabajos;
    }

    public void setDetalleTrabajos(String detalleTrabajos) {
        this.detalleTrabajos = detalleTrabajos;
    }

    public String getRepuestosUsados() {
        return repuestosUsados;
    }

    public void setRepuestosUsados(String repuestosUsados) {
        this.repuestosUsados = repuestosUsados;
    }

    public double getCostoManoObra() {
        return costoManoObra;
    }

    public void setCostoManoObra(double costoManoObra) {
        this.costoManoObra = costoManoObra;
    }

    public double getCostoRepuestos() {
        return costoRepuestos;
    }

    public void setCostoRepuestos(double costoRepuestos) {
        this.costoRepuestos = costoRepuestos;
    }

    public double getCostoTotal() {
        return costoTotal;
    }

    public void setCostoTotal(double costoTotal) {
        this.costoTotal = costoTotal;
    }

    public int getIdTecnico() {
        return idTecnico;
    }

    public void setIdTecnico(int idTecnico) {
        this.idTecnico = idTecnico;
    }

    public int getIdOT() {
        return idOT;
    }

    public void setIdOT(int idOT) {
        this.idOT = idOT;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public String getPlacaVehiculo() {
        return placaVehiculo;
    }

    public void setPlacaVehiculo(String placaVehiculo) {
        this.placaVehiculo = placaVehiculo;
    }

    public String getMarcaVehiculo() {
        return marcaVehiculo;
    }

    public void setMarcaVehiculo(String marcaVehiculo) {
        this.marcaVehiculo = marcaVehiculo;
    }

    public String getModeloVehiculo() {
        return modeloVehiculo;
    }

    public void setModeloVehiculo(String modeloVehiculo) {
        this.modeloVehiculo = modeloVehiculo;
    }

    public String getNombreTecnico() {
        return nombreTecnico;
    }

    public void setNombreTecnico(String nombreTecnico) {
        this.nombreTecnico = nombreTecnico;
    }
}