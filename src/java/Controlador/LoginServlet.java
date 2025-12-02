package Controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Configurar codificación UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Obtener parámetros del formulario
        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");
        
        // Validar que no estén vacíos
        if (usuario == null || usuario.trim().isEmpty() || 
            contrasena == null || contrasena.trim().isEmpty()) {
            
            request.setAttribute("error", "Por favor complete todos los campos");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
        
        // Validar credenciales (aquí deberías consultar tu base de datos)
        if (validarUsuario(usuario, contrasena)) {
            // Crear sesión
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            session.setMaxInactiveInterval(30 * 60); // 30 minutos
            
            // Redirigir al dashboard
            response.sendRedirect("Vistas/vehiculos.jsp");
            
        } else {
            // Credenciales incorrectas
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirigir al login si intentan acceder por GET
        response.sendRedirect("login.jsp");
    }
    
    /**
     * Método para validar usuario y contraseña
     * TODO: Implementar consulta a base de datos
     */
    private boolean validarUsuario(String usuario, String contrasena) {
        // TEMPORAL: Credenciales de prueba
        // En producción, debes consultar tu base de datos
        if (usuario.equals("admin") && contrasena.equals("admin123")) {
            return true;
        }
        if (usuario.equals("tecnico") && contrasena.equals("tecnico123")) {
            return true;
        }
        
        // TODO: Aquí deberías hacer algo como:
        // UsuarioDAO dao = new UsuarioDAO();
        // return dao.validarCredenciales(usuario, contrasena);
        
        return false;
    }
}