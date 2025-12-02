package Controlador;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


@WebFilter("/Vistas/*")
public class SecurityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización del filtro
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Obtener la sesión (false = no crear nueva sesión si no existe)
        HttpSession session = httpRequest.getSession(false);
        
        // Verificar si el usuario está autenticado
        boolean isLoggedIn = (session != null && session.getAttribute("usuario") != null);
        
        if (isLoggedIn) {
            // Usuario autenticado, permitir el acceso
            chain.doFilter(request, response);
        } else {
            // Usuario no autenticado, redirigir al login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
        }
    }

    @Override
    public void destroy() {
        // Limpieza del filtro
    }
}