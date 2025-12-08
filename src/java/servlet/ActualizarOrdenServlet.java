package servlet;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import dao.RegistrarOrdenDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.OrdenTrabajo;

@WebServlet("/ActualizarOrdenServlet")
public class ActualizarOrdenServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            String idOT = request.getParameter("idOT");
            int idVehiculo = Integer.parseInt(request.getParameter("idVehiculo"));
            int kilometraje = Integer.parseInt(request.getParameter("kilometrajeActual"));
            String tipo = request.getParameter("tipo");
            String estado = request.getParameter("estado");
            String fechaEmisionStr = request.getParameter("fechaEmision");
            String fechaFinStr = request.getParameter("fechaFin");
            String idTecnicoStr = request.getParameter("idTecnico");
            String diagnostico = request.getParameter("diagnostico");
            String observaciones = request.getParameter("observaciones");
            
            OrdenTrabajo ot = new OrdenTrabajo();
            ot.setIdOT(idOT);
            ot.setIdVehiculo(idVehiculo);
            ot.setKilometraje(kilometraje);
            ot.setTipo(tipo);
            ot.setEstado(estado);
            ot.setDiagnostico(diagnostico);
            ot.setObservaciones(observaciones != null ? observaciones : "");
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            ot.setFechaEmision(sdf.parse(fechaEmisionStr));
            
            if (fechaFinStr != null && !fechaFinStr.trim().isEmpty()) {
                ot.setFechaFin(sdf.parse(fechaFinStr));
            }
            
            if (idTecnicoStr != null && !idTecnicoStr.trim().isEmpty()) {
                ot.setIdTecnico(Integer.parseInt(idTecnicoStr));
            } else {
                ot.setIdTecnico(0);
            }
            
            RegistrarOrdenDAO dao = new RegistrarOrdenDAO();
            boolean actualizado = dao.actualizar(ot);
            
            if (actualizado) {
                session.setAttribute("mensaje", "Orden de trabajo actualizada exitosamente");
                response.sendRedirect(request.getContextPath() + "/Vistas/ordenes.jsp");
            } else {
                session.setAttribute("error", "Error al actualizar la orden de trabajo");
                response.sendRedirect(request.getContextPath() + "/EditarOrdenServlet?id=" + idOT);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error al actualizar: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Vistas/ordenes.jsp");
        }
    }
}