package servlet;

import java.io.IOException;
import java.util.List;
import dao.OrdenTrabajoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.OrdenTrabajo;

@WebServlet("/ListarOrdenesServlet")
public class ListarOrdenesServlet extends HttpServlet {
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
        
        // Obtener la acción
        String accion = request.getParameter("accion");
        
        if (accion != null && accion.equals("eliminar")) {
            eliminarOrden(request, response);
        } else {
            listarOrdenes(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void listarOrdenes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        OrdenTrabajoDAO dao = new OrdenTrabajoDAO();
        List<OrdenTrabajo> listaOrdenes = dao.listarOrdenes();
        
        // Enviar la lista al JSP
        request.setAttribute("listaOrdenes", listaOrdenes);
        request.getRequestDispatcher("/Vistas/ordenes.jsp").forward(request, response);
    }
    
    private void eliminarOrden(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idOT = request.getParameter("id");
        OrdenTrabajoDAO dao = new OrdenTrabajoDAO();
        
        boolean eliminado = dao.eliminar(idOT);
        
        if (eliminado) {
            request.setAttribute("mensaje", "Orden eliminada exitosamente");
        } else {
            request.setAttribute("error", "Error al eliminar la orden");
        }
        
        // Recargar la lista
        listarOrdenes(request, response);
    }
}