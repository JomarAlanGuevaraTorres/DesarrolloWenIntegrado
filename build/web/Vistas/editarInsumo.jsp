<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Repuesto" %>
<%@ page import="dao.RepuestoDAO" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    // Obtener el repuesto a editar
    int idRepuesto = 0;
    Repuesto repuesto = null;
    try {
        idRepuesto = Integer.parseInt(request.getParameter("id"));
        RepuestoDAO repuestoDAO = new RepuestoDAO();
        repuesto = repuestoDAO.obtenerPorId(idRepuesto);
        
        if (repuesto == null) {
            response.sendRedirect("almacen.jsp?error=Repuesto no encontrado");
            return;
        }
    } catch (Exception e) {
        response.sendRedirect("almacen.jsp?error=ID inválido");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Insumo - PERU-ROAD</title>
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
        
        .menu-item.active:hover {
            padding-left: 20px;
        }
        
        .content-area {
            flex-grow: 1;
            background-color: #f8f9fa;
            padding: 25px;
            overflow-y: auto;
        }
        
        .form-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 30px;
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
        
        .form-group label {
            font-size: 14px;
            font-weight: 500;
            color: #495057;
            margin-bottom: 6px;
        }
        
        .form-group label .required {
            color: #dc3545;
        }
        
        .form-group input,
        .form-group select {
            padding: 10px 12px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 14px;
            color: #495057;
            transition: all 0.3s;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #0066cc;
            box-shadow: 0 0 0 3px rgba(0,102,204,0.1);
        }
        
        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
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
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        
        .alert-error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
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
            <div class="menu-item active" onclick="window.location.href='almacen.jsp'">📦 Almacén</div>
            <div class="menu-item" onclick="window.location.href='proveedores.jsp'">🏭 Proveedores</div>
            <div class="menu-item" onclick="window.location.href='reportes.jsp'">📊 Reportes/KPIs</div>
        </div>
        
        <div class="content-area">
            <div class="form-container">
                <div class="page-header">
                    <h1 class="page-title">Editar Insumo/Repuesto</h1>
                    <p class="page-subtitle">Actualice la información del artículo</p>
                </div>
                
                <% 
                    String error = request.getParameter("error");
                    if (error != null) { 
                %>
                    <div class="alert alert-error">✗ <%= error %></div>
                <% } %>
                
                <form action="../ActualizarRepuestoServlet" method="post" onsubmit="return validarFormulario()">
                    <input type="hidden" name="idRepuesto" value="<%= repuesto.getIdRepuesto() %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Código <span class="required">*</span></label>
                            <input type="text" name="codigo" id="codigo" required value="<%= repuesto.getCodigo() %>">
                        </div>
                        <div class="form-group">
                            <label>Categoría <span class="required">*</span></label>
                            <select name="categoria" id="categoria" required>
                                <option value="">Seleccione...</option>
                                <option value="Filtros" <%= "Filtros".equals(repuesto.getCategoria()) ? "selected" : "" %>>Filtros</option>
                                <option value="Neumáticos" <%= "Neumáticos".equals(repuesto.getCategoria()) ? "selected" : "" %>>Neumáticos</option>
                                <option value="Baterías" <%= "Baterías".equals(repuesto.getCategoria()) ? "selected" : "" %>>Baterías</option>
                                <option value="Lubricantes" <%= "Lubricantes".equals(repuesto.getCategoria()) ? "selected" : "" %>>Lubricantes</option>
                                <option value="Frenos" <%= "Frenos".equals(repuesto.getCategoria()) ? "selected" : "" %>>Frenos</option>
                                <option value="Sistema eléctrico" <%= "Sistema eléctrico".equals(repuesto.getCategoria()) ? "selected" : "" %>>Sistema eléctrico</option>
                                <option value="Transmisión" <%= "Transmisión".equals(repuesto.getCategoria()) ? "selected" : "" %>>Transmisión</option>
                                <option value="Suspensión" <%= "Suspensión".equals(repuesto.getCategoria()) ? "selected" : "" %>>Suspensión</option>
                                <option value="Otros" <%= "Otros".equals(repuesto.getCategoria()) ? "selected" : "" %>>Otros</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row full">
                        <div class="form-group">
                            <label>Descripción <span class="required">*</span></label>
                            <input type="text" name="descripcion" id="descripcion" required value="<%= repuesto.getDescripcion() %>">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Unidad de Medida <span class="required">*</span></label>
                            <select name="unidadMedida" id="unidadMedida" required>
                                <option value="">Seleccione...</option>
                                <option value="Unidad" <%= "Unidad".equals(repuesto.getUnidadMedida()) ? "selected" : "" %>>Unidad</option>
                                <option value="Litro" <%= "Litro".equals(repuesto.getUnidadMedida()) ? "selected" : "" %>>Litro</option>
                                <option value="Galón" <%= "Galón".equals(repuesto.getUnidadMedida()) ? "selected" : "" %>>Galón</option>
                                <option value="Kilogramo" <%= "Kilogramo".equals(repuesto.getUnidadMedida()) ? "selected" : "" %>>Kilogramo</option>
                                <option value="Set" <%= "Set".equals(repuesto.getUnidadMedida()) ? "selected" : "" %>>Set</option>
                                <option value="Juego" <%= "Juego".equals(repuesto.getUnidadMedida()) ? "selected" : "" %>>Juego</option>
                                <option value="Metro" <%= "Metro".equals(repuesto.getUnidadMedida()) ? "selected" : "" %>>Metro</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Precio Promedio (S/) <span class="required">*</span></label>
                            <input type="number" name="precioPromedio" id="precioPromedio" step="0.01" min="0" required value="<%= repuesto.getPrecioPromedio() %>">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Cantidad Actual <span class="required">*</span></label>
                            <input type="number" name="cantidadActual" id="cantidadActual" min="0" required value="<%= repuesto.getCantidadActual() %>">
                        </div>
                        <div class="form-group">
                            <label>Almacén <span class="required">*</span></label>
                            <select name="idAlmacen" id="idAlmacen" required>
                                <option value="">Seleccione...</option>
                                <option value="1" <%= repuesto.getIdAlmacen() == 1 ? "selected" : "" %>>Almacén Central - Piso 1 Sector A</option>
                                <option value="2" <%= repuesto.getIdAlmacen() == 2 ? "selected" : "" %>>Almacén Norte - Principal</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Stock Mínimo <span class="required">*</span></label>
                            <input type="number" name="stockMinimo" id="stockMinimo" min="0" required value="<%= repuesto.getStockMinimo() %>">
                        </div>
                        <div class="form-group">
                            <label>Stock Máximo <span class="required">*</span></label>
                            <input type="number" name="stockMaximo" id="stockMaximo" min="0" required value="<%= repuesto.getStockMaximo() %>">
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='almacen.jsp'">Cancelar</button>
                        <button type="submit" class="btn btn-primary">💾 Actualizar Repuesto</button>
                    </div>
                </form>
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
        
        function validarFormulario() {
            const stockMinimo = parseInt(document.getElementById('stockMinimo').value);
            const stockMaximo = parseInt(document.getElementById('stockMaximo').value);
            
            if (stockMinimo >= stockMaximo) {
                alert('El stock máximo debe ser mayor que el stock mínimo');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>