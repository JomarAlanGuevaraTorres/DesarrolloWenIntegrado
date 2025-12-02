package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Repuesto;
import util.MySQLConexion;

public class RepuestoDAO {
    
    // Listar todos los repuestos
    public List<Repuesto> listarTodos() {
        List<Repuesto> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT * FROM REPUESTO ORDER BY Descripcion";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Repuesto rep = new Repuesto();
                rep.setIdRepuesto(rs.getInt("ID_Repuesto"));
                rep.setCodigo(rs.getString("Codigo"));
                rep.setDescripcion(rs.getString("Descripcion"));
                rep.setCategoria(rs.getString("Categoria"));
                rep.setUnidadMedida(rs.getString("Unidad_medida"));
                rep.setPrecioPromedio(rs.getDouble("Precio_promedio"));
                rep.setIdAlmacen(rs.getInt("ID_Almacen"));
                rep.setCantidadActual(rs.getInt("Cantidad_actual"));
                rep.setStockMinimo(rs.getInt("Stock_minimo"));
                rep.setStockMaximo(rs.getInt("Stock_maximo"));
                rep.setUltimaActualizacion(rs.getDate("Ultima_actualizacion"));
                lista.add(rep);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar repuestos: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos: " + e.getMessage());
            }
        }
        return lista;
    }
    
    // Registrar un nuevo repuesto
    public int registrar(Repuesto rep) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "INSERT INTO REPUESTO (Codigo, Descripcion, Categoria, Unidad_medida, " +
                        "Precio_promedio, ID_Almacen, Cantidad_actual, Stock_minimo, Stock_maximo, " +
                        "Ultima_actualizacion) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURDATE())";
            ps = con.prepareStatement(sql);
            ps.setString(1, rep.getCodigo());
            ps.setString(2, rep.getDescripcion());
            ps.setString(3, rep.getCategoria());
            ps.setString(4, rep.getUnidadMedida());
            ps.setDouble(5, rep.getPrecioPromedio());
            ps.setInt(6, rep.getIdAlmacen());
            ps.setInt(7, rep.getCantidadActual());
            ps.setInt(8, rep.getStockMinimo());
            ps.setInt(9, rep.getStockMaximo());
            
            resultado = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al registrar repuesto: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos: " + e.getMessage());
            }
        }
        return resultado;
    }
    
    // Obtener un repuesto por ID
    public Repuesto obtenerPorId(int id) {
        Repuesto rep = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT * FROM REPUESTO WHERE ID_Repuesto = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                rep = new Repuesto();
                rep.setIdRepuesto(rs.getInt("ID_Repuesto"));
                rep.setCodigo(rs.getString("Codigo"));
                rep.setDescripcion(rs.getString("Descripcion"));
                rep.setCategoria(rs.getString("Categoria"));
                rep.setUnidadMedida(rs.getString("Unidad_medida"));
                rep.setPrecioPromedio(rs.getDouble("Precio_promedio"));
                rep.setIdAlmacen(rs.getInt("ID_Almacen"));
                rep.setCantidadActual(rs.getInt("Cantidad_actual"));
                rep.setStockMinimo(rs.getInt("Stock_minimo"));
                rep.setStockMaximo(rs.getInt("Stock_maximo"));
                rep.setUltimaActualizacion(rs.getDate("Ultima_actualizacion"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener repuesto: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos: " + e.getMessage());
            }
        }
        return rep;
    }
    
    // Actualizar un repuesto
    public int actualizar(Repuesto rep) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "UPDATE REPUESTO SET Codigo = ?, Descripcion = ?, Categoria = ?, " +
                        "Unidad_medida = ?, Precio_promedio = ?, ID_Almacen = ?, " +
                        "Cantidad_actual = ?, Stock_minimo = ?, Stock_maximo = ?, " +
                        "Ultima_actualizacion = CURDATE() WHERE ID_Repuesto = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, rep.getCodigo());
            ps.setString(2, rep.getDescripcion());
            ps.setString(3, rep.getCategoria());
            ps.setString(4, rep.getUnidadMedida());
            ps.setDouble(5, rep.getPrecioPromedio());
            ps.setInt(6, rep.getIdAlmacen());
            ps.setInt(7, rep.getCantidadActual());
            ps.setInt(8, rep.getStockMinimo());
            ps.setInt(9, rep.getStockMaximo());
            ps.setInt(10, rep.getIdRepuesto());
            
            resultado = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al actualizar repuesto: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos: " + e.getMessage());
            }
        }
        return resultado;
    }
    
    // Eliminar un repuesto
    public int eliminar(int id) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "DELETE FROM REPUESTO WHERE ID_Repuesto = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            resultado = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al eliminar repuesto: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos: " + e.getMessage());
            }
        }
        return resultado;
    }
    
    // Obtener última entrada y salida de un repuesto
    public String[] obtenerUltimoMovimiento(int idRepuesto) {
        String[] movimientos = new String[2]; // [0] = última entrada, [1] = última salida
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            
            // Última entrada
            String sqlEntrada = "SELECT DATE_FORMAT(Fecha, '%d/%m/%Y') as Fecha FROM MOVIMIENTO_ALMACEN " +
                              "WHERE ID_Repuesto = ? AND Tipo = 'ENTRADA' ORDER BY Fecha DESC LIMIT 1";
            ps = con.prepareStatement(sqlEntrada);
            ps.setInt(1, idRepuesto);
            rs = ps.executeQuery();
            movimientos[0] = rs.next() ? rs.getString("Fecha") : "-";
            rs.close();
            ps.close();
            
            // Última salida
            String sqlSalida = "SELECT DATE_FORMAT(Fecha, '%d/%m/%Y') as Fecha FROM MOVIMIENTO_ALMACEN " +
                             "WHERE ID_Repuesto = ? AND Tipo = 'SALIDA' ORDER BY Fecha DESC LIMIT 1";
            ps = con.prepareStatement(sqlSalida);
            ps.setInt(1, idRepuesto);
            rs = ps.executeQuery();
            movimientos[1] = rs.next() ? rs.getString("Fecha") : "-";
            
        } catch (SQLException e) {
            System.out.println("Error al obtener movimientos: " + e.getMessage());
            movimientos[0] = "-";
            movimientos[1] = "-";
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos: " + e.getMessage());
            }
        }
        return movimientos;
    }
}