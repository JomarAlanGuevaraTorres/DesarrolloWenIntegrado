<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
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
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .alerts-section {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .alert-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #dc3545;
        }
        
        .alert-card.warning {
            border-left-color: #ffc107;
        }
        
        .alert-card.info {
            border-left-color: #17a2b8;
        }
        
        .alert-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }
        
        .alert-icon {
            font-size: 24px;
        }
        
        .alert-title {
            font-size: 16px;
            font-weight: 600;
            color: #212529;
        }
        
        .alert-content {
            font-size: 14px;
            color: #495057;
            margin-bottom: 15px;
            line-height: 1.6;
        }
        
        .alert-details {
            font-size: 13px;
            color: #6c757d;
            margin-top: 8px;
        }
        
        .alert-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn-alert {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-primary-alert {
            background-color: #0066cc;
            color: white;
        }
        
        .btn-primary-alert:hover {
            background-color: #0052a3;
        }
        
        .btn-secondary-alert {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary-alert:hover {
            background-color: #5a6268;
        }
        
        .calendar-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            height: fit-content;
        }
        
        .calendar-header {
            text-align: center;
            font-size: 16px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .calendar {
            width: 100%;
        }
        
        .calendar-weekdays {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 5px;
            margin-bottom: 5px;
        }
        
        .calendar-weekday {
            text-align: center;
            font-size: 12px;
            font-weight: 600;
            color: #6c757d;
            padding: 8px 0;
        }
        
        .calendar-days {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 5px;
        }
        
        .calendar-day {
            aspect-ratio: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            color: #495057;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .calendar-day:hover {
            background-color: #e3f2fd;
        }
        
        .calendar-day.other-month {
            color: #adb5bd;
        }
        
        .calendar-day.today {
            background-color: #0066cc;
            color: white;
            font-weight: 600;
        }
        
        .calendar-day.has-event {
            background-color: #fff3cd;
            font-weight: 600;
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
                <p class="page-subtitle">Resumen de alertas y notificaciones importantes</p>
            </div>
            
            <div class="dashboard-grid">
                <div class="alerts-section">
                    <!-- Tiempo promedio de reparación por técnico -->
                    <div class="alert-card">
                        <div class="alert-header">
                            <span class="alert-icon">⏱️</span>
                            <span class="alert-title">Tiempo promedio de reparación por técnico</span>
                        </div>
                        <div class="alert-content">
                            <!-- Datos se cargarán desde la BD -->
                        </div>
                    </div>

                    <!-- Cumplimiento de mantenimientos preventivos -->
                    <div class="alert-card warning">
                        <div class="alert-header">
                            <span class="alert-icon">✅</span>
                            <span class="alert-title">Cumplimiento de mantenimientos preventivos</span>
                        </div>
                        <div class="alert-content">
                            <!-- Datos se cargarán desde la BD -->
                        </div>
                    </div>

                    <!-- Consumo promedio de insumos por unidad -->
                    <div class="alert-card info">
                        <div class="alert-header">
                            <span class="alert-icon">📦</span>
                            <span class="alert-title">Consumo promedio de insumos por unidad</span>
                        </div>
                        <div class="alert-content">
                            <!-- Datos se cargarán desde la BD -->
                        </div>
                    </div>

                    <!-- Nivel de rotación de stock -->
                    <div class="alert-card">
                        <div class="alert-header">
                            <span class="alert-icon">🔄</span>
                            <span class="alert-title">Nivel de rotación de stock</span>
                        </div>
                        <div class="alert-content">
                            <!-- Datos se cargarán desde la BD -->
                        </div>
                    </div>
                </div>
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
</body>
</html>