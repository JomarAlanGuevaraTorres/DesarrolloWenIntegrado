package servlet;

import java.io.IOException;
import dao.VehiculoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Vehiculo;

@WebServlet("/Vistas/RegistrarVehiculoServlet")
public class RegistrarVehiculoServlet extends HttpServlet {
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
            String placa = request.getParameter("placa").toUpperCase().trim();
            String marca = request.getParameter("marca").trim();
            String modelo = request.getParameter("modelo").trim();
            int anio = Integer.parseInt(request.getParameter("anio"));
            int kilometraje = Integer.parseInt(request.getParameter("kilometraje"));
            int idTaller = Integer.parseInt(request.getParameter("idTaller"));
            
            // Validaciones básicas
            if (placa.isEmpty() || marca.isEmpty() || modelo.isEmpty()) {
                request.getSession().setAttribute("mensaje", "Todos los campos son obligatorios");
                request.getSession().setAttribute("tipoMensaje", "error");
                response.sendRedirect("registrarVehiculo.jsp");
                return;
            }
            
            if (anio < 1990 || anio > 2030) {
                request.getSession().setAttribute("mensaje", "El año debe estar entre 1990 y 2030");
                request.getSession().setAttribute("tipoMensaje", "error");
                response.sendRedirect("registrarVehiculo.jsp");
                return;
            }
            
            // Crear objeto Vehículo
            Vehiculo vehiculo = new Vehiculo();
            vehiculo.setPlaca(placa);
            vehiculo.setMarca(marca);
            vehiculo.setModelo(modelo);
            vehiculo.setAño(anio);
            vehiculo.setKilometrajeActual(kilometraje);
            vehiculo.setIdTaller(idTaller);
            
            // Registrar en la base de datos
            VehiculoDAO dao = new VehiculoDAO();
            boolean registrado = dao.registrar(vehiculo);
            
            if (registrado) {
                request.getSession().setAttribute("mensaje", "Vehículo registrado exitosamente");
                request.getSession().setAttribute("tipoMensaje", "success");
                response.sendRedirect("vehiculos.jsp");
            } else {
                request.getSession().setAttribute("mensaje", "Error al registrar el vehículo. La placa puede estar duplicada.");
                request.getSession().setAttribute("tipoMensaje", "error");
                response.sendRedirect("registrarVehiculo.jsp");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensaje", "Error: Los valores numéricos no son válidos");
            request.getSession().setAttribute("tipoMensaje", "error");
            response.sendRedirect("registrarVehiculo.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "error");
            response.sendRedirect("registrarVehiculo.jsp");
        }
    }
}