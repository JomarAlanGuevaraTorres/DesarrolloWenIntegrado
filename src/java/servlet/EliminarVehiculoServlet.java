package servlet;

import java.io.IOException;

import dao.VehiculoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Vistas/EliminarVehiculoServlet")
public class EliminarVehiculoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar sesión
        if (request.getSession().getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            VehiculoDAO dao = new VehiculoDAO();
            
            boolean eliminado = dao.eliminar(id);
            
            if (eliminado) {
                request.getSession().setAttribute("mensaje", "Vehículo eliminado exitosamente");
                request.getSession().setAttribute("tipoMensaje", "success");
            } else {
                request.getSession().setAttribute("mensaje", "Error al eliminar el vehículo");
                request.getSession().setAttribute("tipoMensaje", "error");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "error");
        }
        
        response.sendRedirect("vehiculos.jsp");
    }
}