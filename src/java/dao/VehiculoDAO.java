package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Vehiculo;
import util.MySQLConexion;

public class VehiculoDAO {
    
    // Listar todos los vehículos
    public List<Vehiculo> listarVehiculos() {
        List<Vehiculo> lista = new ArrayList<>();
        String sql = "SELECT * FROM VEHICULO ORDER BY ID_Vehiculo DESC";
        
        try (Connection con = MySQLConexion.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                Vehiculo v = new Vehiculo();
                v.setIdVehiculo(rs.getInt("ID_Vehiculo"));
                v.setPlaca(rs.getString("Placa"));
                v.setMarca(rs.getString("Marca"));
                v.setModelo(rs.getString("Modelo"));
                v.setAño(rs.getInt("Año"));
                v.setKilometrajeActual(rs.getInt("Kilometraje_actual"));
                v.setIdTaller(rs.getInt("ID_Taller"));
                lista.add(v);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar vehículos: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
    
    // Buscar vehículo por ID
    public Vehiculo buscarPorId(int id) {
        Vehiculo v = null;
        String sql = "SELECT * FROM VEHICULO WHERE ID_Vehiculo = ?";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                v = new Vehiculo();
                v.setIdVehiculo(rs.getInt("ID_Vehiculo"));
                v.setPlaca(rs.getString("Placa"));
                v.setMarca(rs.getString("Marca"));
                v.setModelo(rs.getString("Modelo"));
                v.setAño(rs.getInt("Año"));
                v.setKilometrajeActual(rs.getInt("Kilometraje_actual"));
                v.setIdTaller(rs.getInt("ID_Taller"));
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar vehículo: " + e.getMessage());
        }
        return v;
    }
    
    // Registrar nuevo vehículo
    public boolean registrar(Vehiculo v) {
        String sql = "INSERT INTO VEHICULO (Placa, Marca, Modelo, Año, Kilometraje_actual, ID_Taller) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, v.getPlaca());
            ps.setString(2, v.getMarca());
            ps.setString(3, v.getModelo());
            ps.setInt(4, v.getAño());
            ps.setInt(5, v.getKilometrajeActual());
            ps.setInt(6, v.getIdTaller());
            
            int filas = ps.executeUpdate();
            return filas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al registrar vehículo: " + e.getMessage());
            return false;
        }
    }
    
    // Actualizar vehículo
    public boolean actualizar(Vehiculo v) {
        String sql = "UPDATE VEHICULO SET Placa=?, Marca=?, Modelo=?, Año=?, Kilometraje_actual=?, ID_Taller=? WHERE ID_Vehiculo=?";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, v.getPlaca());
            ps.setString(2, v.getMarca());
            ps.setString(3, v.getModelo());
            ps.setInt(4, v.getAño());
            ps.setInt(5, v.getKilometrajeActual());
            ps.setInt(6, v.getIdTaller());
            ps.setInt(7, v.getIdVehiculo());
            
            int filas = ps.executeUpdate();
            return filas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al actualizar vehículo: " + e.getMessage());
            return false;
        }
    }
    
    // Eliminar vehículo
    public boolean eliminar(int id) {
        String sql = "DELETE FROM VEHICULO WHERE ID_Vehiculo = ?";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int filas = ps.executeUpdate();
            return filas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al eliminar vehículo: " + e.getMessage());
            return false;
        }
    }
    
    // Listar marcas distintas (para el filtro)
    public List<String> listarMarcas() {
        List<String> marcas = new ArrayList<>();
        String sql = "SELECT DISTINCT Marca FROM VEHICULO ORDER BY Marca";
        
        try (Connection con = MySQLConexion.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                marcas.add(rs.getString("Marca"));
            }
        } catch (SQLException e) {
            System.out.println("Error al listar marcas: " + e.getMessage());
        }
        return marcas;
    }
    
    // Filtrar por marca
    public List<Vehiculo> filtrarPorMarca(String marca) {
        List<Vehiculo> lista = new ArrayList<>();
        String sql = "SELECT * FROM VEHICULO WHERE Marca = ? ORDER BY ID_Vehiculo DESC";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, marca);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Vehiculo v = new Vehiculo();
                v.setIdVehiculo(rs.getInt("ID_Vehiculo"));
                v.setPlaca(rs.getString("Placa"));
                v.setMarca(rs.getString("Marca"));
                v.setModelo(rs.getString("Modelo"));
                v.setAño(rs.getInt("Año"));
                v.setKilometrajeActual(rs.getInt("Kilometraje_actual"));
                v.setIdTaller(rs.getInt("ID_Taller"));
                lista.add(v);
            }
        } catch (SQLException e) {
            System.out.println("Error al filtrar vehículos: " + e.getMessage());
        }
        return lista;
    }
}