package servlet;

import java.io.IOException;
import dao.ProveedorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/EliminarProveedorServlet")
public class EliminarProveedorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Verificar si el usuario está logueado
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        String idStr = request.getParameter("id");
        
        try {
            if (idStr == null || idStr.isEmpty()) {
                throw new IllegalArgumentException("ID de proveedor no válido");
            }
            
            int id = Integer.parseInt(idStr);
            
            // Crear DAO y eliminar proveedor
            ProveedorDAO proveedorDAO = new ProveedorDAO();
            boolean eliminado = proveedorDAO.eliminar(id);
            
            if (eliminado) {
                session.setAttribute("mensaje", "Proveedor eliminado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "No se pudo eliminar el proveedor");
                session.setAttribute("tipoMensaje", "error");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID de proveedor no válido");
            session.setAttribute("tipoMensaje", "error");
            
        } catch (IllegalArgumentException e) {
            session.setAttribute("mensaje", e.getMessage());
            session.setAttribute("tipoMensaje", "error");
            
        } catch (Exception e) {
            e.printStackTrace();
            
            // Verificar si es un error de clave foránea
            String errorMsg = e.getMessage();
            if (errorMsg != null && (errorMsg.contains("foreign key") || 
                errorMsg.contains("Cannot delete") ||
                errorMsg.contains("constraint"))) {
                session.setAttribute("mensaje", "No se puede eliminar: el proveedor tiene registros asociados (órdenes de compra, etc.)");
            } else {
                session.setAttribute("mensaje", "Error al eliminar el proveedor: " + errorMsg);
            }
            session.setAttribute("tipoMensaje", "error");
        }
        
        // Redirigir de vuelta a la lista de proveedores
        response.sendRedirect(request.getContextPath() + "/Vistas/proveedores.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}