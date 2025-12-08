<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.OrdenTrabajo" %>
<%@ page import="dao.RegistrarOrdenDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    // Obtener mensajes de sesión y limpiarlos
    String mensajeExito = (String) session.getAttribute("mensaje");
    String mensajeError = (String) session.getAttribute("error");
    session.removeAttribute("mensaje");
    session.removeAttribute("error");
    
    // Obtener lista de órdenes directamente del DAO
    RegistrarOrdenDAO dao = new RegistrarOrdenDAO();
    List<OrdenTrabajo> listaOrdenes = dao.listarOrdenes();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Órdenes de Trabajo - PERU-ROAD</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            overflow-x: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-bottom: 1px solid #dee2e6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
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
        
        .container-fluid {
            height: calc(100vh - 81px);
        }
        
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
        
        .content-area {
            flex-grow: 1;
            background-color: #f8f9fa;
            padding: 25px;
            overflow-y: auto;
            height: 100%;
        }
        
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
    </style>
</head>
<body>
    <div class="header py-3 px-4">
        <div class="d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-3">
                <div class="logo-box text-center">PERU<br>ROAD</div>
            </div>
            <div class="header-title flex-grow-1 text-center">Sistema de Gestión de Mantenimiento y Almacén</div>
            <div class="d-flex gap-3 align-items-center">
                <button class="icon-btn" title="Mensajes">💬</button>
                <div class="dropdown">
                    <button class="icon-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" title="Usuario: <%= usuarioLogueado %>">
                        👤
                    </button>
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
    
    <div class="container-fluid">
        <div class="row h-100">
            <div class="col-auto p-0">
                <div class="sidebar">
                    <div class="menu-item" onclick="window.location.href='inicio.jsp'">🏠 Inicio</div>
                    <div class="menu-item" onclick="window.location.href='vehiculos.jsp'">🚗 Vehículos</div>
                    <div class="menu-item active">📋 Órdenes de Trabajo</div>
                    <div class="menu-item" onclick="window.location.href='almacen.jsp'">📦 Almacén</div>
                    <div class="menu-item" onclick="window.location.href='proveedores.jsp'">🏭 Proveedores</div>
                    <div class="menu-item" onclick="window.location.href='reportes.jsp'">📊 Reportes/KPIs</div>
                </div>
            </div>
            
            <div class="col p-0">
                <div class="content-area">
                    <div class="mb-4">
                        <h1 class="h3 fw-semibold mb-1">Órdenes de Trabajo (OT)</h1>
                        <p class="text-muted mb-0">Gestiona las órdenes de trabajo de mantenimiento</p>
                    </div>
                    
                    <% if (mensajeExito != null) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ✓ <%= mensajeExito %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } %>
                    
                    <% if (mensajeError != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ✗ <%= mensajeError %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } %>
                    
                    <div class="mb-3">
                        <button class="btn btn-primary" onclick="window.location.href='registrarOrden.jsp'">
                            ➕ Registrar Nueva OT
                        </button>
                    </div>
                    
                    <div class="card shadow-sm">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID OT</th>
                                        <th>Vehículo (Placa)</th>
                                        <th>Tipo</th>
                                        <th>Técnico Asignado</th>
                                        <th>Kilometraje</th>
                                        <th>Estado</th>
                                        <th>Fecha Emisión</th>
                                        <th>Fecha Fin</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    if (listaOrdenes != null && !listaOrdenes.isEmpty()) {
                                        for (OrdenTrabajo ot : listaOrdenes) {
                                            String badgeClass = "";
                                            String estado = ot.getEstado();
                                            
                                            if (estado != null) {
                                                if (estado.equals("En Proceso")) {
                                                    badgeClass = "bg-warning text-dark";
                                                } else if (estado.equals("Completado")) {
                                                    badgeClass = "bg-success";
                                                } else if (estado.equals("Abierta")) {
                                                    badgeClass = "bg-info text-dark";
                                                }
                                            }
                                            
                                            String fechaFin = (ot.getFechaFin() != null) ? sdf.format(ot.getFechaFin()) : "-";
                                    %>
                                    <tr>
                                        <td><strong><%= ot.getIdOT() %></strong></td>
                                        <td><%= ot.getPlaca() != null ? ot.getPlaca() : "N/A" %></td>
                                        <td><%= ot.getTipo() != null ? ot.getTipo() : "N/A" %></td>
                                        <td><%= ot.getNombreTecnico() != null ? ot.getNombreTecnico() : "Sin asignar" %></td>
                                        <td><%= String.format("%,d", ot.getKilometraje()) %> km</td>
                                        <td><span class="badge <%= badgeClass %>"><%= ot.getEstado() %></span></td>
                                        <td><%= ot.getFechaEmision() != null ? sdf.format(ot.getFechaEmision()) : "-" %></td>
                                        <td><%= fechaFin %></td>
                                        <td>
                                            <a href="<%= request.getContextPath() %>/EditarOrdenServlet?id=<%= ot.getIdOT() %>" class="link-action">✏️ Editar</a>
                                            <a href="<%= request.getContextPath() %>/VerOrdenServlet?id=<%= ot.getIdOT() %>" class="link-action">👁️ Ver</a>
                                            <a href="javascript:void(0);" onclick="confirmarEliminar('<%= ot.getIdOT() %>')" class="link-action delete">🗑️ Eliminar</a>
                                        </td>
                                    </tr>
                                    <% 
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">
                                            📋 No hay órdenes de trabajo registradas.<br>
                                            <button class="btn btn-primary mt-3" onclick="window.location.href='registrarOrden.jsp'">
                                                Registrar primera orden
                                            </button>
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
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cerrarSesion() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = '../LogoutServlet';
            }
        }
        
        function confirmarEliminar(idOT) {
            if (confirm('¿Está seguro que desea eliminar la orden de trabajo ' + idOT + '?')) {
                window.location.href = '../EliminarOrdenServlet?id=' + idOT;
            }
        }
        
        // Auto-ocultar alertas después de 5 segundos
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>