<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="dao.EstadisticasDAO" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    // Obtener estadísticas
    EstadisticasDAO estadisticasDAO = new EstadisticasDAO();
    Map<String, Double> tiempoPromedio = estadisticasDAO.obtenerTiempoPromedioReparacion();
    Map<String, Object> cumplimiento = estadisticasDAO.obtenerCumplimientoPreventivos();
    Map<String, Object> consumoInsumos = estadisticasDAO.obtenerConsumoInsumos();
    Map<String, Object> rotacionStock = estadisticasDAO.obtenerRotacionStock();
    Map<String, Integer> alertas = estadisticasDAO.obtenerAlertasCriticas();
    
    DecimalFormat df = new DecimalFormat("#,##0.00");
    DecimalFormat dfEntero = new DecimalFormat("#,##0");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio - PERU-ROAD</title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        
        .header {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            padding: 15px 30px;
            border-bottom: 1px solid #dee2e6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .logo-container {
            display: flex;
            align-items: center;
            gap: 15px;
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
        }
        
        .header-title {
            color: #0066cc;
            font-size: 20px;
            font-weight: 600;
            flex-grow: 1;
            text-align: center;
            letter-spacing: 0.5px;
        }
        
        .header-icons {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .icon-btn {
            width: 40px;
            height: 40px;
            background-color: #495057;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .icon-btn:hover {
            background-color: #6c757d;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .user-menu-container {
            position: relative;
        }
        
        .user-dropdown {
            position: absolute;
            top: 50px;
            right: 0;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            min-width: 220px;
            display: none;
            z-index: 1001;
            overflow: hidden;
        }
        
        .user-dropdown.show {
            display: block;
            animation: fadeIn 0.2s ease;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .user-info {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
            background-color: #f8f9fa;
        }
        
        .user-name {
            font-weight: 600;
            color: #212529;
            font-size: 14px;
        }
        
        .user-role {
            font-size: 12px;
            color: #6c757d;
            margin-top: 2px;
        }
        
        .dropdown-item {
            padding: 12px 15px;
            cursor: pointer;
            transition: all 0.2s;
            color: #495057;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
        }
        
        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: #0066cc;
        }
        
        .dropdown-item.logout {
            color: #dc3545;
            border-top: 1px solid #dee2e6;
        }
        
        .dropdown-item.logout:hover {
            background-color: #fff5f5;
            color: #dc3545;
        }
        
        .container-fluid {
            display: flex;
            height: calc(100vh - 81px);
        }
        
        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #ffffff 0%, #f8f9fa 100%);
            border-right: 1px solid #dee2e6;
            padding: 0;
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
            display: flex;
            align-items: center;
            gap: 10px;
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
        
        .content-area {
            flex-grow: 1;
            background-color: #f8f9fa;
            padding: 25px;
            overflow-y: auto;
        }
        
        .page-header {
            margin-bottom: 25px;
        }
        
        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 5px;
        }
        
        .page-subtitle {
            font-size: 14px;
            color: #6c757d;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background-color: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #0066cc;
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
        }
        
        .stat-card.warning {
            border-left-color: #ffc107;
        }
        
        .stat-card.success {
            border-left-color: #28a745;
        }
        
        .stat-card.danger {
            border-left-color: #dc3545;
        }
        
        .stat-icon {
            font-size: 32px;
            margin-bottom: 15px;
        }
        
        .stat-title {
            font-size: 13px;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #212529;
            margin-bottom: 10px;
        }
        
        .stat-description {
            font-size: 13px;
            color: #6c757d;
            line-height: 1.5;
        }
        
        .stat-detail {
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid #e9ecef;
        }
        
        .stat-detail-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 6px;
            font-size: 12px;
        }
        
        .stat-detail-label {
            color: #6c757d;
        }
        
        .stat-detail-value {
            font-weight: 600;
            color: #212529;
        }
        
        .progress-bar-custom {
            height: 8px;
            background-color: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 8px;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #0066cc 0%, #0052a3 100%);
            transition: width 0.3s ease;
        }
        
        .progress-fill.warning {
            background: linear-gradient(90deg, #ffc107 0%, #ff9800 100%);
        }
        
        .progress-fill.success {
            background: linear-gradient(90deg, #28a745 0%, #20c997 100%);
        }
        
        .alerts-section {
            background-color: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .alerts-title {
            font-size: 18px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 12px;
            border-left: 3px solid #0066cc;
        }
        
        .alert-item.warning {
            border-left-color: #ffc107;
            background-color: #fff8e1;
        }
        
        .alert-item.danger {
            border-left-color: #dc3545;
            background-color: #fff5f5;
        }
        
        .alert-icon-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            background-color: white;
        }
        
        .alert-content {
            flex-grow: 1;
        }
        
        .alert-text {
            font-size: 14px;
            color: #212529;
            font-weight: 500;
        }
        
        .alert-subtext {
            font-size: 12px;
            color: #6c757d;
            margin-top: 3px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo-container">
            <div class="logo-box">PERU<br>ROAD</div>
        </div>
        <div class="header-title">Sistema de Gestión de Mantenimiento y Almacén</div>
        <div class="header-icons">
            <button class="icon-btn" title="Mensajes">💬</button>
            <div class="user-menu-container">
                <button class="icon-btn" id="userMenuBtn" title="Usuario: <%= usuarioLogueado %>">👤</button>
                <div class="user-dropdown" id="userDropdown">
                    <div class="user-info">
                        <div class="user-name"><%= usuarioLogueado %></div>
                        <div class="user-role">Administrador</div>
                    </div>
                    <button class="dropdown-item" onclick="window.location.href='perfil.jsp'">
                        👤 Mi Perfil
                    </button>
                    <button class="dropdown-item" onclick="window.location.href='ajustes.jsp'">
                        ⚙️ Ajustes
                    </button>
                    <button class="dropdown-item logout" onclick="cerrarSesion()">
                        🚪 Cerrar Sesión
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container-fluid">
        <div class="sidebar">
            <div class="menu-item active" onclick="window.location.href='inicio.jsp'">🏠 Inicio</div>
            <div class="menu-item" onclick="window.location.href='vehiculos.jsp'">🚗 Vehículos</div>
            <div class="menu-item" onclick="window.location.href='ordenes.jsp'">📋 Órdenes de Trabajo</div>
            <div class="menu-item" onclick="window.location.href='almacen.jsp'">📦 Almacén</div>
            <div class="menu-item" onclick="window.location.href='proveedores.jsp'">🏭 Proveedores</div>
            <div class="menu-item" onclick="window.location.href='reportes.jsp'">📊 Reportes/KPIs</div>
        </div>
        
        <div class="content-area">
            <div class="page-header">
                <h1 class="page-title">Dashboard Principal</h1>
                <p class="page-subtitle">Resumen de estadísticas y métricas clave del sistema</p>
            </div>
            
            <!-- KPIs Principales -->
            <div class="stats-grid">
                <!-- Tiempo promedio de reparación -->
                <div class="stat-card">
                    <div class="stat-icon">⏱️</div>
                    <div class="stat-title">Tiempo Promedio de Reparación</div>
                    <%
                    if (tiempoPromedio != null && !tiempoPromedio.isEmpty()) {
                        double promTotal = tiempoPromedio.values().stream().mapToDouble(Double::doubleValue).average().orElse(0);
                    %>
                        <div class="stat-value"><%= df.format(promTotal) %> días</div>
                        <div class="stat-description">Promedio general de todos los técnicos</div>
                        <div class="stat-detail">
                            <% for (Map.Entry<String, Double> entry : tiempoPromedio.entrySet()) { %>
                                <div class="stat-detail-item">
                                    <span class="stat-detail-label"><%= entry.getKey() %></span>
                                    <span class="stat-detail-value"><%= df.format(entry.getValue()) %> días</span>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="stat-value">N/A</div>
                        <div class="stat-description">No hay datos suficientes</div>
                    <% } %>
                </div>

                <!-- Cumplimiento de preventivos -->
                <div class="stat-card success">
                    <div class="stat-icon">✅</div>
                    <div class="stat-title">Cumplimiento Mantenimientos Preventivos</div>
                    <%
                    if (cumplimiento != null && !cumplimiento.isEmpty()) {
                        double porcentaje = (Double) cumplimiento.get("porcentaje");
                        int total = (Integer) cumplimiento.get("total");
                        int completados = (Integer) cumplimiento.get("completados");
                    %>
                        <div class="stat-value"><%= df.format(porcentaje) %>%</div>
                        <div class="stat-description"><%= completados %> de <%= total %> mantenimientos completados</div>
                        <div class="progress-bar-custom">
                            <div class="progress-fill success" style="width: <%= porcentaje %>%"></div>
                        </div>
                        <div class="stat-detail">
                            <div class="stat-detail-item">
                                <span class="stat-detail-label">Completados</span>
                                <span class="stat-detail-value"><%= completados %></span>
                            </div>
                            <div class="stat-detail-item">
                                <span class="stat-detail-label">En Proceso</span>
                                <span class="stat-detail-value"><%= cumplimiento.get("enProceso") %></span>
                            </div>
                            <div class="stat-detail-item">
                                <span class="stat-detail-label">Abiertas</span>
                                <span class="stat-detail-value"><%= cumplimiento.get("abiertas") %></span>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="stat-value">N/A</div>
                    <% } %>
                </div>

                <!-- Consumo de insumos -->
                <div class="stat-card warning">
                    <div class="stat-icon">📦</div>
                    <div class="stat-title">Consumo Promedio de Insumos</div>
                    <%
                    if (consumoInsumos != null && !consumoInsumos.isEmpty()) {
                        double promedioRepuestos = (Double) consumoInsumos.get("promedioRepuestos");
                        double totalRepuestos = (Double) consumoInsumos.get("totalRepuestos");
                        int totalVehiculos = (Integer) consumoInsumos.get("totalVehiculos");
                    %>
                        <div class="stat-value">S/ <%= df.format(promedioRepuestos) %></div>
                        <div class="stat-description">Por vehículo (últimos 6 meses)</div>
                        <div class="stat-detail">
                            <div class="stat-detail-item">
                                <span class="stat-detail-label">Total Gastado</span>
                                <span class="stat-detail-value">S/ <%= dfEntero.format(totalRepuestos) %></span>
                            </div>
                            <div class="stat-detail-item">
                                <span class="stat-detail-label">Vehículos</span>
                                <span class="stat-detail-value"><%= totalVehiculos %></span>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="stat-value">N/A</div>
                    <% } %>
                </div>

                <!-- Rotación de stock -->
                <div class="stat-card danger">
                    <div class="stat-icon">🔄</div>
                    <div class="stat-title">Nivel de Rotación de Stock</div>
                    <%
                    if (rotacionStock != null && !rotacionStock.isEmpty()) {
                        int bajoStock = (Integer) rotacionStock.get("bajoStock");
                        int totalProductos = (Integer) rotacionStock.get("totalProductos");
                        int stockTotal = (Integer) rotacionStock.get("stockTotal");
                        double porcentajeBajo = totalProductos > 0 ? (bajoStock * 100.0 / totalProductos) : 0;
                    %>
                        <div class="stat-value"><%= bajoStock %> productos</div>
                        <div class="stat-description">Con stock bajo o crítico (<%= df.format(porcentajeBajo) %>%)</div>
                        <div class="progress-bar-custom">
                            <div class="progress-fill warning" style="width: <%= porcentajeBajo %>%"></div>
                        </div>
                        <div class="stat-detail">
                            <div class="stat-detail-item">
                                <span class="stat-detail-label">Total Productos</span>
                                <span class="stat-detail-value"><%= totalProductos %></span>
                                </div>
                        <div class="stat-detail-item">
                            <span class="stat-detail-label">Stock Total</span>
                            <span class="stat-detail-value"><%= dfEntero.format(stockTotal) %> unidades</span>
                        </div>
                    </div>
                <% } else { %>
                    <div class="stat-value">N/A</div>
                <% } %>
            </div>
        </div>
        
        <!-- Alertas y Notificaciones -->
        <div class="alerts-section">
            <h2 class="alerts-title">🔔 Alertas y Notificaciones</h2>
            
            <% if (alertas != null && !alertas.isEmpty()) { %>
                <% if (alertas.get("mantenimientosVencidos") > 0) { %>
                    <div class="alert-item danger">
                        <div class="alert-icon-circle">⚠️</div>
                        <div class="alert-content">
                            <div class="alert-text"><%= alertas.get("mantenimientosVencidos") %> mantenimientos próximos a vencer</div>
                            <div class="alert-subtext">Requieren atención en los próximos 7 días</div>
                        </div>
                    </div>
                <% } %>
                
                <% if (alertas.get("ordenesAbiertas") > 0) { %>
                    <div class="alert-item warning">
                        <div class="alert-icon-circle">📋</div>
                        <div class="alert-content">
                            <div class="alert-text"><%= alertas.get("ordenesAbiertas") %> órdenes de trabajo abiertas</div>
                            <div class="alert-subtext">Pendientes de asignación o inicio</div>
                        </div>
                    </div>
                <% } %>
                
                <% if (alertas.get("productosBajoStock") > 0) { %>
                    <div class="alert-item danger">
                        <div class="alert-icon-circle">📦</div>
                        <div class="alert-content">
                            <div class="alert-text"><%= alertas.get("productosBajoStock") %> productos con stock bajo</div>
                            <div class="alert-subtext">Se recomienda realizar pedido de reposición</div>
                        </div>
                    </div>
                <% } %>
                
                <% if (alertas.get("mantenimientosVencidos") == 0 && 
                      alertas.get("ordenesAbiertas") == 0 && 
                      alertas.get("productosBajoStock") == 0) { %>
                    <div class="alert-item">
                        <div class="alert-icon-circle">✅</div>
                        <div class="alert-content">
                            <div class="alert-text">Todo al día</div>
                            <div class="alert-subtext">No hay alertas críticas en este momento</div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>
</div>

<script>
    const userMenuBtn = document.getElementById('userMenuBtn');
    const userDropdown = document.getElementById('userDropdown');
    
    userMenuBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        userDropdown.classList.toggle('show');
    });
    
    document.addEventListener('click', function(e) {
        if (!userDropdown.contains(e.target) && e.target !== userMenuBtn) {
            userDropdown.classList.remove('show');
        }
    });
    
    function cerrarSesion() {
        if (confirm('¿Está seguro que desea cerrar sesión?')) {
            window.location.href = '../LogoutServlet';
        }
    }
</script>