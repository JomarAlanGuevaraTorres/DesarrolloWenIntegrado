<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Vehiculo" %>
<%@ page import="dao.VehiculoDAO" %>
<%@ page import="dao.RegistrarOrdenDAO" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    // Obtener lista de vehículos para el selector
    VehiculoDAO vehDao = new VehiculoDAO();
    List<Vehiculo> listaVehiculos = vehDao.listarVehiculos();
    
    // Si viene un ID de vehículo por parámetro, pre-seleccionarlo
    String idVehiculoParam = request.getParameter("idVehiculo");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Orden de Trabajo - PERU-ROAD</title>
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
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
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
        
        .form-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 30px;
            max-width: 900px;
        }
        
        .form-section {
            margin-bottom: 25px;
        }
        
        .form-section-title {
            font-size: 16px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-row.full {
            grid-template-columns: 1fr;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-label {
            font-size: 13px;
            font-weight: 600;
            color: #495057;
            margin-bottom: 6px;
        }
        
        .form-label.required::after {
            content: " *";
            color: #dc3545;
        }
        
        .form-input,
        .form-select,
        .form-textarea {
            padding: 10px 12px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 14px;
            color: #495057;
            transition: all 0.2s;
        }
        
        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: #0066cc;
            box-shadow: 0 0 0 3px rgba(0,102,204,0.1);
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 80px;
            font-family: inherit;
        }
        
        .form-select {
            cursor: pointer;
            background-color: white;
        }
        
        .vehicle-info {
            background-color: #e3f2fd;
            padding: 12px;
            border-radius: 6px;
            margin-top: 10px;
            font-size: 13px;
            color: #0066cc;
            display: none;
        }
        
        .vehicle-info.show {
            display: block;
        }
        
        .vehicle-detail {
            margin: 5px 0;
        }
        
        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        .btn {
            padding: 10px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background-color: #0066cc;
            color: white;
            box-shadow: 0 2px 4px rgba(0,102,204,0.2);
        }
        
        .btn-primary:hover {
            background-color: #0052a3;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,102,204,0.3);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .alert {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
            <div class="menu-item active" onclick="window.location.href='ordenes.jsp'">📋 Órdenes de Trabajo</div>
            <div class="menu-item" onclick="window.location.href='almacen.jsp'">📦 Almacén</div>
            <div class="menu-item" onclick="window.location.href='proveedores.jsp'">🏭 Proveedores</div>
            <div class="menu-item" onclick="window.location.href='reportes.jsp'">📊 Reportes/KPIs</div>
        </div>
        
        <div class="content-area">
            <div class="page-header">
                <h1 class="page-title">Registrar Nueva Orden de Trabajo</h1>
                <p class="page-subtitle">Complete los datos para crear una nueva orden de trabajo</p>
            </div>
            
            <% if (listaVehiculos == null || listaVehiculos.isEmpty()) { %>
                <div class="alert alert-error">
                    No hay vehículos registrados. Debe registrar al menos un vehículo antes de crear una orden de trabajo.
                    <br><a href="registrarVehiculo.jsp" style="color: #0066cc; font-weight: 600;">Registrar vehículo</a>
                </div>
            <% } else { %>
            
            <div class="form-container">
                <form action="../RegistrarOrdenServlet" method="POST" id="formOrden">
                    <!-- Sección: Información del Vehículo -->
                    <div class="form-section">
                        <h3 class="form-section-title">📋 Información del Vehículo</h3>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label required" for="idVehiculo">Vehículo</label>
                                <select class="form-select" id="idVehiculo" name="idVehiculo" required onchange="mostrarInfoVehiculo()">
                                    <option value="">Seleccione un vehículo</option>
                                    <% for (Vehiculo v : listaVehiculos) { 
                                        String selected = (idVehiculoParam != null && idVehiculoParam.equals(String.valueOf(v.getIdVehiculo()))) ? "selected" : "";
                                    %>
                                        <option value="<%= v.getIdVehiculo() %>" 
                                                data-placa="<%= v.getPlaca() %>"
                                                data-marca="<%= v.getMarca() %>"
                                                data-modelo="<%= v.getModelo() %>"
                                                data-km="<%= v.getKilometrajeActual() %>"
                                                <%= selected %>>
                                            <%= v.getPlaca() %> - <%= v.getMarca() %> <%= v.getModelo() %>
                                        </option>
                                    <% } %>
                                </select>
                                <div class="vehicle-info" id="vehicleInfo">
                                    <div class="vehicle-detail"><strong>Placa:</strong> <span id="infoPlaca">-</span></div>
                                    <div class="vehicle-detail"><strong>Marca/Modelo:</strong> <span id="infoMarca">-</span></div>
                                    <div class="vehicle-detail"><strong>Kilometraje actual:</strong> <span id="infoKm">-</span> km</div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label required" for="kilometrajeActual">Kilometraje al Ingresar</label>
                                <input type="number" class="form-input" id="kilometrajeActual" name="kilometrajeActual" 
                                       placeholder="Ej: 45000" required min="0">
                            </div>
                        </div>
                    </div>
                    
                    <!-- Sección: Detalles de la Orden -->
                    <div class="form-section">
                        <h3 class="form-section-title">🔧 Detalles de la Orden</h3>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label required" for="tipo">Tipo de Mantenimiento</label>
                                <select class="form-select" id="tipo" name="tipo" required>
                                    <option value="">Seleccione un tipo</option>
                                    <option value="Mantenimiento Preventivo">Mantenimiento Preventivo</option>
                                    <option value="Mantenimiento Correctivo">Mantenimiento Correctivo</option>
                                    <option value="Reparación">Reparación</option>
                                    <option value="Inspección">Inspección</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label required" for="estado">Estado</label>
                                <select class="form-select" id="estado" name="estado" required>
                                    <option value="Abierta">Abierta</option>
                                    <option value="En Proceso" selected>En Proceso</option>
                                    <option value="Completado">Completado</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label required" for="fechaEmision">Fecha de Emisión</label>
                                <input type="date" class="form-input" id="fechaEmision" name="fechaEmision" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label" for="fechaFin">Fecha de Finalización</label>
                                <input type="date" class="form-input" id="fechaFin" name="fechaFin">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="idTecnico">Técnico Asignado</label>
                                <select class="form-select" id="idTecnico" name="idTecnico">
                                    <option value="">Sin asignar</option>
                                    <option value="1">Juan Pérez</option>
                                    <option value="2">María López</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Sección: Diagnóstico y Observaciones -->
                    <div class="form-section">
                        <h3 class="form-section-title">📝 Diagnóstico y Observaciones</h3>
                        
                        <div class="form-row full">
                            <div class="form-group">
                                <label class="form-label required" for="diagnostico">Diagnóstico</label>
                                <textarea class="form-textarea" id="diagnostico" name="diagnostico" 
                                          placeholder="Describa el diagnóstico o motivo de la orden de trabajo..." required></textarea>
                            </div>
                        </div>
                        
                        <div class="form-row full">
                            <div class="form-group">
                                <label class="form-label" for="observaciones">Observaciones</label>
                                <textarea class="form-textarea" id="observaciones" name="observaciones" 
                                          placeholder="Observaciones adicionales (opcional)..."></textarea>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Botones de acción -->
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='ordenes.jsp'">
                            Cancelar
                        </button>
                        <button type="submit" class="btn btn-primary">
                            💾 Registrar Orden
                        </button>
                    </div>
                </form>
            </div>
            <% } %>
        </div>
    </div>
    
    <script>
        // Toggle del menú de usuario
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
        
        // Establecer fecha actual por defecto
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('fechaEmision').value = today;
            
            // Si hay un vehículo pre-seleccionado, mostrar su info
            const selectVehiculo = document.getElementById('idVehiculo');
            if (selectVehiculo.value) {
                mostrarInfoVehiculo();
            }
        });
        
        // Mostrar información del vehículo seleccionado
        function mostrarInfoVehiculo() {
            const select = document.getElementById('idVehiculo');
            const option = select.options[select.selectedIndex];
            const vehicleInfo = document.getElementById('vehicleInfo');
            
            if (select.value) {
                document.getElementById('infoPlaca').textContent = option.dataset.placa;
                document.getElementById('infoMarca').textContent = option.dataset.marca + ' ' + option.dataset.modelo;
                document.getElementById('infoKm').textContent = parseInt(option.dataset.km).toLocaleString();
                
                // Pre-llenar el kilometraje actual
                document.getElementById('kilometrajeActual').value = option.dataset.km;
                
                vehicleInfo.classList.add('show');
            } else {
                vehicleInfo.classList.remove('show');
                document.getElementById('kilometrajeActual').value = '';
            }
        }
        
        // Validación del formulario
        document.getElementById('formOrden').addEventListener('submit', function(e) {
            const fechaEmision = new Date(document.getElementById('fechaEmision').value);
            const fechaFin = document.getElementById('fechaFin').value;
            
            if (fechaFin) {
                const fechaFinDate = new Date(fechaFin);
                if (fechaFinDate < fechaEmision) {
                    e.preventDefault();
                    alert('La fecha de finalización no puede ser anterior a la fecha de emisión.');
                    return false;
                }
            }
        });
    </script>
</body>
</html>