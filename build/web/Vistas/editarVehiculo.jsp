<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Vehiculo" %>
<%@ page import="dao.VehiculoDAO" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    // Obtener el vehículo a editar
    String idParam = request.getParameter("id");
    Vehiculo vehiculo = null;
    
    if (idParam != null && !idParam.isEmpty()) {
        try {
            int id = Integer.parseInt(idParam);
            VehiculoDAO dao = new VehiculoDAO();
            vehiculo = dao.buscarPorId(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Si no se encuentra el vehículo, redirigir
    if (vehiculo == null) {
        response.sendRedirect("vehiculos.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Vehículo - PERU-ROAD</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            padding: 20px;
        }
        
        .form-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .form-header {
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #0066cc;
        }
        
        .form-title {
            font-size: 24px;
            color: #0066cc;
            font-weight: 600;
        }
        
        .form-subtitle {
            font-size: 14px;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            font-weight: 500;
            color: #495057;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-label.required::after {
            content: " *";
            color: #dc3545;
        }
        
        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 14px;
            color: #495057;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #0066cc;
            box-shadow: 0 0 0 3px rgba(0,102,204,0.1);
        }
        
        .form-control:disabled {
            background-color: #e9ecef;
            cursor: not-allowed;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background-color: #0066cc;
            color: white;
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
        
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #0066cc;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .info-box {
            background-color: #e3f2fd;
            border-left: 4px solid #0066cc;
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .info-box-title {
            font-weight: 600;
            color: #0066cc;
            margin-bottom: 5px;
        }
        
        .info-box-text {
            font-size: 13px;
            color: #495057;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <a href="vehiculos.jsp" class="back-link">← Volver a Vehículos</a>
        
        <div class="form-header">
            <h1 class="form-title">✏️ Editar Vehículo</h1>
            <p class="form-subtitle">Modificar datos del vehículo: <strong><%= vehiculo.getPlaca() %></strong></p>
        </div>
        
        <div class="info-box">
            <div class="info-box-title">📌 Información</div>
            <div class="info-box-text">
                La placa no se puede modificar. Si necesita cambiarla, elimine el vehículo y créelo nuevamente.
            </div>
        </div>
        
        <% 
            String mensaje = (String) session.getAttribute("mensaje");
            String tipoMensaje = (String) session.getAttribute("tipoMensaje");
            if (mensaje != null) {
        %>
            <div class="alert alert-<%= tipoMensaje %>">
                <%= mensaje %>
            </div>
        <%
                session.removeAttribute("mensaje");
                session.removeAttribute("tipoMensaje");
            }
        %>
        
        <form action="ActualizarVehiculoServlet" method="post">
            <!-- ID oculto -->
            <input type="hidden" name="id" value="<%= vehiculo.getIdVehiculo() %>">
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="placa">Placa</label>
                    <input type="text" class="form-control" id="placa" name="placa" 
                           value="<%= vehiculo.getPlaca() %>" disabled
                           title="La placa no se puede modificar">
                </div>
                
                <div class="form-group">
                    <label class="form-label required" for="marca">Marca</label>
                    <input type="text" class="form-control" id="marca" name="marca" 
                           value="<%= vehiculo.getMarca() %>"
                           placeholder="Ej: Volvo, Scania, Mercedes" required maxlength="50">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label required" for="modelo">Modelo</label>
                    <input type="text" class="form-control" id="modelo" name="modelo" 
                           value="<%= vehiculo.getModelo() %>"
                           placeholder="Ej: FH 540, R450" required maxlength="50">
                </div>
                
                <div class="form-group">
                    <label class="form-label required" for="anio">Año</label>
                    <input type="number" class="form-control" id="anio" name="anio" 
                           value="<%= vehiculo.getAño() %>"
                           min="1990" max="2030" required placeholder="2020">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label required" for="kilometraje">Kilometraje Actual</label>
                    <input type="number" class="form-control" id="kilometraje" name="kilometraje" 
                           value="<%= vehiculo.getKilometrajeActual() %>"
                           min="0" required placeholder="45000">
                </div>
                
                <div class="form-group">
                    <label class="form-label required" for="idTaller">Taller</label>
                    <select class="form-control" id="idTaller" name="idTaller" required>
                        <option value="">Seleccione un taller</option>
                        <option value="1" <%= vehiculo.getIdTaller() == 1 ? "selected" : "" %>>Taller Central</option>
                        <option value="2" <%= vehiculo.getIdTaller() == 2 ? "selected" : "" %>>Taller Norte</option>
                    </select>
                </div>
            </div>
            
            <div class="button-group">
                <button type="submit" class="btn btn-primary">💾 Guardar Cambios</button>
                <button type="button" class="btn btn-secondary" onclick="window.location.href='vehiculos.jsp'">
                    ❌ Cancelar
                </button>
            </div>
        </form>
    </div>
    
    <script>
        // Validación adicional antes de enviar
        document.querySelector('form').addEventListener('submit', function(e) {
            const marca = document.getElementById('marca').value.trim();
            const modelo = document.getElementById('modelo').value.trim();
            const anio = parseInt(document.getElementById('anio').value);
            const kilometraje = parseInt(document.getElementById('kilometraje').value);
            
            if (marca === '' || modelo === '') {
                e.preventDefault();
                alert('Todos los campos son obligatorios');
                return false;
            }
            
            if (anio < 1990 || anio > 2030) {
                e.preventDefault();
                alert('El año debe estar entre 1990 y 2030');
                return false;
            }
            
            if (kilometraje < 0) {
                e.preventDefault();
                alert('El kilometraje no puede ser negativo');
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>