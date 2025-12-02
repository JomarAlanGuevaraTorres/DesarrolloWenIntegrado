<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Repuesto" %>
<%@ page import="dao.RepuestoDAO" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    // Obtener lista de repuestos
    RepuestoDAO repuestoDAO = new RepuestoDAO();
    List<Repuesto> listaRepuestos = repuestoDAO.listarTodos();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Almacén - PERU-ROAD</title>
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
        
        /* Enlaces de acciones personalizados */
        .link-action {
            color: #0066cc;
            text-decoration: none;
            margin-right: 12px;
            font-weight: 500;
            font-size: 13px;
        }
        
        .link-action:hover {
            color: #004080;
            text-decoration: underline;
        }
        
        .link-action.delete {
            color: #dc3545;
        }
        
        .link-action.delete:hover {
            color: #c82333;
        }
        
        /* Indicadores de stock */
        .stock-low {
            color: #dc3545;
            font-weight: 600;
        }
        
        .stock-normal {
            color: #28a745;
            font-weight: 600;
        }
        
        /* Badge personalizado para categorías */
        .badge-categoria {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 500;
            background-color: #e9ecef;
            color: #495057;
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
                    <div class="menu-item active" onclick="window.location.href='almacen.jsp'">📦 Almacén</div>
                    <div class="menu-item" onclick="window.location.href='proveedores.jsp'">🏭 Proveedores</div>
                    <div class="menu-item" onclick="window.location.href='reportes.jsp'">📊 Reportes/KPIs</div>
                </div>
            </div>
            
            <!-- Área de contenido -->
            <div class="col p-0">
                <div class="content-area">
                    <!-- Bootstrap heading utilities (h3, fw-semibold, mb-1) -->
                    <div class="mb-4">
                        <h1 class="h3 fw-semibold mb-1">Gestión de Almacén</h1>
                        <p class="text-muted mb-0">Controla el inventario de insumos y repuestos</p>
                    </div>
                    
                    <!-- Bootstrap Alert Components -->
                    <% 
                        String mensaje = request.getParameter("mensaje");
                        String error = request.getParameter("error");
                        if (mensaje != null) { 
                    %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ✓ <%= mensaje %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } else if (error != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ✗ <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } %>
                    
                    <!-- Bootstrap Button (btn btn-primary) -->
                    <div class="mb-3">
                        <a href="registrarInsumo.jsp" class="btn btn-primary">➕ Registrar Insumo</a>
                    </div>
                    
                    <!-- Bootstrap Card Component -->
                    <div class="card shadow-sm">
                        <!-- Bootstrap Table (table-responsive, table, table-hover) -->
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <!-- Bootstrap table-light para el header -->
                                <thead class="table-light">
                                    <tr>
                                        <th>Código</th>
                                        <th>Insumo/Repuesto</th>
                                        <th>Categoría</th>
                                        <th>Stock Actual</th>
                                        <th>Stock Mínimo</th>
                                        <th>Último Ingreso</th>
                                        <th>Última Salida</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (listaRepuestos != null && !listaRepuestos.isEmpty()) {
                                        for (Repuesto rep : listaRepuestos) {
                                            String[] movimientos = repuestoDAO.obtenerUltimoMovimiento(rep.getIdRepuesto());
                                            String stockClass = rep.stockBajo() ? "stock-low" : "stock-normal";
                                    %>
                                    <tr>
                                        <td><strong><%= rep.getCodigo() %></strong></td>
                                        <td><%= rep.getDescripcion() %></td>
                                        <td><span class="badge-categoria"><%= rep.getCategoria() %></span></td>
                                        <td><span class="<%= stockClass %>"><%= rep.getCantidadActual() %></span></td>
                                        <td><%= rep.getStockMinimo() %></td>
                                        <td><%= movimientos[0] %></td>
                                        <td><%= movimientos[1] %></td>
                                        <td>
                                            <a href="editarInsumo.jsp?id=<%= rep.getIdRepuesto() %>" class="link-action">✏️ Editar</a>
                                            <a href="#" onclick="eliminarRepuesto(<%= rep.getIdRepuesto() %>)" class="link-action delete">🗑️ Eliminar</a>
                                        </td>
                                    </tr>
                                    <% 
                                        }
                                    } else { 
                                    %>
                                    <tr>
                                        <!-- Bootstrap text utilities (text-center, py-5, text-muted) -->
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            📦 No hay repuestos registrados
                                            <br>
                                            <a href="registrarInsumo.jsp" class="btn btn-primary mt-3">Registrar primer repuesto</a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
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
        
        function eliminarRepuesto(id) {
            if (confirm('¿Está seguro que desea eliminar este repuesto?\nEsta acción no se puede deshacer.')) {
                window.location.href = '../RegistrarRepuestoServlet?action=eliminar&id=' + id;
            }
        }
    </script>
</body>
</html>