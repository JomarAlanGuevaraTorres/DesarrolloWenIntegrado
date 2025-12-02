package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Proveedor;
import util.MySQLConexion;

public class ProveedorDAO {
    
    // Listar todos los proveedores
    public List<Proveedor> listarProveedores() {
        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT * FROM PROVEEDOR ORDER BY Razon_social";
        
        try (Connection con = MySQLConexion.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                Proveedor p = new Proveedor();
                p.setIdProveedor(rs.getInt("ID_Proveedor"));
                p.setRazonSocial(rs.getString("Razon_social"));
                p.setContacto(rs.getString("Contacto"));
                p.setTelefono(rs.getString("Telefono"));
                p.setEmail(rs.getString("Email"));
                p.setDireccion(rs.getString("Direccion"));
                p.setCalificacion(rs.getInt("Calificacion"));
                p.setIdAlmacen(rs.getInt("ID_Almacen"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar proveedores: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
    
    // Buscar proveedor por ID
    public Proveedor buscarPorId(int id) {
        Proveedor p = null;
        String sql = "SELECT * FROM PROVEEDOR WHERE ID_Proveedor = ?";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                p = new Proveedor();
                p.setIdProveedor(rs.getInt("ID_Proveedor"));
                p.setRazonSocial(rs.getString("Razon_social"));
                p.setContacto(rs.getString("Contacto"));
                p.setTelefono(rs.getString("Telefono"));
                p.setEmail(rs.getString("Email"));
                p.setDireccion(rs.getString("Direccion"));
                p.setCalificacion(rs.getInt("Calificacion"));
                p.setIdAlmacen(rs.getInt("ID_Almacen"));
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar proveedor: " + e.getMessage());
        }
        return p;
    }
    
    // Registrar nuevo proveedor
    public boolean registrar(Proveedor p) {
        String sql = "INSERT INTO PROVEEDOR (Razon_social, Contacto, Telefono, Email, Direccion, Calificacion, ID_Almacen) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, p.getRazonSocial());
            ps.setString(2, p.getContacto());
            ps.setString(3, p.getTelefono());
            ps.setString(4, p.getEmail());
            ps.setString(5, p.getDireccion());
            ps.setInt(6, p.getCalificacion());
            ps.setInt(7, p.getIdAlmacen());
            
            int filas = ps.executeUpdate();
            return filas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al registrar proveedor: " + e.getMessage());
            return false;
        }
    }
    
    // Actualizar proveedor
    public boolean actualizar(Proveedor p) {
        String sql = "UPDATE PROVEEDOR SET Razon_social=?, Contacto=?, Telefono=?, Email=?, Direccion=?, Calificacion=?, ID_Almacen=? WHERE ID_Proveedor=?";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, p.getRazonSocial());
            ps.setString(2, p.getContacto());
            ps.setString(3, p.getTelefono());
            ps.setString(4, p.getEmail());
            ps.setString(5, p.getDireccion());
            ps.setInt(6, p.getCalificacion());
            ps.setInt(7, p.getIdAlmacen());
            ps.setInt(8, p.getIdProveedor());
            
            int filas = ps.executeUpdate();
            return filas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al actualizar proveedor: " + e.getMessage());
            return false;
        }
    }
    
    // Eliminar proveedor
    public boolean eliminar(int id) {
        String sql = "DELETE FROM PROVEEDOR WHERE ID_Proveedor = ?";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int filas = ps.executeUpdate();
            return filas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al eliminar proveedor: " + e.getMessage());
            return false;
        }
    }
    
    // Listar proveedores por almacén
    public List<Proveedor> listarPorAlmacen(int idAlmacen) {
        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT * FROM PROVEEDOR WHERE ID_Almacen = ? ORDER BY Razon_social";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idAlmacen);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Proveedor p = new Proveedor();
                p.setIdProveedor(rs.getInt("ID_Proveedor"));
                p.setRazonSocial(rs.getString("Razon_social"));
                p.setContacto(rs.getString("Contacto"));
                p.setTelefono(rs.getString("Telefono"));
                p.setEmail(rs.getString("Email"));
                p.setDireccion(rs.getString("Direccion"));
                p.setCalificacion(rs.getInt("Calificacion"));
                p.setIdAlmacen(rs.getInt("ID_Almacen"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar proveedores por almacén: " + e.getMessage());
        }
        return lista;
    }
}