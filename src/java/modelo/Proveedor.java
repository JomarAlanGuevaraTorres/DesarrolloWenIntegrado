package modelo;

public class Proveedor {
    private int idProveedor;
    private String razonSocial;
    private String contacto;
    private String telefono;
    private String email;
    private String direccion;
    private int calificacion;
    private int idAlmacen;
    
    // Constructor vacío
    public Proveedor() {
    }
    
    // Constructor completo
    public Proveedor(int idProveedor, String razonSocial, String contacto, 
                     String telefono, String email, String direccion, 
                     int calificacion, int idAlmacen) {
        this.idProveedor = idProveedor;
        this.razonSocial = razonSocial;
        this.contacto = contacto;
        this.telefono = telefono;
        this.email = email;
        this.direccion = direccion;
        this.calificacion = calificacion;
        this.idAlmacen = idAlmacen;
    }
    
    // Getters y Setters
    public int getIdProveedor() {
        return idProveedor;
    }
    
    public void setIdProveedor(int idProveedor) {
        this.idProveedor = idProveedor;
    }
    
    public String getRazonSocial() {
        return razonSocial;
    }
    
    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }
    
    public String getContacto() {
        return contacto;
    }
    
    public void setContacto(String contacto) {
        this.contacto = contacto;
    }
    
    public String getTelefono() {
        return telefono;
    }
    
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getDireccion() {
        return direccion;
    }
    
    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }
    
    public int getCalificacion() {
        return calificacion;
    }
    
    public void setCalificacion(int calificacion) {
        this.calificacion = calificacion;
    }
    
    public int getIdAlmacen() {
        return idAlmacen;
    }
    
    public void setIdAlmacen(int idAlmacen) {
        this.idAlmacen = idAlmacen;
    }
    
    @Override
    public String toString() {
        return "Proveedor{" +
                "idProveedor=" + idProveedor +
                ", razonSocial='" + razonSocial + '\'' +
                ", contacto='" + contacto + '\'' +
                ", telefono='" + telefono + '\'' +
                ", email='" + email + '\'' +
                ", calificacion=" + calificacion +
                '}';
    }
}