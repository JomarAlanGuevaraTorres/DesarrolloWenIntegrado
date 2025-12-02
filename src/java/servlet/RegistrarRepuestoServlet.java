package servlet;

import java.io.IOException;
import dao.RepuestoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Repuesto;

@WebServlet("/RegistrarRepuestoServlet")
public class RegistrarRepuestoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("eliminar".equals(action)) {
            eliminarRepuesto(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Obtener parámetros del formulario
            String codigo = request.getParameter("codigo");
            String descripcion = request.getParameter("descripcion");
            String categoria = request.getParameter("categoria");
            String unidadMedida = request.getParameter("unidadMedida");
            double precioPromedio = Double.parseDouble(request.getParameter("precioPromedio"));
            int idAlmacen = Integer.parseInt(request.getParameter("idAlmacen"));
            int cantidadActual = Integer.parseInt(request.getParameter("cantidadActual"));
            int stockMinimo = Integer.parseInt(request.getParameter("stockMinimo"));
            int stockMaximo = Integer.parseInt(request.getParameter("stockMaximo"));
            
            // Validar que stock máximo sea mayor que mínimo
            if (stockMaximo <= stockMinimo) {
                response.sendRedirect("Vistas/registrarInsumo.jsp?error=El stock máximo debe ser mayor que el stock mínimo");
                return;
            }
            
            // Crear objeto Repuesto
            Repuesto repuesto = new Repuesto();
            repuesto.setCodigo(codigo);
            repuesto.setDescripcion(descripcion);
            repuesto.setCategoria(categoria);
            repuesto.setUnidadMedida(unidadMedida);
            repuesto.setPrecioPromedio(precioPromedio);
            repuesto.setIdAlmacen(idAlmacen);
            repuesto.setCantidadActual(cantidadActual);
            repuesto.setStockMinimo(stockMinimo);
            repuesto.setStockMaximo(stockMaximo);
            
            // Registrar en la base de datos
            RepuestoDAO repuestoDAO = new RepuestoDAO();
            int resultado = repuestoDAO.registrar(repuesto);
            
            if (resultado > 0) {
                response.sendRedirect("Vistas/almacen.jsp?mensaje=Repuesto registrado exitosamente");
            } else {
                response.sendRedirect("Vistas/registrarInsumo.jsp?error=Error al registrar el repuesto");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("Vistas/registrarInsumo.jsp?error=Error en el formato de los datos numéricos");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Vistas/registrarInsumo.jsp?error=Error al procesar la solicitud: " + e.getMessage());
        }
    }
    
    private void eliminarRepuesto(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            RepuestoDAO repuestoDAO = new RepuestoDAO();
            int resultado = repuestoDAO.eliminar(id);
            
            if (resultado > 0) {
                response.sendRedirect("Vistas/almacen.jsp?mensaje=Repuesto eliminado exitosamente");
            } else {
                response.sendRedirect("Vistas/almacen.jsp?error=No se pudo eliminar el repuesto");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("Vistas/almacen.jsp?error=ID de repuesto inválido");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Vistas/almacen.jsp?error=Error al eliminar: " + e.getMessage());
        }
    }
}