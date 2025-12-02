<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Vehiculo" %>
<%@ page import="dao.VehiculoDAO" %>
<%
    // Verificar sesión
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    // Obtener lista de vehículos
    VehiculoDAO dao = new VehiculoDAO();
    List<Vehiculo> listaVehiculos = dao.listarVehiculos();
    List<String> listaMarcas = dao.listarMarcas();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Vehículos - PERU-ROAD</title>
    
    <!-- Bootstrap CSS desde CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Estilos personalizados mínimos () */
        
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
        }
        
        /* Bootstrap: sticky-top para header fijo */
        .header {
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
        }
        
        /* Bootstrap: position-relative para el dropdown */
        .user-dropdown {
            display: none;
            animation: fadeIn 0.2s ease;
        }
        
        .user-dropdown.show {
            display: block;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Bootstrap: btn, rounded para botones de iconos */
        .icon-btn:hover {
            transform: translateY(-2px);
        }
        
        /* Bootstrap: list-group-item para menú lateral */
        .menu-item.active {
            background: linear-gradient(90deg, #0066cc 0%, #0052a3 100%);
            color: white;
            font-weight: 600;
            border-left: 4px solid #004080;
        }
        
        .menu-item:hover {
            padding-left: 25px;
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

        .menu-item.active:hover {
            padding-left: 20px;
        }
        
        /* Bootstrap: table-hover para efecto hover en tabla */
        
        /* Personalización de select en tabla */
        .filter-select {
            font-size: 12px;
            padding: 6px 10px;
        }
        
        /* Bootstrap: btn-sm para botones pequeños en tabla */
    </style>
</head>
<body class="bg-light">
    <!-- Bootstrap: bg-white, border-bottom, shadow-sm, sticky-top, py-3, px-4, d-flex, justify-content-between, align-items-center -->
    <div class="header bg-white border-bottom shadow-sm sticky-top py-3 px-4 d-flex justify-content-between align-items-center">
        <!-- Logo (izquierda) -->
        <div>
            <div class="logo-box">PERU<br>ROAD</div>
        </div>
        
        <!-- Título (centro) - Bootstrap: flex-grow-1, text-center, text-primary, fs-5, fw-semibold -->
        <div class="flex-grow-1 text-center text-primary fs-5 fw-semibold">
            Sistema de Gestión de Mantenimiento y Almacén
        </div>
        
        <!-- Iconos (derecha) - Bootstrap: d-flex, gap-3, align-items-center -->
        <div class="d-flex gap-3 align-items-center">
            <!-- Bootstrap: btn, btn-secondary, rounded -->
            <button class="btn btn-secondary rounded icon-btn" style="width: 40px; height: 40px;" title="Mensajes">💬</button>
            <!-- Bootstrap: position-relative, dropdown -->
            <div class="position-relative">
                <button class="btn btn-secondary rounded icon-btn" style="width: 40px; height: 40px;" id="userMenuBtn" title="Usuario: <%= usuarioLogueado %>">👤</button>
                <!-- Bootstrap: position-absolute, top-100, end-0, bg-white, rounded, shadow, mt-2 -->
                <div class="user-dropdown position-absolute top-100 end-0 bg-white rounded shadow mt-2" id="userDropdown" style="min-width: 220px; z-index: 1001;">
                    <!-- Bootstrap: bg-light, border-bottom, p-3 -->
                    <div class="bg-light border-bottom p-3">
                        <!-- Bootstrap: fw-semibold, small -->
                        <div class="fw-semibold"><%= usuarioLogueado %></div>
                        <div class="small text-muted">Administrador</div>
                    </div>
                    <!-- Bootstrap: list-group, list-group-flush -->
                    <div class="list-group list-group-flush">
                        <button class="list-group-item list-group-item-action" onclick="window.location.href='perfil.jsp'">
                            👤 Mi Perfil
                        </button>
                        <button class="list-group-item list-group-item-action" onclick="window.location.href='ajustes.jsp'">
                            ⚙️ Ajustes
                        </button>
                        <button class="list-group-item list-group-item-action text-danger border-top" onclick="cerrarSesion()">
                            🚪 Cerrar Sesión
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap: d-flex -->
    <div class="d-flex" style="height: calc(100vh - 81px);">
        <!-- Bootstrap: bg-white, border-end, overflow-auto -->
        <div class="bg-white border-end overflow-auto" style="width: 250px;">
            <!-- Bootstrap: list-group, list-group-flush -->
            <div class="list-group list-group-flush">
                <a href="inicio.jsp" class="list-group-item list-group-item-action menu-item">🏠 Inicio</a>
                <a href="vehiculos.jsp" class="list-group-item list-group-item-action active menu-item">🚗 Vehículos</a>
                <a href="ordenes.jsp" class="list-group-item list-group-item-action menu-item">📋 Órdenes de Trabajo</a>
                <a href="almacen.jsp" class="list-group-item list-group-item-action menu-item">📦 Almacén</a>
                <a href="proveedores.jsp" class="list-group-item list-group-item-action menu-item">🏭 Proveedores</a>
                <a href="reportes.jsp" class="list-group-item list-group-item-action menu-item">📊 Reportes/KPIs</a>
            </div>
        </div>
        
        <!-- Bootstrap: flex-grow-1, overflow-auto, p-4 -->
        <div class="flex-grow-1 overflow-auto p-4">
            <!-- Bootstrap: mb-4 -->
            <div class="mb-4">
                <!-- Bootstrap: fs-4, fw-semibold, mb-1 -->
                <h1 class="fs-4 fw-semibold mb-1">Gestión de Vehículos</h1>
                <!-- Bootstrap: text-muted, small -->
                <p class="text-muted small">Administra y monitorea tu flota vehicular</p>
            </div>
            
            <% 
                String mensaje = (String) session.getAttribute("mensaje");
                String tipoMensaje = (String) session.getAttribute("tipoMensaje");
                if (mensaje != null) {
            %>
                <!-- Bootstrap: alert, alert-success/danger/warning, alert-dismissible -->
                <div class="alert alert-<%= tipoMensaje %> alert-dismissible fade show">
                    <%= mensaje %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <%
                    session.removeAttribute("mensaje");
                    session.removeAttribute("tipoMensaje");
                }
            %>
            
            <!-- Bootstrap: mb-3, d-flex, gap-2 -->
            <div class="mb-3 d-flex gap-2">
                <!-- Bootstrap: btn, btn-primary, shadow-sm -->
                <button class="btn btn-primary shadow-sm" onclick="window.location.href='registrarVehiculo.jsp'">➕ Registrar Vehículo</button>
            </div>
            
            <% if (listaVehiculos != null && !listaVehiculos.isEmpty()) { %>
            <!-- Bootstrap: card, shadow-sm -->
            <div class="card shadow-sm">
                <!-- Bootstrap: table, table-hover, table-striped, mb-0 -->
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>
                                    Marca
                                    <!-- Bootstrap: form-select, form-select-sm, mt-2 -->
                                    <select class="form-select form-select-sm mt-2 filter-select" id="filtroMarca" onchange="filtrarPorMarca()">
                                        <option value="">Todos</option>
                                        <% for (String marca : listaMarcas) { %>
                                            <option value="<%= marca %>"><%= marca %></option>
                                        <% } %>
                                    </select>
                                </th>
                                <th>Modelo</th>
                                <th>Año</th>
                                <th>Placa</th>
                                <th>Kilometraje</th>
                                <th>Plan de Mant.</th>
                                <th>Ver Historial</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="tablaVehiculos">
                            <% for (Vehiculo v : listaVehiculos) { %>
                            <tr data-marca="<%= v.getMarca() %>">
                                <td><%= v.getMarca() %></td>
                                <td><%= v.getModelo() %></td>
                                <td><%= v.getAño() %></td>
                                <!-- Bootstrap: fw-bold -->
                                <td><span class="fw-bold"><%= v.getPlaca() %></span></td>
                                <td><%= String.format("%,d", v.getKilometrajeActual()) %> km</td>
                                <td>
                                    <!-- Bootstrap: btn, btn-primary, btn-sm -->
                                    <button class="btn btn-primary btn-sm" onclick="verPlan(<%= v.getIdVehiculo() %>)">👁️ Ver Plan</button>
                                </td>
                                <td>
                                    <!-- Bootstrap: btn, btn-info, btn-sm -->
                                    <button class="btn btn-info btn-sm" onclick="verHistorial(<%= v.getIdVehiculo() %>)">📋 Ver Historial</button>
                                </td>
                                <td>
                                    <!-- Bootstrap: btn, btn-secondary, btn-sm, me-1 -->
                                    <button class="btn btn-secondary btn-sm me-1" onclick="editar(<%= v.getIdVehiculo() %>)">✏️ Editar</button>
                                    <!-- Bootstrap: btn, btn-danger, btn-sm -->
                                    <button class="btn btn-danger btn-sm" onclick="eliminar(<%= v.getIdVehiculo() %>, '<%= v.getPlaca() %>')">🗑️ Eliminar</button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } else { %>
            <!-- Bootstrap: card, shadow-sm -->
            <div class="card shadow-sm">
                <!-- Bootstrap: card-body, text-center, py-5 -->
                <div class="card-body text-center py-5">
                    <!-- Bootstrap: display-1, text-muted, mb-3 -->
                    <div class="display-1 text-muted mb-3">🚗</div>
                    <!-- Bootstrap: fs-5, fw-medium, mb-2 -->
                    <div class="fs-5 fw-medium mb-2">No hay vehículos registrados</div>
                    <!-- Bootstrap: text-muted -->
                    <p class="text-muted">Comienza registrando tu primer vehículo haciendo clic en el botón "Registrar Vehículo"</p>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    
    <!-- Bootstrap Bundle JS desde CDN (incluye Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
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
        
        // Filtrar por marca
        function filtrarPorMarca() {
            const filtro = document.getElementById('filtroMarca').value.toLowerCase();
            const filas = document.querySelectorAll('#tablaVehiculos tr');
            
            filas.forEach(fila => {
                const marca = fila.getAttribute('data-marca').toLowerCase();
                if (filtro === '' || marca === filtro) {
                    fila.style.display = '';
                } else {
                    fila.style.display = 'none';
                }
            });
        }
        
        // Ver plan de mantenimiento
        function verPlan(id) {
            window.location.href = 'planMantenimiento.jsp?id=' + id;
        }
        
        // Ver historial
        function verHistorial(id) {
            window.location.href = 'historialVehiculo.jsp?id=' + id;
        }
        
        // Editar vehículo
        function editar(id) {
            window.location.href = 'editarVehiculo.jsp?id=' + id;
        }
        
        // Eliminar vehículo
        function eliminar(id, placa) {
            if (confirm('¿Está seguro que desea eliminar el vehículo con placa ' + placa + '?')) {
                window.location.href = 'EliminarVehiculoServlet?id=' + id;
            }
        }
    </script>
</body>
</html>