package servlet;

import java.io.IOException;
import dao.ProveedorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Proveedor;

@WebServlet("/RegistrarProveedorServlet")
public class RegistrarProveedorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Verificar si el usuario está logueado
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // Configurar encoding
        request.setCharacterEncoding("UTF-8");
        
        // Obtener parámetros del formulario
        String razonSocial = request.getParameter("razonSocial");
        String contacto = request.getParameter("contacto");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String direccion = request.getParameter("direccion");
        String calificacionStr = request.getParameter("calificacion");
        String idAlmacenStr = request.getParameter("idAlmacen");
        
        try {
            // Validar datos
            if (razonSocial == null || razonSocial.trim().isEmpty()) {
                throw new IllegalArgumentException("La razón social es obligatoria");
            }
            
            int calificacion = 0;
            if (calificacionStr != null && !calificacionStr.isEmpty()) {
                calificacion = Integer.parseInt(calificacionStr);
                if (calificacion < 0 || calificacion > 5) {
                    throw new IllegalArgumentException("La calificación debe estar entre 0 y 5");
                }
            }
            
            int idAlmacen = Integer.parseInt(idAlmacenStr);
            
            // Crear objeto Proveedor
            Proveedor proveedor = new Proveedor();
            proveedor.setRazonSocial(razonSocial.trim());
            proveedor.setContacto(contacto != null ? contacto.trim() : "");
            proveedor.setTelefono(telefono != null ? telefono.trim() : "");
            proveedor.setEmail(email != null ? email.trim() : "");
            proveedor.setDireccion(direccion != null ? direccion.trim() : "");
            proveedor.setCalificacion(calificacion);
            proveedor.setIdAlmacen(idAlmacen);
            
            // Crear DAO y registrar proveedor
            ProveedorDAO proveedorDAO = new ProveedorDAO();
            boolean registrado = proveedorDAO.registrar(proveedor);
            
            if (registrado) {
                session.setAttribute("mensaje", "Proveedor registrado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "No se pudo registrar el proveedor");
                session.setAttribute("tipoMensaje", "error");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "Error en el formato de los datos numéricos");
            session.setAttribute("tipoMensaje", "error");
            
        } catch (IllegalArgumentException e) {
            session.setAttribute("mensaje", e.getMessage());
            session.setAttribute("tipoMensaje", "error");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al registrar el proveedor: " + e.getMessage());
            session.setAttribute("tipoMensaje", "error");
        }
        
        // Redirigir de vuelta a la lista de proveedores
        response.sendRedirect(request.getContextPath() + "/Vistas/proveedores.jsp");
    }
}