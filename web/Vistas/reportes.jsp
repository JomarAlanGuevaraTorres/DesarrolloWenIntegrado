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
    <title>Reportes/KPIs - PERU-ROAD</title>
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
        
        .filters-section {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }
        
        .filters-title {
            font-size: 16px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 15px;
        }
        
        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-label {
            font-size: 13px;
            font-weight: 500;
            color: #495057;
            margin-bottom: 5px;
        }
        
        .form-control {
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 13px;
            color: #495057;
            transition: all 0.2s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #0066cc;
            box-shadow: 0 0 0 3px rgba(0,102,204,0.1);
        }
        
        .btn-action {
            padding: 10px 24px;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0,102,204,0.2);
        }
        
        .btn-action:hover {
            background-color: #0052a3;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,102,204,0.3);
        }
        
        .btn-secondary {
            background-color: #28a745;
            margin-left: 10px;
        }
        
        .btn-secondary:hover {
            background-color: #218838;
        }
        
        .btn-tertiary {
            background-color: #17a2b8;
            margin-left: 10px;
        }
        
        .btn-tertiary:hover {
            background-color: #138496;
        }
        
        .data-table {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        
        .data-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .data-table th {
            background: linear-gradient(180deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 12px 15px;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
            font-size: 13px;
            font-weight: 600;
            color: #495057;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .data-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #e9ecef;
            font-size: 13px;
            color: #495057;
        }
        
        .data-table tbody tr {
            transition: all 0.2s ease;
        }
        
        .data-table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .badge-preventivo {
            background-color: #28a745;
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .badge-correctivo {
            background-color: #ffc107;
            color: #212529;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .badge-cerrado {
            background-color: #6c757d;
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .badge-proceso {
            background-color: #0066cc;
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .cost-positive {
            color: #28a745;
            font-weight: 600;
        }
        
        .cost-high {
            color: #dc3545;
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
            <div class="menu-item" onclick="window.location.href='inicio.jsp'">🏠 Inicio</div>
            <div class="menu-item" onclick="window.location.href='vehiculos.jsp'">🚗 Vehículos</div>
            <div class="menu-item" onclick="window.location.href='ordenes.jsp'">📋 Órdenes de Trabajo</div>
            <div class="menu-item" onclick="window.location.href='almacen.jsp'">📦 Almacén</div>
            <div class="menu-item" onclick="window.location.href='proveedores.jsp'">🏭 Proveedores</div>
            <div class="menu-item active" onclick="window.location.href='reportes.jsp'">📊 Reportes/KPIs</div>
        </div>
        
        <div class="content-area">
            <div class="page-header">
                <h1 class="page-title">Reportes y KPIs</h1>
                <p class="page-subtitle">Genera reportes de mantenimiento y analiza indicadores clave</p>
            </div>
            
            <div class="filters-section">
                <div class="filters-title">Filtros de Búsqueda</div>
                <div class="filters-grid">
                    <div class="form-group">
                        <label class="form-label">Tipo de Reporte</label>
                        <select class="form-control" id="tipoReporte" onchange="cambiarTipoReporte()">
                            <option value="mantenimientos">Mantenimientos por fechas</option>
                            <option value="vencimientos">Vencimientos de preventivos</option>
                            <option value="valorizado">Reporte valorizado</option>
                            <option value="stock">Stock y movimientos</option>
                            <option value="proveedores">Proveedores (cumplimiento y costos)</option>
                        </select>
                    </div>
                    
                    <div class="form-group" id="filtroVehiculo">
                        <label class="form-label">Vehículo</label>
                        <select class="form-control">
                            <option value="">Todos los vehículos</option>
                            <option value="ABC-123">ABC-123 - Volvo FMX 2020</option>
                            <option value="XYZ-987">XYZ-987 - Scania R450 2019</option>
                            <option value="LMN-456">LMN-456 - Mercedes Actros 2021</option>
                        </select>
                    </div>
                    
                    <div class="form-group" id="filtroTecnico">
                        <label class="form-label">Técnico Asignado</label>
                        <select class="form-control">
                            <option value="">Todos los técnicos</option>
                            <option value="juan">Juan Pérez</option>
                            <option value="luis">Luis Gómez</option>
                            <option value="maria">María Ruiz</option>
                        </select>
                    </div>
                    
                    <div class="form-group" id="filtroProveedor" style="display: none;">
                        <label class="form-label">Proveedor</label>
                        <select class="form-control">
                            <option value="">Todos los proveedores</option>
                            <option value="prov1">Repuestos Lima S.A.</option>
                            <option value="prov2">AutoPartes del Norte</option>
                            <option value="prov3">Distribuidora Central</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Fecha Inicio</label>
                        <input type="date" class="form-control" value="2025-09-01">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Fecha Fin</label>
                        <input type="date" class="form-control" value="2025-09-30">
                    </div>
                </div>
                
                <div style="margin-top: 15px;">
                    <button class="btn-action">🔍 Generar Reporte</button>
                    <button class="btn-action btn-secondary">📄 Exportar PDF</button>
                    <button class="btn-action btn-tertiary">📊 Exportar Excel</button>
                </div>
            </div>
            
            <!-- Tabla para Mantenimientos por fechas -->
            <div class="data-table" id="tablaMantenimientos">
                <table>
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Vehículo</th>
                            <th>Técnico</th>
                            <th>Tipo de Mantenimiento</th>
                            <th>Estado</th>
                            <th>Costo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>05/09/2025</td>
                            <td><strong>ABC-123</strong> - Volvo FMX 2020</td>
                            <td>Juan Pérez</td>
                            <td><span class="badge-preventivo">Preventivo</span></td>
                            <td><span class="badge-cerrado">Cerrado</span></td>
                            <td class="cost-positive">$350</td>
                        </tr>
                        <tr>
                            <td>06/09/2025</td>
                            <td><strong>XYZ-987</strong> - Scania R450 2019</td>
                            <td>Luis Gómez</td>
                            <td><span class="badge-correctivo">Correctivo</span></td>
                            <td><span class="badge-proceso">En Proceso</span></td>
                            <td class="cost-high">$480</td>
                        </tr>
                        <tr>
                            <td>03/09/2025</td>
                            <td><strong>LMN-456</strong> - Mercedes Actros 2021</td>
                            <td>María Ruiz</td>
                            <td><span class="badge-preventivo">Preventivo</span></td>
                            <td><span class="badge-cerrado">Cerrado</span></td>
                            <td class="cost-positive">$280</td>
                        </tr>
                        <tr>
                            <td>01/09/2025</td>
                            <td><strong>ABC-123</strong> - Volvo FMX 2020</td>
                            <td>Juan Pérez</td>
                            <td><span class="badge-correctivo">Correctivo</span></td>
                            <td><span class="badge-cerrado">Cerrado</span></td>
                            <td class="cost-high">$650</td>
                        </tr>
                        <tr>
                            <td>28/08/2025</td>
                            <td><strong>XYZ-987</strong> - Scania R450 2019</td>
                            <td>Luis Gómez</td>
                            <td><span class="badge-preventivo">Preventivo</span></td>
                            <td><span class="badge-cerrado">Cerrado</span></td>
                            <td class="cost-positive">$320</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- Tabla para Vencimientos de Preventivos -->
            <div class="data-table" id="tablaVencimientos" style="display: none;">
                <table>
                    <thead>
                        <tr>
                            <th>Vehículo</th>
                            <th>Último Mantenimiento</th>
                            <th>Próximo Mantenimiento</th>
                            <th>Días Restantes</th>
                            <th>Kilometraje Actual</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>ABC-123</strong> - Volvo FMX 2020</td>
                            <td>01/09/2025</td>
                            <td>15/10/2025</td>
                            <td><span class="badge-warning">6 días</span></td>
                            <td>145,000 km</td>
                            <td><span class="badge-warning">Próximo a vencer</span></td>
                        </tr>
                        <tr>
                            <td><strong>XYZ-987</strong> - Scania R450 2019</td>
                            <td>28/08/2025</td>
                            <td>05/10/2025</td>
                            <td><span class="badge-danger">Vencido</span></td>
                            <td>178,500 km</td>
                            <td><span class="badge-danger">Vencido</span></td>
                        </tr>
                        <tr>
                            <td><strong>LMN-456</strong> - Mercedes Actros 2021</td>
                            <td>15/09/2025</td>
                            <td>30/10/2025</td>
                            <td><span class="badge-success">21 días</span></td>
                            <td>98,200 km</td>
                            <td><span class="badge-success">Al día</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- Tabla para Reporte Valorizado -->
            <div class="data-table" id="tablaValorizado" style="display: none;">
                <table>
                    <thead>
                        <tr>
                            <th>Vehículo</th>
                            <th>Tipo de Mantenimiento</th>
                            <th>Mano de Obra</th>
                            <th>Repuestos</th>
                            <th>Insumos</th>
                            <th>Costo Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>ABC-123</strong> - Volvo FMX 2020</td>
                            <td><span class="badge-preventivo">Preventivo</span></td>
                            <td>$150</td>
                            <td>$120</td>
                            <td>$80</td>
                            <td class="cost-positive"><strong>$350</strong></td>
                        </tr>
                        <tr>
                            <td><strong>XYZ-987</strong> - Scania R450 2019</td>
                            <td><span class="badge-correctivo">Correctivo</span></td>
                            <td>$200</td>
                            <td>$180</td>
                            <td>$100</td>
                            <td class="cost-high"><strong>$480</strong></td>
                        </tr>
                        <tr>
                            <td><strong>LMN-456</strong> - Mercedes Actros 2021</td>
                            <td><span class="badge-preventivo">Preventivo</span></td>
                            <td>$130</td>
                            <td>$100</td>
                            <td>$50</td>
                            <td class="cost-positive"><strong>$280</strong></td>
                        </tr>
                        <tr>
                            <td colspan="5" style="text-align: right; font-weight: bold;">TOTAL:</td>
                            <td class="cost-high"><strong>$1,110</strong></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- Tabla para Stock y Movimientos -->
            <div class="data-table" id="tablaStock" style="display: none;">
                <table>
                    <thead>
                        <tr>
                            <th>Insumo/Repuesto</th>
                            <th>Stock Actual</th>
                            <th>Stock Mínimo</th>
                            <th>Entradas</th>
                            <th>Salidas</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Filtro de Aceite</strong></td>
                            <td>25</td>
                            <td>15</td>
                            <td>30</td>
                            <td>15</td>
                            <td><span class="badge-success">Normal</span></td>
                        </tr>
                        <tr>
                            <td><strong>Aceite Motor 15W40</strong></td>
                            <td>8</td>
                            <td>10</td>
                            <td>20</td>
                            <td>22</td>
                            <td><span class="badge-warning">Bajo stock</span></td>
                        </tr>
                        <tr>
                            <td><strong>Pastillas de Freno</strong></td>
                            <td>3</td>
                            <td>8</td>
                            <td>15</td>
                            <td>18</td>
                            <td><span class="badge-danger">Crítico</span></td>
                        </tr>
                        <tr>
                            <td><strong>Filtro de Aire</strong></td>
                            <td>40</td>
                            <td>12</td>
                            <td>50</td>
                            <td>20</td>
                            <td><span class="badge-success">Normal</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- Tabla para Proveedores -->
            <div class="data-table" id="tablaProveedores" style="display: none;">
                <table>
                    <thead>
                        <tr>
                            <th>Proveedor</th>
                            <th>Pedidos Totales</th>
                            <th>Entregas a Tiempo</th>
                            <th>% Cumplimiento</th>
                            <th>Costo Total</th>
                            <th>Calificación</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Repuestos Lima S.A.</strong></td>
                            <td>15</td>
                            <td>14</td>
                            <td><span class="badge-success">93%</span></td>
                            <td>$4,500</td>
                            <td>⭐⭐⭐⭐⭐</td>
                        </tr>
                        <tr>
                            <td><strong>AutoPartes del Norte</strong></td>
                            <td>12</td>
                            <td>9</td>
                            <td><span class="badge-warning">75%</span></td>
                            <td>$3,200</td>
                            <td>⭐⭐⭐⭐</td>
                        </tr>
                        <tr>
                            <td><strong>Distribuidora Central</strong></td>
                            <td>20</td>
                            <td>18</td>
                            <td><span class="badge-success">90%</span></td>
                            <td>$6,800</td>
                            <td>⭐⭐⭐⭐⭐</td>
                        </tr>
                        <tr>
                            <td><strong>Lubricantes Express</strong></td>
                            <td>8</td>
                            <td>5</td>
                            <td><span class="badge-danger">63%</span></td>
                            <td>$1,900</td>
                            <td>⭐⭐⭐</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        function cambiarTipoReporte() {
            const tipoReporte = document.getElementById('tipoReporte').value;
            
            // Ocultar todas las tablas
            document.getElementById('tablaMantenimientos').style.display = 'none';
            document.getElementById('tablaVencimientos').style.display = 'none';
            document.getElementById('tablaValorizado').style.display = 'none';
            document.getElementById('tablaStock').style.display = 'none';
            document.getElementById('tablaProveedores').style.display = 'none';
            
            // Mostrar/ocultar filtros según el tipo de reporte
            const filtroVehiculo = document.getElementById('filtroVehiculo');
            const filtroTecnico = document.getElementById('filtroTecnico');
            const filtroProveedor = document.getElementById('filtroProveedor');
            
            filtroVehiculo.style.display = 'block';
            filtroTecnico.style.display = 'block';
            filtroProveedor.style.display = 'none';
            
            // Mostrar la tabla correspondiente
            switch(tipoReporte) {
                case 'mantenimientos':
                    document.getElementById('tablaMantenimientos').style.display = 'block';
                    break;
                case 'vencimientos':
                    document.getElementById('tablaVencimientos').style.display = 'block';
                    filtroTecnico.style.display = 'none';
                    break;
                case 'valorizado':
                    document.getElementById('tablaValorizado').style.display = 'block';
                    break;
                case 'stock':
                    document.getElementById('tablaStock').style.display = 'block';
                    filtroVehiculo.style.display = 'none';
                    filtroTecnico.style.display = 'none';
                    break;
                case 'proveedores':
                    document.getElementById('tablaProveedores').style.display = 'block';
                    filtroVehiculo.style.display = 'none';
                    filtroTecnico.style.display = 'none';
                    filtroProveedor.style.display = 'block';
                    break;
            }
        }
        
        function cerrarSesion() {
            if(confirm('¿Estás seguro de que deseas cerrar sesión?')) {
                window.location.href = 'login.jsp';
            }
        }
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