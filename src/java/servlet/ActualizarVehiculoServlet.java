package servlet;

import java.io.IOException;
import dao.VehiculoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Vehiculo;

@WebServlet("/Vistas/ActualizarVehiculoServlet")
public class ActualizarVehiculoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar sesión
        if (request.getSession().getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // Configurar encoding
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Obtener datos del formulario
            int id = Integer.parseInt(request.getParameter("id"));
            String marca = request.getParameter("marca").trim();
            String modelo = request.getParameter("modelo").trim();
            int anio = Integer.parseInt(request.getParameter("anio"));
            int kilometraje = Integer.parseInt(request.getParameter("kilometraje"));
            int idTaller = Integer.parseInt(request.getParameter("idTaller"));
            
            // Validaciones básicas
            if (marca.isEmpty() || modelo.isEmpty()) {
                request.getSession().setAttribute("mensaje", "Todos los campos son obligatorios");
                request.getSession().setAttribute("tipoMensaje", "error");
                response.sendRedirect("editarVehiculo.jsp?id=" + id);
                return;
            }
            
            if (anio < 1990 || anio > 2030) {
                request.getSession().setAttribute("mensaje", "El año debe estar entre 1990 y 2030");
                request.getSession().setAttribute("tipoMensaje", "error");
                response.sendRedirect("editarVehiculo.jsp?id=" + id);
                return;
            }
            
            if (kilometraje < 0) {
                request.getSession().setAttribute("mensaje", "El kilometraje no puede ser negativo");
                request.getSession().setAttribute("tipoMensaje", "error");
                response.sendRedirect("editarVehiculo.jsp?id=" + id);
                return;
            }
            
            // Obtener el vehículo actual para conservar la placa
            VehiculoDAO dao = new VehiculoDAO();
            Vehiculo vehiculoActual = dao.buscarPorId(id);
            
            if (vehiculoActual == null) {
                request.getSession().setAttribute("mensaje", "Vehículo no encontrado");
                request.getSession().setAttribute("tipoMensaje", "error");
                response.sendRedirect("vehiculos.jsp");
                return;
            }
            
            // Crear objeto Vehículo con datos actualizados
            Vehiculo vehiculo = new Vehiculo();
            vehiculo.setIdVehiculo(id);
            vehiculo.setPlaca(vehiculoActual.getPlaca()); // Mantener la placa original
            vehiculo.setMarca(marca);
            vehiculo.setModelo(modelo);
            vehiculo.setAño(anio);
            vehiculo.setKilometrajeActual(kilometraje);
            vehiculo.setIdTaller(idTaller);
            
            // Actualizar en la base de datos
            boolean actualizado = dao.actualizar(vehiculo);
            
            if (actualizado) {
                request.getSession().setAttribute("mensaje", "Vehículo actualizado exitosamente");
                request.getSession().setAttribute("tipoMensaje", "success");
                response.sendRedirect("vehiculos.jsp");
            } else {
                request.getSession().setAttribute("mensaje", "Error al actualizar el vehículo");
                request.getSession().setAttribute("tipoMensaje", "error");
                response.sendRedirect("editarVehiculo.jsp?id=" + id);
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensaje", "Error: Los valores numéricos no son válidos");
            request.getSession().setAttribute("tipoMensaje", "error");
            response.sendRedirect("vehiculos.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "error");
            response.sendRedirect("vehiculos.jsp");
        }
    }
}