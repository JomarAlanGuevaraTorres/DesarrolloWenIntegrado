package servlet;

import java.io.IOException;
import dao.OrdenTrabajoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/EliminarOrdenServlet")
public class EliminarOrdenServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // Obtener ID de la orden a eliminar
        String idOT = request.getParameter("id");
        
        if (idOT == null || idOT.trim().isEmpty()) {
            session.setAttribute("error", "ID de orden inválido");
            response.sendRedirect(request.getContextPath() + "/vistas/ordenes.jsp");
            return;
        }
        
        try {
            OrdenTrabajoDAO dao = new OrdenTrabajoDAO();
            boolean eliminado = dao.eliminar(idOT);
            
            if (eliminado) {
                session.setAttribute("mensaje", "Orden de trabajo eliminada exitosamente");
            } else {
                session.setAttribute("error", "No se pudo eliminar la orden de trabajo");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error al eliminar la orden: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/vistas/ordenes.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}