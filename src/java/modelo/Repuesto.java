package modelo;

import java.util.Date;

public class Repuesto {
    private int idRepuesto;
    private String codigo;
    private String descripcion;
    private String categoria;
    private String unidadMedida;
    private double precioPromedio;
    private int idAlmacen;
    private int cantidadActual;
    private int stockMinimo;
    private int stockMaximo;
    private Date ultimaActualizacion;
    
    // Constructor vacío
    public Repuesto() {
    }
    
    // Constructor completo
    public Repuesto(int idRepuesto, String codigo, String descripcion, String categoria, 
                    String unidadMedida, double precioPromedio, int idAlmacen, 
                    int cantidadActual, int stockMinimo, int stockMaximo, Date ultimaActualizacion) {
        this.idRepuesto = idRepuesto;
        this.codigo = codigo;
        this.descripcion = descripcion;
        this.categoria = categoria;
        this.unidadMedida = unidadMedida;
        this.precioPromedio = precioPromedio;
        this.idAlmacen = idAlmacen;
        this.cantidadActual = cantidadActual;
        this.stockMinimo = stockMinimo;
        this.stockMaximo = stockMaximo;
        this.ultimaActualizacion = ultimaActualizacion;
    }
    
    // Getters y Setters
    public int getIdRepuesto() {
        return idRepuesto;
    }
    
    public void setIdRepuesto(int idRepuesto) {
        this.idRepuesto = idRepuesto;
    }
    
    public String getCodigo() {
        return codigo;
    }
    
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    
    public String getCategoria() {
        return categoria;
    }
    
    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }
    
    public String getUnidadMedida() {
        return unidadMedida;
    }
    
    public void setUnidadMedida(String unidadMedida) {
        this.unidadMedida = unidadMedida;
    }
    
    public double getPrecioPromedio() {
        return precioPromedio;
    }
    
    public void setPrecioPromedio(double precioPromedio) {
        this.precioPromedio = precioPromedio;
    }
    
    public int getIdAlmacen() {
        return idAlmacen;
    }
    
    public void setIdAlmacen(int idAlmacen) {
        this.idAlmacen = idAlmacen;
    }
    
    public int getCantidadActual() {
        return cantidadActual;
    }
    
    public void setCantidadActual(int cantidadActual) {
        this.cantidadActual = cantidadActual;
    }
    
    public int getStockMinimo() {
        return stockMinimo;
    }
    
    public void setStockMinimo(int stockMinimo) {
        this.stockMinimo = stockMinimo;
    }
    
    public int getStockMaximo() {
        return stockMaximo;
    }
    
    public void setStockMaximo(int stockMaximo) {
        this.stockMaximo = stockMaximo;
    }
    
    public Date getUltimaActualizacion() {
        return ultimaActualizacion;
    }
    
    public void setUltimaActualizacion(Date ultimaActualizacion) {
        this.ultimaActualizacion = ultimaActualizacion;
    }
    
    // Método para verificar si el stock está bajo
    public boolean stockBajo() {
        return cantidadActual <= stockMinimo;
    }
}