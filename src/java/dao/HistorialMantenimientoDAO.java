package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.HistorialMantenimiento;
import util.MySQLConexion;

public class HistorialMantenimientoDAO {
    
    // Listar historial completo de un vehículo
    public List<HistorialMantenimiento> listarPorVehiculo(int idVehiculo) {
        List<HistorialMantenimiento> lista = new ArrayList<>();
        String sql = "SELECT h.*, v.Placa, v.Marca, v.Modelo, t.Nombre AS NombreTecnico " +
                     "FROM HISTORIAL_MANTENIMIENTO h " +
                     "INNER JOIN VEHICULO v ON h.ID_Vehiculo = v.ID_Vehiculo " +
                     "LEFT JOIN TECNICO t ON h.ID_Tecnico = t.ID_Tecnico " +
                     "WHERE h.ID_Vehiculo = ? " +
                     "ORDER BY h.Fecha_mantenimiento DESC";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idVehiculo);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                HistorialMantenimiento h = new HistorialMantenimiento();
                h.setIdHistorial(rs.getInt("ID_Historial"));
                h.setIdVehiculo(rs.getInt("ID_Vehiculo"));
                h.setFechaMantenimiento(rs.getDate("Fecha_mantenimiento"));
                h.setTipoMantenimiento(rs.getString("Tipo_mantenimiento"));
                h.setKilometraje(rs.getInt("Kilometraje"));
                h.setDescripcion(rs.getString("Descripcion"));
                h.setDetalleTrabajos(rs.getString("Detalle_trabajos"));
                h.setRepuestosUsados(rs.getString("Repuestos_usados"));
                h.setCostoManoObra(rs.getDouble("Costo_mano_obra"));
                h.setCostoRepuestos(rs.getDouble("Costo_repuestos"));
                h.setCostoTotal(rs.getDouble("Costo_total"));
                h.setIdTecnico(rs.getInt("ID_Tecnico"));
                h.setIdOT(rs.getInt("ID_OT"));
                h.setEstado(rs.getString("Estado"));
                h.setObservaciones(rs.getString("Observaciones"));
                
                // Datos del vehículo
                h.setPlacaVehiculo(rs.getString("Placa"));
                h.setMarcaVehiculo(rs.getString("Marca"));
                h.setModeloVehiculo(rs.getString("Modelo"));
                h.setNombreTecnico(rs.getString("NombreTecnico"));
                
                lista.add(h);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar historial: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
    
    // Listar todo el historial
    public List<HistorialMantenimiento> listarTodo() {
        List<HistorialMantenimiento> lista = new ArrayList<>();
        String sql = "SELECT h.*, v.Placa, v.Marca, v.Modelo, t.Nombre AS NombreTecnico " +
                     "FROM HISTORIAL_MANTENIMIENTO h " +
                     "INNER JOIN VEHICULO v ON h.ID_Vehiculo = v.ID_Vehiculo " +
                     "LEFT JOIN TECNICO t ON h.ID_Tecnico = t.ID_Tecnico " +
                     "ORDER BY h.Fecha_mantenimiento DESC";
        
        try (Connection con = MySQLConexion.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                HistorialMantenimiento h = new HistorialMantenimiento();
                h.setIdHistorial(rs.getInt("ID_Historial"));
                h.setIdVehiculo(rs.getInt("ID_Vehiculo"));
                h.setFechaMantenimiento(rs.getDate("Fecha_mantenimiento"));
                h.setTipoMantenimiento(rs.getString("Tipo_mantenimiento"));
                h.setKilometraje(rs.getInt("Kilometraje"));
                h.setDescripcion(rs.getString("Descripcion"));
                h.setDetalleTrabajos(rs.getString("Detalle_trabajos"));
                h.setRepuestosUsados(rs.getString("Repuestos_usados"));
                h.setCostoManoObra(rs.getDouble("Costo_mano_obra"));
                h.setCostoRepuestos(rs.getDouble("Costo_repuestos"));
                h.setCostoTotal(rs.getDouble("Costo_total"));
                h.setIdTecnico(rs.getInt("ID_Tecnico"));
                h.setIdOT(rs.getInt("ID_OT"));
                h.setEstado(rs.getString("Estado"));
                h.setObservaciones(rs.getString("Observaciones"));
                
                h.setPlacaVehiculo(rs.getString("Placa"));
                h.setMarcaVehiculo(rs.getString("Marca"));
                h.setModeloVehiculo(rs.getString("Modelo"));
                h.setNombreTecnico(rs.getString("NombreTecnico"));
                
                lista.add(h);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar todo el historial: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
    
    // Buscar por ID
    public HistorialMantenimiento buscarPorId(int id) {
        HistorialMantenimiento h = null;
        String sql = "SELECT h.*, v.Placa, v.Marca, v.Modelo, t.Nombre AS NombreTecnico " +
                     "FROM HISTORIAL_MANTENIMIENTO h " +
                     "INNER JOIN VEHICULO v ON h.ID_Vehiculo = v.ID_Vehiculo " +
                     "LEFT JOIN TECNICO t ON h.ID_Tecnico = t.ID_Tecnico " +
                     "WHERE h.ID_Historial = ?";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                h = new HistorialMantenimiento();
                h.setIdHistorial(rs.getInt("ID_Historial"));
                h.setIdVehiculo(rs.getInt("ID_Vehiculo"));
                h.setFechaMantenimiento(rs.getDate("Fecha_mantenimiento"));
                h.setTipoMantenimiento(rs.getString("Tipo_mantenimiento"));
                h.setKilometraje(rs.getInt("Kilometraje"));
                h.setDescripcion(rs.getString("Descripcion"));
                h.setDetalleTrabajos(rs.getString("Detalle_trabajos"));
                h.setRepuestosUsados(rs.getString("Repuestos_usados"));
                h.setCostoManoObra(rs.getDouble("Costo_mano_obra"));
                h.setCostoRepuestos(rs.getDouble("Costo_repuestos"));
                h.setCostoTotal(rs.getDouble("Costo_total"));
                h.setIdTecnico(rs.getInt("ID_Tecnico"));
                h.setIdOT(rs.getInt("ID_OT"));
                h.setEstado(rs.getString("Estado"));
                h.setObservaciones(rs.getString("Observaciones"));
                
                h.setPlacaVehiculo(rs.getString("Placa"));
                h.setMarcaVehiculo(rs.getString("Marca"));
                h.setModeloVehiculo(rs.getString("Modelo"));
                h.setNombreTecnico(rs.getString("NombreTecnico"));
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar historial: " + e.getMessage());
        }
        return h;
    }
    
    // Registrar nuevo mantenimiento
    public boolean registrar(HistorialMantenimiento h) {
        String sql = "INSERT INTO HISTORIAL_MANTENIMIENTO " +
                     "(ID_Vehiculo, Fecha_mantenimiento, Tipo_mantenimiento, Kilometraje, " +
                     "Descripcion, Detalle_trabajos, Repuestos_usados, Costo_mano_obra, " +
                     "Costo_repuestos, Costo_total, ID_Tecnico, ID_OT, Estado, Observaciones) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, h.getIdVehiculo());
            ps.setDate(2, h.getFechaMantenimiento());
            ps.setString(3, h.getTipoMantenimiento());
            ps.setInt(4, h.getKilometraje());
            ps.setString(5, h.getDescripcion());
            ps.setString(6, h.getDetalleTrabajos());
            ps.setString(7, h.getRepuestosUsados());
            ps.setDouble(8, h.getCostoManoObra());
            ps.setDouble(9, h.getCostoRepuestos());
            ps.setDouble(10, h.getCostoTotal());
            
            if (h.getIdTecnico() > 0) {
                ps.setInt(11, h.getIdTecnico());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            
            if (h.getIdOT() > 0) {
                ps.setInt(12, h.getIdOT());
            } else {
                ps.setNull(12, Types.INTEGER);
            }
            
            ps.setString(13, h.getEstado());
            ps.setString(14, h.getObservaciones());
            
            int filas = ps.executeUpdate();
            return filas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al registrar mantenimiento: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Obtener estadísticas de costos por vehículo
    public double obtenerCostoTotalVehiculo(int idVehiculo) {
        String sql = "SELECT SUM(Costo_total) AS Total FROM HISTORIAL_MANTENIMIENTO WHERE ID_Vehiculo = ?";
        double total = 0.0;
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idVehiculo);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getDouble("Total");
            }
        } catch (SQLException e) {
            System.out.println("Error al calcular costo total: " + e.getMessage());
        }
        return total;
    }
    
    // Contar mantenimientos por tipo
    public int contarPorTipo(int idVehiculo, String tipo) {
        String sql = "SELECT COUNT(*) AS Total FROM HISTORIAL_MANTENIMIENTO " +
                     "WHERE ID_Vehiculo = ? AND Tipo_mantenimiento = ?";
        int total = 0;
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idVehiculo);
            ps.setString(2, tipo);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("Total");
            }
        } catch (SQLException e) {
            System.out.println("Error al contar mantenimientos: " + e.getMessage());
        }
        return total;
    }
    
    // Obtener último mantenimiento
    public HistorialMantenimiento obtenerUltimo(int idVehiculo) {
        String sql = "SELECT h.*, v.Placa, v.Marca, v.Modelo, t.Nombre AS NombreTecnico " +
                     "FROM HISTORIAL_MANTENIMIENTO h " +
                     "INNER JOIN VEHICULO v ON h.ID_Vehiculo = v.ID_Vehiculo " +
                     "LEFT JOIN TECNICO t ON h.ID_Tecnico = t.ID_Tecnico " +
                     "WHERE h.ID_Vehiculo = ? " +
                     "ORDER BY h.Fecha_mantenimiento DESC LIMIT 1";
        
        HistorialMantenimiento h = null;
        
        try (Connection con = MySQLConexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idVehiculo);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                h = new HistorialMantenimiento();
                h.setIdHistorial(rs.getInt("ID_Historial"));
                h.setIdVehiculo(rs.getInt("ID_Vehiculo"));
                h.setFechaMantenimiento(rs.getDate("Fecha_mantenimiento"));
                h.setTipoMantenimiento(rs.getString("Tipo_mantenimiento"));
                h.setKilometraje(rs.getInt("Kilometraje"));
                h.setDescripcion(rs.getString("Descripcion"));
                h.setCostoTotal(rs.getDouble("Costo_total"));
                h.setPlacaVehiculo(rs.getString("Placa"));
                h.setNombreTecnico(rs.getString("NombreTecnico"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener último mantenimiento: " + e.getMessage());
        }
        return h;
    }
}