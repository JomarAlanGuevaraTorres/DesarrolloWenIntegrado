<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Proveedor" %>
<%@ page import="dao.ProveedorDAO" %>
<%
    // Verificar sesión
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    // Obtener lista de proveedores
    ProveedorDAO dao = new ProveedorDAO();
    List<Proveedor> listaProveedores = dao.listarProveedores();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proveedores - PERU-ROAD</title>
    <!-- Bootstrap 5 CSS desde CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* CSS personalizado mínimo - La mayoría de estilos vienen de Bootstrap */
        body {
            overflow-x: hidden;
        }
        
        /* Header personalizado */
        .header {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-bottom: 1px solid #dee2e6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        /* Logo personalizado */
        .logo-box {
            width: 50px;
            height: 50px;
            border: 2px solid #0066cc;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            font-weight: 600;
            color: #0066cc;
            background-color: #e3f2fd;
            line-height: 1.2;
        }
        
        .header-title {
            color: #0066cc;
            font-size: 20px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        /* Botones de iconos del header */
        .icon-btn {
            width: 40px;
            height: 40px;
            background-color: #495057;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
        }
        
        .icon-btn:hover {
            background-color: #6c757d;
            transform: translateY(-2px);
        }
        
        /* Contenedor principal - usando Bootstrap grid */
        .container-fluid {
            height: calc(100vh - 81px);
        }
        
        /* Sidebar personalizado */
        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #ffffff 0%, #f8f9fa 100%);
            border-right: 1px solid #dee2e6;
            height: 100%;
            overflow-y: auto;
        }
        
        .menu-item {
            padding: 14px 20px;
            cursor: pointer;
            font-size: 14px;
            background-color: white;
            border-bottom: 1px solid #e9ecef;
            transition: all 0.3s ease;
            color: #495057;
        }
        
        .menu-item:hover {
            background-color: #e3f2fd;
            padding-left: 25px;
            color: #0066cc;
        }
        
        .menu-item.active {
            background: linear-gradient(90deg, #0066cc 0%, #0052a3 100%);
            color: white;
            font-weight: 600;
            border-left: 4px solid #004080;
        }
        
        .menu-item.active:hover {
            padding-left: 20px;
        }
        
        /* Área de contenido */
        .content-area {
            flex-grow: 1;
            background-color: #f8f9fa;
            padding: 25px;
            overflow-y: auto;
            height: 100%;
        }
        
        /* Estrellas de calificación */
        .rating-stars {
            color: #ffc107;
            font-size: 14px;
        }
        
        /* Estado vacío personalizado */
        .empty-state-icon {
            font-size: 64px;
            opacity: 0.3;
        }
    </style>
</head>
<body>
    <!-- Header usando Bootstrap flexbox (d-flex) -->
    <div class="header py-3 px-4">
        <div class="d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-3">
                <div class="logo-box text-center">PERU<br>ROAD</div>
            </div>
            <div class="header-title flex-grow-1 text-center">Sistema de Gestión de Mantenimiento y Almacén</div>
            <div class="d-flex gap-3 align-items-center">
                <button class="icon-btn" title="Mensajes">💬</button>
                <!-- Bootstrap Dropdown Component -->
                <div class="dropdown">
                    <button class="icon-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" title="Usuario: <%= usuarioLogueado %>">
                        👤
                    </button>
                    <!-- Bootstrap dropdown-menu -->
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li class="px-3 py-2 border-bottom bg-light">
                            <div class="fw-semibold"><%= usuarioLogueado %></div>
                            <small class="text-muted">Administrador</small>
                        </li>
                        <li><a class="dropdown-item" href="perfil.jsp">👤 Mi Perfil</a></li>
                        <li><a class="dropdown-item" href="ajustes.jsp">⚙️ Ajustes</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="javascript:void(0);" onclick="cerrarSesion()">🚪 Cerrar Sesión</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap Grid System (row y col) -->
    <div class="container-fluid">
        <div class="row h-100">
            <!-- Sidebar -->
            <div class="col-auto p-0">
                <div class="sidebar">
                    <div class="menu-item" onclick="window.location.href='inicio.jsp'">🏠 Inicio</div>
                    <div class="menu-item" onclick="window.location.href='vehiculos.jsp'">🚗 Vehículos</div>
                    <div class="menu-item" onclick="window.location.href='ordenes.jsp'">📋 Órdenes de Trabajo</div>
                    <div class="menu-item" onclick="window.location.href='almacen.jsp'">📦 Almacén</div>
                    <div class="menu-item active" onclick="window.location.href='proveedores.jsp'">🏭 Proveedores</div>
                    <div class="menu-item" onclick="window.location.href='reportes.jsp'">📊 Reportes/KPIs</div>
                </div>
            </div>
            
            <!-- Área de contenido -->
            <div class="col p-0">
                <div class="content-area">
                    <!-- Bootstrap heading utilities (h3, fw-semibold, mb-1) -->
                    <div class="mb-4">
                        <h1 class="h3 fw-semibold mb-1">Gestión de Proveedores</h1>
                        <p class="text-muted mb-0">Administra los proveedores de insumos y servicios</p>
                    </div>
                    
                    <!-- Bootstrap Alert Components -->
                    <% 
                        String mensaje = (String) session.getAttribute("mensaje");
                        String tipoMensaje = (String) session.getAttribute("tipoMensaje");
                        if (mensaje != null) {
                    %>
                        <div class="alert alert-<%= tipoMensaje %> alert-dismissible fade show" role="alert">
                            <%= mensaje %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <%
                            session.removeAttribute("mensaje");
                            session.removeAttribute("tipoMensaje");
                        }
                    %>
                    
                    <!-- Bootstrap Button (btn btn-primary) -->
                    <div class="mb-3">
                        <button class="btn btn-primary" onclick="window.location.href='registrarProveedor.jsp'">
                            ➕ Registrar Proveedor
                        </button>
                    </div>
                    
                    <% if (listaProveedores != null && !listaProveedores.isEmpty()) { %>
                    <!-- Bootstrap Card Component -->
                    <div class="card shadow-sm">
                        <!-- Bootstrap Table (table-responsive, table, table-hover) -->
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <!-- Bootstrap table-light para el header -->
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Razón Social</th>
                                        <th>Contacto</th>
                                        <th>Teléfono</th>
                                        <th>Email</th>
                                        <th>Calificación</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Proveedor p : listaProveedores) { %>
                                    <tr>
                                        <td><strong>#<%= p.getIdProveedor() %></strong></td>
                                        <td><%= p.getRazonSocial() %></td>
                                        <td><%= p.getContacto() != null && !p.getContacto().isEmpty() ? p.getContacto() : "-" %></td>
                                        <td><%= p.getTelefono() != null && !p.getTelefono().isEmpty() ? p.getTelefono() : "-" %></td>
                                        <td><%= p.getEmail() != null && !p.getEmail().isEmpty() ? p.getEmail() : "-" %></td>
                                        <td>
                                            <span class="rating-stars">
                                                <% 
                                                    int calificacion = p.getCalificacion();
                                                    for (int i = 0; i < 5; i++) {
                                                        if (i < calificacion) {
                                                            out.print("⭐");
                                                        } else {
                                                            out.print("☆");
                                                        }
                                                    }
                                                %>
                                            </span>
                                        </td>
                                        <td>
                                            <!-- Bootstrap Buttons (btn btn-secondary, btn-sm) -->
                                            <button class="btn btn-secondary btn-sm me-1" onclick="editar(<%= p.getIdProveedor() %>)">✏️ Editar</button>
                                            <button class="btn btn-danger btn-sm" onclick="eliminar(<%= p.getIdProveedor() %>, '<%= p.getRazonSocial() %>')">🗑️ Eliminar</button>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <% } else { %>
                    <!-- Bootstrap Card para estado vacío -->
                    <div class="card shadow-sm">
                        <!-- Bootstrap text utilities (text-center, py-5, text-muted) -->
                        <div class="card-body text-center py-5 text-muted">
                            <div class="empty-state-icon mb-3">🏭</div>
                            <h5 class="mb-2">No hay proveedores registrados</h5>
                            <p class="mb-3">Comienza registrando tu primer proveedor haciendo clic en el botón "Registrar Proveedor"</p>
                            <button class="btn btn-primary" onclick="window.location.href='registrarProveedor.jsp'">
                                ➕ Registrar Primer Proveedor
                            </button>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap 5 JavaScript Bundle (incluye Popper.js) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cerrarSesion() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = '../LogoutServlet';
            }
        }
        
        function editar(id) {
            window.location.href = 'editarProveedor.jsp?id=' + id;
        }
        
        function eliminar(id, razonSocial) {
            if (confirm('¿Está seguro que desea eliminar el proveedor ' + razonSocial + '?')) {
                window.location.href = 'EliminarProveedorServlet?id=' + id;
            }
        }
    </script>
</body>
</html>