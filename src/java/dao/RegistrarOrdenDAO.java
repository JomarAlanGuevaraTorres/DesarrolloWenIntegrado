package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.OrdenTrabajo;
import util.MySQLConexion;

public class RegistrarOrdenDAO {
    
    // Método para listar todas las órdenes de trabajo
    public List<OrdenTrabajo> listarOrdenes() {
        List<OrdenTrabajo> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT ot.ID_OT, ot.ID_Vehiculo, v.Placa, ot.ID_Tecnico, " +
                        "t.Nombre as NombreTecnico, ot.Tipo, ot.Kilometraje_actual, " +
                        "ot.Estado, ot.Fecha_emision, ot.Fecha_fin, ot.Diagnostico, " +
                        "ot.Observaciones " +
                        "FROM ORDEN_TRABAJO ot " +
                        "LEFT JOIN VEHICULO v ON ot.ID_Vehiculo = v.ID_Vehiculo " +
                        "LEFT JOIN TECNICO t ON ot.ID_Tecnico = t.ID_Tecnico " +
                        "ORDER BY ot.Fecha_emision DESC";
            
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                OrdenTrabajo ot = new OrdenTrabajo();
                ot.setIdOT(rs.getString("ID_OT"));
                ot.setIdVehiculo(rs.getInt("ID_Vehiculo"));
                ot.setPlaca(rs.getString("Placa"));
                ot.setIdTecnico(rs.getInt("ID_Tecnico"));
                ot.setNombreTecnico(rs.getString("NombreTecnico"));
                ot.setTipo(rs.getString("Tipo"));
                ot.setKilometraje(rs.getInt("Kilometraje_actual"));
                ot.setEstado(rs.getString("Estado"));
                ot.setFechaEmision(rs.getDate("Fecha_emision"));
                ot.setFechaFin(rs.getDate("Fecha_fin"));
                ot.setDiagnostico(rs.getString("Diagnostico"));
                ot.setObservaciones(rs.getString("Observaciones"));
                
                lista.add(ot);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar órdenes: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return lista;
    }
    
    // Método para buscar una orden por ID
    public OrdenTrabajo buscarPorId(String idOT) {
        OrdenTrabajo ot = null;
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT ot.ID_OT, ot.ID_Vehiculo, v.Placa, ot.ID_Tecnico, " +
                        "t.Nombre as NombreTecnico, ot.Tipo, ot.Kilometraje_actual, " +
                        "ot.Estado, ot.Fecha_emision, ot.Fecha_fin, ot.Diagnostico, " +
                        "ot.Observaciones " +
                        "FROM ORDEN_TRABAJO ot " +
                        "LEFT JOIN VEHICULO v ON ot.ID_Vehiculo = v.ID_Vehiculo " +
                        "LEFT JOIN TECNICO t ON ot.ID_Tecnico = t.ID_Tecnico " +
                        "WHERE ot.ID_OT = ?";
            
            pst = con.prepareStatement(sql);
            pst.setString(1, idOT);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                ot = new OrdenTrabajo();
                ot.setIdOT(rs.getString("ID_OT"));
                ot.setIdVehiculo(rs.getInt("ID_Vehiculo"));
                ot.setPlaca(rs.getString("Placa"));
                ot.setIdTecnico(rs.getInt("ID_Tecnico"));
                ot.setNombreTecnico(rs.getString("NombreTecnico"));
                ot.setTipo(rs.getString("Tipo"));
                ot.setKilometraje(rs.getInt("Kilometraje_actual"));
                ot.setEstado(rs.getString("Estado"));
                ot.setFechaEmision(rs.getDate("Fecha_emision"));
                ot.setFechaFin(rs.getDate("Fecha_fin"));
                ot.setDiagnostico(rs.getString("Diagnostico"));
                ot.setObservaciones(rs.getString("Observaciones"));
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar orden: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return ot;
    }
    
    // Método para registrar una nueva orden de trabajo
    public boolean registrar(OrdenTrabajo ot) {
        Connection con = null;
        PreparedStatement pst = null;
        boolean resultado = false;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "INSERT INTO ORDEN_TRABAJO (ID_Vehiculo, ID_Tecnico, Tipo, " +
                        "Kilometraje_actual, Estado, Fecha_emision, Fecha_fin, " +
                        "Diagnostico, Observaciones) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pst = con.prepareStatement(sql);
            pst.setInt(1, ot.getIdVehiculo());
            
            // Manejar ID_Tecnico nulo
            if (ot.getIdTecnico() > 0) {
                pst.setInt(2, ot.getIdTecnico());
            } else {
                pst.setNull(2, java.sql.Types.INTEGER);
            }
            
            pst.setString(3, ot.getTipo());
            pst.setInt(4, ot.getKilometraje());
            pst.setString(5, ot.getEstado());
            pst.setDate(6, new java.sql.Date(ot.getFechaEmision().getTime()));
            
            // Manejar Fecha_fin nula
            if (ot.getFechaFin() != null) {
                pst.setDate(7, new java.sql.Date(ot.getFechaFin().getTime()));
            } else {
                pst.setNull(7, java.sql.Types.DATE);
            }
            
            pst.setString(8, ot.getDiagnostico());
            pst.setString(9, ot.getObservaciones());
            
            int filasAfectadas = pst.executeUpdate();
            resultado = filasAfectadas > 0;
            
            if (resultado) {
                // Actualizar el kilometraje del vehículo
                actualizarKilometrajeVehiculo(con, ot.getIdVehiculo(), ot.getKilometraje());
            }
            
        } catch (SQLException e) {
            System.out.println("Error al registrar orden: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }
    
    // Método auxiliar para actualizar el kilometraje del vehículo
    private void actualizarKilometrajeVehiculo(Connection con, int idVehiculo, int kilometraje) {
        PreparedStatement pst = null;
        try {
            String sql = "UPDATE VEHICULO SET Kilometraje_actual = ? WHERE ID_Vehiculo = ?";
            pst = con.prepareStatement(sql);
            pst.setInt(1, kilometraje);
            pst.setInt(2, idVehiculo);
            pst.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al actualizar kilometraje: " + e.getMessage());
        } finally {
            try {
                if (pst != null) pst.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Método para actualizar una orden de trabajo
    public boolean actualizar(OrdenTrabajo ot) {
        Connection con = null;
        PreparedStatement pst = null;
        boolean resultado = false;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "UPDATE ORDEN_TRABAJO SET ID_Vehiculo = ?, ID_Tecnico = ?, " +
                        "Tipo = ?, Kilometraje_actual = ?, Estado = ?, Fecha_emision = ?, " +
                        "Fecha_fin = ?, Diagnostico = ?, Observaciones = ? WHERE ID_OT = ?";
            
            pst = con.prepareStatement(sql);
            pst.setInt(1, ot.getIdVehiculo());
            
            if (ot.getIdTecnico() > 0) {
                pst.setInt(2, ot.getIdTecnico());
            } else {
                pst.setNull(2, java.sql.Types.INTEGER);
            }
            
            pst.setString(3, ot.getTipo());
            pst.setInt(4, ot.getKilometraje());
            pst.setString(5, ot.getEstado());
            pst.setDate(6, new java.sql.Date(ot.getFechaEmision().getTime()));
            
            if (ot.getFechaFin() != null) {
                pst.setDate(7, new java.sql.Date(ot.getFechaFin().getTime()));
            } else {
                pst.setNull(7, java.sql.Types.DATE);
            }
            
            pst.setString(8, ot.getDiagnostico());
            pst.setString(9, ot.getObservaciones());
            pst.setString(10, ot.getIdOT());
            
            int filasAfectadas = pst.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al actualizar orden: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }
    
    // Método para eliminar una orden
    public boolean eliminar(String idOT) {
        Connection con = null;
        PreparedStatement pst = null;
        boolean resultado = false;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "DELETE FROM ORDEN_TRABAJO WHERE ID_OT = ?";
            pst = con.prepareStatement(sql);
            pst.setString(1, idOT);
            
            int filasAfectadas = pst.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al eliminar orden: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }
}