package servlet;

import java.io.IOException;
import dao.RegistrarOrdenDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.OrdenTrabajo;

@WebServlet("/VerOrdenServlet")
public class VerOrdenServlet extends HttpServlet {
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
        
        String idOT = request.getParameter("id");
        
        if (idOT == null || idOT.trim().isEmpty()) {
            session.setAttribute("error", "ID de orden inválido");
            response.sendRedirect(request.getContextPath() + "/Vistas/ordenes.jsp");
            return;
        }
        
        try {
            RegistrarOrdenDAO dao = new RegistrarOrdenDAO();
            OrdenTrabajo orden = dao.buscarPorId(idOT);
            
            if (orden != null) {
                request.setAttribute("orden", orden);
                request.getRequestDispatcher("/Vistas/verOrden.jsp").forward(request, response);
            } else {
                session.setAttribute("error", "Orden de trabajo no encontrada");
                response.sendRedirect(request.getContextPath() + "/Vistas/ordenes.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error al cargar la orden: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Vistas/ordenes.jsp");
        }
    }
}