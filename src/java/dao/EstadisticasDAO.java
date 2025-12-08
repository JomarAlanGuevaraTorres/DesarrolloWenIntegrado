package dao;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import util.MySQLConexion;

public class EstadisticasDAO {
    
    // Obtener tiempo promedio de reparación por técnico
    public Map<String, Double> obtenerTiempoPromedioReparacion() {
        Map<String, Double> estadisticas = new HashMap<>();
        String sql = "SELECT t.Nombre, " +
                    "AVG(DATEDIFF(ot.Fecha_fin, ot.Fecha_emision)) as PromedioHoras " +
                    "FROM ORDEN_TRABAJO ot " +
                    "INNER JOIN TECNICO t ON ot.ID_Tecnico = t.ID_Tecnico " +
                    "WHERE ot.Fecha_fin IS NOT NULL " +
                    "GROUP BY t.ID_Tecnico, t.Nombre " +
                    "ORDER BY PromedioHoras ASC";
        
        try (Connection con = MySQLConexion.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                String tecnico = rs.getString("Nombre");
                double promedio = rs.getDouble("PromedioHoras");
                estadisticas.put(tecnico, promedio);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener tiempo promedio: " + e.getMessage());
        }
        return estadisticas;
    }
    
    // Obtener cumplimiento de mantenimientos preventivos
    public Map<String, Object> obtenerCumplimientoPreventivos() {
        Map<String, Object> resultado = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(*) as Total, " +
                    "SUM(CASE WHEN Estado = 'Completado' THEN 1 ELSE 0 END) as Completados, " +
                    "SUM(CASE WHEN Estado = 'En Proceso' THEN 1 ELSE 0 END) as EnProceso, " +
                    "SUM(CASE WHEN Estado = 'Abierta' THEN 1 ELSE 0 END) as Abiertas " +
                    "FROM ORDEN_TRABAJO " +
                    "WHERE Tipo = 'Mantenimiento Preventivo'";
        
        try (Connection con = MySQLConexion.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            if (rs.next()) {
                int total = rs.getInt("Total");
                int completados = rs.getInt("Completados");
                int enProceso = rs.getInt("EnProceso");
                int abiertas = rs.getInt("Abiertas");
                
                double porcentaje = total > 0 ? (completados * 100.0 / total) : 0;
                
                resultado.put("total", total);
                resultado.put("completados", completados);
                resultado.put("enProceso", enProceso);
                resultado.put("abiertas", abiertas);
                resultado.put("porcentaje", porcentaje);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener cumplimiento: " + e.getMessage());
        }
        return resultado;
    }
    
    // Obtener consumo promedio de insumos por vehículo
    public Map<String, Object> obtenerConsumoInsumos() {
        Map<String, Object> resultado = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(DISTINCT v.ID_Vehiculo) as TotalVehiculos, " +
                    "SUM(h.Costo_repuestos) as TotalRepuestos, " +
                    "AVG(h.Costo_repuestos) as PromedioRepuestos " +
                    "FROM HISTORIAL_MANTENIMIENTO h " +
                    "INNER JOIN VEHICULO v ON h.ID_Vehiculo = v.ID_Vehiculo " +
                    "WHERE h.Fecha_mantenimiento >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)";
        
        try (Connection con = MySQLConexion.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            if (rs.next()) {
                resultado.put("totalVehiculos", rs.getInt("TotalVehiculos"));
                resultado.put("totalRepuestos", rs.getDouble("TotalRepuestos"));
                resultado.put("promedioRepuestos", rs.getDouble("PromedioRepuestos"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener consumo insumos: " + e.getMessage());
        }
        return resultado;
    }
    
    // Obtener nivel de rotación de stock
    public Map<String, Object> obtenerRotacionStock() {
        Map<String, Object> resultado = new HashMap<>();
        
        // Obtener productos con bajo stock
        String sqlBajoStock = "SELECT COUNT(*) as BajoStock " +
                             "FROM REPUESTO " +
                             "WHERE Cantidad_actual <= Stock_minimo";
        
        // Obtener total de productos
        String sqlTotal = "SELECT COUNT(*) as Total, " +
                         "SUM(Cantidad_actual) as StockTotal, " +
                         "AVG(Cantidad_actual) as PromedioStock " +
                         "FROM REPUESTO";
        
        try (Connection con = MySQLConexion.getConexion()) {
            // Consulta bajo stock
            Statement st1 = con.createStatement();
            ResultSet rs1 = st1.executeQuery(sqlBajoStock);
            if (rs1.next()) {
                resultado.put("bajoStock", rs1.getInt("BajoStock"));
            }
            rs1.close();
            st1.close();
            
            // Consulta totales
            Statement st2 = con.createStatement();
            ResultSet rs2 = st2.executeQuery(sqlTotal);
            if (rs2.next()) {
                resultado.put("totalProductos", rs2.getInt("Total"));
                resultado.put("stockTotal", rs2.getInt("StockTotal"));
                resultado.put("promedioStock", rs2.getDouble("PromedioStock"));
            }
            rs2.close();
            st2.close();
            
        } catch (SQLException e) {
            System.out.println("Error al obtener rotación stock: " + e.getMessage());
        }
        return resultado;
    }
    
    // Obtener alertas críticas
    public Map<String, Integer> obtenerAlertasCriticas() {
        Map<String, Integer> alertas = new HashMap<>();
        
        try (Connection con = MySQLConexion.getConexion()) {
            // Vehículos que necesitan mantenimiento
            String sql1 = "SELECT COUNT(*) as Total FROM PLAN_MANTENIMIENTO " +
                         "WHERE Proximo_mantenimiento <= DATE_ADD(CURDATE(), INTERVAL 7 DAY) " +
                         "AND Estado = 'Activo'";
            Statement st1 = con.createStatement();
            ResultSet rs1 = st1.executeQuery(sql1);
            if (rs1.next()) {
                alertas.put("mantenimientosVencidos", rs1.getInt("Total"));
            }
            rs1.close();
            st1.close();
            
            // Órdenes abiertas
            String sql2 = "SELECT COUNT(*) as Total FROM ORDEN_TRABAJO WHERE Estado = 'Abierta'";
            Statement st2 = con.createStatement();
            ResultSet rs2 = st2.executeQuery(sql2);
            if (rs2.next()) {
                alertas.put("ordenesAbiertas", rs2.getInt("Total"));
            }
            rs2.close();
            st2.close();
            
            // Productos bajo stock
            String sql3 = "SELECT COUNT(*) as Total FROM REPUESTO WHERE Cantidad_actual <= Stock_minimo";
            Statement st3 = con.createStatement();
            ResultSet rs3 = st3.executeQuery(sql3);
            if (rs3.next()) {
                alertas.put("productosBajoStock", rs3.getInt("Total"));
            }
            rs3.close();
            st3.close();
            
        } catch (SQLException e) {
            System.out.println("Error al obtener alertas: " + e.getMessage());
        }
        return alertas;
    }
}