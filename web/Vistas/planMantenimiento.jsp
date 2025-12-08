<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.MySQLConexion" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    // Obtener ID del vehículo
    String idVehiculoStr = request.getParameter("id");
    if (idVehiculoStr == null || idVehiculoStr.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/Vistas/vehiculos.jsp");
        return;
    }
    
    int idVehiculo = Integer.parseInt(idVehiculoStr);
    
    // Datos del vehículo
    String placa = "";
    String marca = "";
    String modelo = "";
    int kilometrajeActual = 0;
    
    // Datos del plan
    String descripcionPlan = "";
    String tipoPlan = "";
    int frecuenciaKm = 0;
    int frecuenciaDias = 0;
    String fechaAsignacion = "";
    int kilometrajeInicio = 0;
    String proximoMantenimiento = "";
    String estadoPlan = "";
    
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    boolean tienePlan = false;
    
    try {
        con = MySQLConexion.getConexion();
        
        // Obtener datos del vehículo
        String sqlVehiculo = "SELECT Placa, Marca, Modelo, Kilometraje_actual FROM VEHICULO WHERE ID_Vehiculo = ?";
        ps = con.prepareStatement(sqlVehiculo);
        ps.setInt(1, idVehiculo);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            placa = rs.getString("Placa");
            marca = rs.getString("Marca");
            modelo = rs.getString("Modelo");
            kilometrajeActual = rs.getInt("Kilometraje_actual");
        }
        rs.close();
        ps.close();
        
        // Obtener plan de mantenimiento
        String sqlPlan = "SELECT * FROM PLAN_MANTENIMIENTO WHERE ID_Vehiculo = ? ORDER BY ID_Plan DESC LIMIT 1";
        ps = con.prepareStatement(sqlPlan);
        ps.setInt(1, idVehiculo);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            tienePlan = true;
            descripcionPlan = rs.getString("Descripcion");
            tipoPlan = rs.getString("Tipo");
            frecuenciaKm = rs.getInt("Frecuencia_km");
            frecuenciaDias = rs.getInt("Frecuencia_dias");
            fechaAsignacion = rs.getString("Fecha_asignacion");
            kilometrajeInicio = rs.getInt("Kilometraje_inicio");
            proximoMantenimiento = rs.getString("Proximo_mantenimiento");
            estadoPlan = rs.getString("Estado");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Plan de Mantenimiento - <%= placa %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        
        .vehicle-header {
            background: linear-gradient(135deg, #0066cc 0%, #0052a3 100%);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0,102,204,0.3);
        }
        
        .vehicle-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .info-item {
            background-color: rgba(255,255,255,0.1);
            padding: 15px;
            border-radius: 8px;
        }
        
        .info-label {
            font-size: 12px;
            opacity: 0.9;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-value {
            font-size: 20px;
            font-weight: 600;
        }
        
        .plan-card {
            background-color: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .plan-section-title {
            font-size: 18px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .detail-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .detail-item {
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
            border-left: 3px solid #0066cc;
        }
        
        .detail-label {
            font-size: 13px;
            color: #6c757d;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-size: 18px;
            color: #212529;
            font-weight: 600;
        }
        
        .badge-active {
            background-color: #28a745;
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .badge-inactive {
            background-color: #dc3545;
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .progress-section {
            margin-top: 30px;
            padding: 20px;
            background-color: #fff8e1;
            border-radius: 8px;
            border-left: 4px solid #ffc107;
        }
        
        .progress-title {
            font-size: 16px;
            font-weight: 600;
            color: #856404;
            margin-bottom: 15px;
        }
        
        .progress-bar-custom {
            height: 30px;
            background-color: #e9ecef;
            border-radius: 15px;
            overflow: hidden;
            position: relative;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #28a745 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 14px;
            transition: width 0.5s ease;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        
        .empty-text {
            font-size: 18px;
            color: #6c757d;
            margin-bottom: 10px;
        }
        
        .empty-subtext {
            font-size: 14px;
            color: #adb5bd;
        }
        
        .alert-box {
            padding: 15px;
            background-color: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .alert-box.danger {
            background-color: #f8d7da;
            border-color: #dc3545;
        }
        
        .alert-box.success {
            background-color: #d4edda;
            border-color: #28a745;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="mb-4">
            <a href="<%= request.getContextPath() %>/Vistas/vehiculos.jsp" class="btn btn-secondary">← Volver a Vehículos</a>
        </div>
        
        <!-- Información del Vehículo -->
        <div class="vehicle-header">
            <h1>🚗 Plan de Mantenimiento</h1>
            <div class="vehicle-info">
                <div class="info-item">
                    <div class="info-label">Placa</div>
                    <div class="info-value"><%= placa %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Marca / Modelo</div>
                    <div class="info-value"><%= marca %> <%= modelo %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Kilometraje Actual</div>
                    <div class="info-value"><%= String.format("%,d", kilometrajeActual) %> km</div>
                </div>
            </div>
        </div>
        
        <% if (tienePlan) { %>
            <!-- Información del Plan -->
            <div class="plan-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="plan-section-title mb-0">📋 Detalles del Plan</h2>
                    <span class="<%= "Activo".equals(estadoPlan) ? "badge-active" : "badge-inactive" %>">
                        <%= estadoPlan %>
                    </span>
                </div>
                
                <div class="detail-row">
                    <div class="detail-item">
                        <div class="detail-label">Descripción</div>
                        <div class="detail-value" style="font-size: 16px;"><%= descripcionPlan %></div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">Tipo de Plan</div>
                        <div class="detail-value"><%= tipoPlan %></div>
                    </div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-item">
                        <div class="detail-label">Frecuencia (Kilometraje)</div>
                        <div class="detail-value">Cada <%= String.format("%,d", frecuenciaKm) %> km</div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">Frecuencia (Tiempo)</div>
                        <div class="detail-value">Cada <%= frecuenciaDias %> días</div>
                    </div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-item">
                        <div class="detail-label">Fecha de Asignación</div>
                        <div class="detail-value">
                            <%= fechaAsignacion != null ? new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd").parse(fechaAsignacion)) : "-" %>
                        </div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">Kilometraje de Inicio</div>
                        <div class="detail-value"><%= String.format("%,d", kilometrajeInicio) %> km</div>
                    </div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-item" style="grid-column: 1 / -1;">
                        <div class="detail-label">Próximo Mantenimiento</div>
                        <div class="detail-value" style="color: #0066cc;">
                            <%= proximoMantenimiento != null ? new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd").parse(proximoMantenimiento)) : "-" %>
                        </div>
                    </div>
                </div>
                
                <!-- Progreso del Mantenimiento -->
                <div class="progress-section">
                    <div class="progress-title">📊 Progreso hasta el próximo mantenimiento</div>
                    <%
                        int kmRecorridos = kilometrajeActual - kilometrajeInicio;
                        int kmPorRecorrer = frecuenciaKm;
                        int kmHastaProximo = kmPorRecorrer - (kmRecorridos % kmPorRecorrer);
                        double porcentaje = ((double)(kmRecorridos % kmPorRecorrer) / kmPorRecorrer) * 100;
                        
                        if (porcentaje > 100) porcentaje = 100;
                    %>
                    <div class="progress-bar-custom">
                        <div class="progress-fill" style="width: <%= porcentaje %>%">
                            <%= String.format("%.1f", porcentaje) %>%
                        </div>
                    </div>
                    <div class="mt-3 text-center">
                        <strong>Faltan <%= String.format("%,d", kmHastaProximo) %> km</strong> para el próximo mantenimiento
                    </div>
                </div>
                
                <!-- Alertas -->
                <%
                    try {
                        java.util.Date hoy = new java.util.Date();
                        java.util.Date fechaProximo = new SimpleDateFormat("yyyy-MM-dd").parse(proximoMantenimiento);
                        long diffMillis = fechaProximo.getTime() - hoy.getTime();
                        long diasRestantes = diffMillis / (1000 * 60 * 60 * 24);
                        
                        if (diasRestantes < 0) {
                %>
                            <div class="alert-box danger">
                                <strong>⚠️ ATENCIÓN:</strong> El mantenimiento está <strong>vencido hace <%= Math.abs(diasRestantes) %> días</strong>. 
                                Programe el servicio lo antes posible.
                            </div>
                <%
                        } else if (diasRestantes <= 7) {
                %>
                            <div class="alert-box">
                                <strong>⏰ RECORDATORIO:</strong> El próximo mantenimiento es en <strong><%= diasRestantes %> días</strong>. 
                                Prepare el vehículo para el servicio.
                            </div>
                <%
                        } else {
                %>
                            <div class="alert-box success">
                                <strong>✅ TODO AL DÍA:</strong> El próximo mantenimiento es en <strong><%= diasRestantes %> días</strong>.
                            </div>
                <%
                        }
                    } catch (Exception e) {
                        // Error al calcular días
                    }
                %>
            </div>
        <% } else { %>
            <!-- No tiene plan -->
            <div class="empty-state">
                <div class="empty-icon">📋</div>
                <div class="empty-text">No hay plan de mantenimiento asignado</div>
                <div class="empty-subtext">Este vehículo aún no tiene un plan de mantenimiento configurado</div>
                <button class="btn btn-primary mt-4" onclick="alert('Funcionalidad en desarrollo')">
                    ➕ Crear Plan de Mantenimiento
                </button>
            </div>
        <% } %>
        
        <div class="mt-4">
            <a href="<%= request.getContextPath() %>/Vistas/vehiculos.jsp" class="btn btn-secondary">← Volver a Vehículos</a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>