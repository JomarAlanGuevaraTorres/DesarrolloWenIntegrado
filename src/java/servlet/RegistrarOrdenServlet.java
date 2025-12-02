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

@WebServlet("/RegistrarOrdenServlet")
public class RegistrarOrdenServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // Configurar encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Obtener parámetros del formulario
            String idVehiculoStr = request.getParameter("idVehiculo");
            String kilometrajeStr = request.getParameter("kilometrajeActual");
            String tipo = request.getParameter("tipo");
            String estado = request.getParameter("estado");
            String fechaEmisionStr = request.getParameter("fechaEmision");
            String fechaFinStr = request.getParameter("fechaFin");
            String idTecnicoStr = request.getParameter("idTecnico");
            String diagnostico = request.getParameter("diagnostico");
            String observaciones = request.getParameter("observaciones");
            
            // Validar campos obligatorios
            if (idVehiculoStr == null || idVehiculoStr.trim().isEmpty() ||
                kilometrajeStr == null || kilometrajeStr.trim().isEmpty() ||
                tipo == null || tipo.trim().isEmpty() ||
                estado == null || estado.trim().isEmpty() ||
                fechaEmisionStr == null || fechaEmisionStr.trim().isEmpty() ||
                diagnostico == null || diagnostico.trim().isEmpty()) {
                
                request.setAttribute("error", "Todos los campos obligatorios deben ser completados");
                request.getRequestDispatcher("/vistas/registrarOrden.jsp").forward(request, response);
                return;
            }
            
            // Crear objeto OrdenTrabajo
            OrdenTrabajo ot = new OrdenTrabajo();
            
            // Convertir y setear valores
            ot.setIdVehiculo(Integer.parseInt(idVehiculoStr));
            ot.setKilometraje(Integer.parseInt(kilometrajeStr));
            ot.setTipo(tipo);
            ot.setEstado(estado);
            ot.setDiagnostico(diagnostico);
            ot.setObservaciones(observaciones != null ? observaciones : "");
            
            // Convertir fechas
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date fechaEmision = sdf.parse(fechaEmisionStr);
            ot.setFechaEmision(fechaEmision);
            
            // Fecha fin (opcional)
            if (fechaFinStr != null && !fechaFinStr.trim().isEmpty()) {
                Date fechaFin = sdf.parse(fechaFinStr);
                ot.setFechaFin(fechaFin);
            }
            
            // ID Técnico (opcional)
            if (idTecnicoStr != null && !idTecnicoStr.trim().isEmpty()) {
                ot.setIdTecnico(Integer.parseInt(idTecnicoStr));
            } else {
                ot.setIdTecnico(0); // Indica que no hay técnico asignado
            }
            
            // Registrar en la base de datos
            RegistrarOrdenDAO dao = new RegistrarOrdenDAO();
            boolean registrado = dao.registrar(ot);
            
            if (registrado) {
                // Éxito - redirigir con mensaje
                session.setAttribute("mensaje", "Orden de trabajo registrada exitosamente");
                response.sendRedirect(request.getContextPath() + "/vistas/ordenes.jsp");
            } else {
                // Error al registrar
                request.setAttribute("error", "Error al registrar la orden de trabajo. Intente nuevamente.");
                request.getRequestDispatcher("/vistas/registrarOrden.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error en los datos numéricos ingresados: " + e.getMessage());
            request.getRequestDispatcher("/vistas/registrarOrden.jsp").forward(request, response);
            
        } catch (ParseException e) {
            request.setAttribute("error", "Error en el formato de las fechas: " + e.getMessage());
            request.getRequestDispatcher("/vistas/registrarOrden.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error inesperado: " + e.getMessage());
            request.getRequestDispatcher("/vistas/registrarOrden.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirigir al formulario si se accede por GET
        response.sendRedirect(request.getContextPath() + "/vistas/registrarOrden.jsp");
    }
}