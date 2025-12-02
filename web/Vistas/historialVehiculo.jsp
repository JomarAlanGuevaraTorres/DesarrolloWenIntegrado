<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="modelo.HistorialMantenimiento" %>
<%@ page import="modelo.Vehiculo" %>
<%@ page import="dao.HistorialMantenimientoDAO" %>
<%@ page import="dao.VehiculoDAO" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    // Obtener ID del vehículo
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("vehiculos.jsp");
        return;
    }
    
    int idVehiculo = Integer.parseInt(idParam);
    
    // Obtener datos del vehículo
    VehiculoDAO vehDAO = new VehiculoDAO();
    Vehiculo vehiculo = vehDAO.buscarPorId(idVehiculo);
    
    if (vehiculo == null) {
        response.sendRedirect("vehiculos.jsp");
        return;
    }
    
    // Obtener historial
    HistorialMantenimientoDAO histDAO = new HistorialMantenimientoDAO();
    List<HistorialMantenimiento> historial = histDAO.listarPorVehiculo(idVehiculo);
    
    // Calcular estadísticas
    double costoTotal = histDAO.obtenerCostoTotalVehiculo(idVehiculo);
    int totalPreventivos = histDAO.contarPorTipo(idVehiculo, "Preventivo");
    int totalCorrectivos = histDAO.contarPorTipo(idVehiculo, "Correctivo");
    
    // Formateadores
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Mantenimiento - <%= vehiculo.getPlaca() %></title>
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
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
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
        
        .header-section {
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
        }
        
        .info-value {
            font-size: 20px;
            font-weight: 600;
        }
        
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #0066cc;
        }
        
        .stat-card.success {
            border-left-color: #28a745;
        }
        
        .stat-card.warning {
            border-left-color: #ffc107;
        }
        
        .stat-card.danger {
            border-left-color: #dc3545;
        }
        
        .stat-label {
            font-size: 13px;
            color: #6c757d;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #212529;
        }
        
        .timeline {
            position: relative;
            padding-left: 40px;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: linear-gradient(to bottom, #0066cc, #e9ecef);
        }
        
        .timeline-item {
            position: relative;
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }
        
        .timeline-item:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
            transform: translateX(5px);
        }
        
        .timeline-marker {
            position: absolute;
            left: -33px;
            top: 30px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background-color: #0066cc;
            border: 3px solid white;
            box-shadow: 0 0 0 3px #0066cc;
        }
        
        .timeline-marker.preventivo {
            background-color: #28a745;
            box-shadow: 0 0 0 3px #28a745;
        }
        
        .timeline-marker.correctivo {
            background-color: #dc3545;
            box-shadow: 0 0 0 3px #dc3545;
        }
        
        .timeline-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .timeline-title {
            font-size: 18px;
            font-weight: 600;
            color: #212529;
        }
        
        .timeline-date {
            font-size: 14px;
            color: #6c757d;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .badge-preventivo {
            background-color: #d4edda;
            color: #155724;
        }
        
        .badge-correctivo {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .timeline-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin: 15px 0;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        
        .detail-item {
            font-size: 13px;
        }
        
        .detail-label {
            color: #6c757d;
            font-weight: 500;
            margin-bottom: 3px;
        }
        
        .detail-value {
            color: #212529;
            font-weight: 600;
        }
        
        .timeline-description {
            margin: 15px 0;
            padding: 15px;
            background-color: #fff8e1;
            border-left: 3px solid #ffc107;
            border-radius: 4px;
        }
        
        .timeline-description h4 {
            color: #856404;
            font-size: 13px;
            margin-bottom: 8px;
            text-transform: uppercase;
        }
        
        .timeline-description p {
            color: #212529;
            line-height: 1.6;
            white-space: pre-line;
        }
        
        .timeline-work {
            margin: 15px 0;
            padding: 15px;
            background-color: #e3f2fd;
            border-left: 3px solid #0066cc;
            border-radius: 4px;
        }
        
        .timeline-work h4 {
            color: #004085;
            font-size: 13px;
            margin-bottom: 8px;
            text-transform: uppercase;
        }
        
        .timeline-work p {
            color: #212529;
            line-height: 1.6;
            white-space: pre-line;
        }
        
        .timeline-parts {
            margin: 15px 0;
            padding: 15px;
            background-color: #f3e5f5;
            border-left: 3px solid #9c27b0;
            border-radius: 4px;
        }
        
        .timeline-parts h4 {
            color: #6a1b9a;
            font-size: 13px;
            margin-bottom: 8px;
            text-transform: uppercase;
        }
        
        .timeline-parts p {
            color: #212529;
            line-height: 1.6;
        }
        
        .timeline-costs {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #dee2e6;
        }
        
        .cost-item {
            text-align: center;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 6px;
        }
        
        .cost-label {
            font-size: 11px;
            color: #6c757d;
            margin-bottom: 5px;
            text-transform: uppercase;
        }
        
        .cost-value {
            font-size: 16px;
            font-weight: 700;
            color: #212529;
        }
        
        .cost-total {
            background-color: #0066cc;
            color: white;
        }
        
        .cost-total .cost-label {
            color: rgba(255,255,255,0.9);
        }
        
        .cost-total .cost-value {
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
        
        .empty-text {
            font-size: 18px;
            color: #6c757d;
        }
        
        @media print {
            .back-link {
                display: none;
            }
            
            .timeline-item {
                page-break-inside: avoid;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="vehiculos.jsp" class="back-link">← Volver a Vehículos</a>
        
        <div class="header-section">
            <h1>📋 Historial de Mantenimiento</h1>
            <div class="vehicle-info">
                <div class="info-item">
                    <div class="info-label">Placa</div>
                    <div class="info-value"><%= vehiculo.getPlaca() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Marca / Modelo</div>
                    <div class="info-value"><%= vehiculo.getMarca() %> <%= vehiculo.getModelo() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Año</div>
                    <div class="info-value"><%= vehiculo.getAño() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Kilometraje Actual</div>
                    <div class="info-value"><%= String.format("%,d", vehiculo.getKilometrajeActual()) %> km</div>
                </div>
            </div>
        </div>
        
        <div class="stats-section">
            <div class="stat-card success">
                <div class="stat-label">Mantenimientos Preventivos</div>
                <div class="stat-value"><%= totalPreventivos %></div>
            </div>
            <div class="stat-card danger">
                <div class="stat-label">Mantenimientos Correctivos</div>
                <div class="stat-value"><%= totalCorrectivos %></div>
            </div>
            <div class="stat-card warning">
                <div class="stat-label">Total de Mantenimientos</div>
                <div class="stat-value"><%= historial.size() %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Costo Total Invertido</div>
                <div class="stat-value">S/ <%= df.format(costoTotal) %></div>
            </div>
        </div>
        
        <% if (historial != null && !historial.isEmpty()) { %>
        <div class="timeline">
            <% for (HistorialMantenimiento h : historial) { 
                String tipoClase = h.getTipoMantenimiento().toLowerCase();
            %>
            <div class="timeline-item">
                <div class="timeline-marker <%= tipoClase %>"></div>
                
                <div class="timeline-header">
                    <div>
                        <h3 class="timeline-title"><%= h.getDescripcion() %></h3>
                        <span class="badge badge-<%= tipoClase %>"><%= h.getTipoMantenimiento() %></span>
                    </div>
                    <div class="timeline-date">
                        📅 <%= sdf.format(h.getFechaMantenimiento()) %>
                    </div>
                </div>
                
                <div class="timeline-details">
                    <div class="detail-item">
                        <div class="detail-label">Kilometraje</div>
                        <div class="detail-value"><%= String.format("%,d", h.getKilometraje()) %> km</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Técnico Responsable</div>
                        <div class="detail-value"><%= h.getNombreTecnico() != null ? h.getNombreTecnico() : "No asignado" %></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Estado</div>
                        <div class="detail-value"><%= h.getEstado() %></div>
                    </div>
                </div>
                
                <% if (h.getDetalleTrabajos() != null && !h.getDetalleTrabajos().isEmpty()) { %>
                <div class="timeline-work">
                    <h4>🔧 Trabajos Realizados</h4>
                    <p><%= h.getDetalleTrabajos() %></p>
                </div>
                <% } %>
                
                <% if (h.getRepuestosUsados() != null && !h.getRepuestosUsados().isEmpty()) { %>
                <div class="timeline-parts">
                    <h4>🔩 Repuestos Utilizados</h4>
                    <p><%= h.getRepuestosUsados() %></p>
                </div>
                <% } %>
                
                <% if (h.getObservaciones() != null && !h.getObservaciones().isEmpty()) { %>
                <div class="timeline-description">
                    <h4>📝 Observaciones</h4>
                    <p><%= h.getObservaciones() %></p>
                </div>
                <% } %>
                
                <div class="timeline-costs">
                    <div class="cost-item">
                        <div class="cost-label">Mano de Obra</div>
                        <div class="cost-value">S/ <%= df.format(h.getCostoManoObra()) %></div>
                    </div>
                    <div class="cost-item">
                        <div class="cost-label">Repuestos</div>
                        <div class="cost-value">S/ <%= df.format(h.getCostoRepuestos()) %></div>
                    </div>
                    <div class="cost-item cost-total">
                        <div class="cost-label">Total</div>
                        <div class="cost-value">S/ <%= df.format(h.getCostoTotal()) %></div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="empty-state">
            <div class="empty-icon">📝</div>
            <div class="empty-text">No hay historial de mantenimiento registrado para este vehículo</div>
        </div>
        <% } %>
    </div>
    
    <script>
        // Agregar animaciones al scroll
        const timelineItems = document.querySelectorAll('.timeline-item');
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateX(0)';
                }
            });
        }, {
            threshold: 0.1
        });
        
        timelineItems.forEach(item => {
            item.style.opacity = '0';
            item.style.transform = 'translateX(-20px)';
            item.style.transition = 'all 0.5s ease';
            observer.observe(item);
        });
    </script>
</body>
</html>