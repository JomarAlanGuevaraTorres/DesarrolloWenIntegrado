<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.OrdenTrabajo" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    OrdenTrabajo orden = (OrdenTrabajo) request.getAttribute("orden");
    if (orden == null) {
        response.sendRedirect(request.getContextPath() + "/Vistas/ordenes.jsp");
        return;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ver Orden de Trabajo - <%= orden.getIdOT() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .detail-card { background: white; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .detail-label { font-weight: 600; color: #6c757d; font-size: 13px; text-transform: uppercase; }
        .detail-value { font-size: 16px; color: #212529; margin-top: 5px; }
        .badge-custom { padding: 8px 16px; border-radius: 6px; font-size: 14px; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="mb-4">
            <a href="<%= request.getContextPath() %>/Vistas/ordenes.jsp" class="btn btn-secondary">← Volver a Órdenes</a>
        </div>
        
        <div class="detail-card">
            <h2 class="mb-4">📋 Detalle de Orden de Trabajo</h2>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <div class="detail-label">ID Orden</div>
                    <div class="detail-value"><strong><%= orden.getIdOT() %></strong></div>
                </div>
                
                <div class="col-md-6 mb-3">
                    <div class="detail-label">Estado</div>
                    <div class="detail-value">
                        <% 
                        String badgeClass = "";
                        if ("En Proceso".equals(orden.getEstado())) badgeClass = "bg-warning text-dark";
                        else if ("Completado".equals(orden.getEstado())) badgeClass = "bg-success";
                        else if ("Abierta".equals(orden.getEstado())) badgeClass = "bg-info text-dark";
                        %>
                        <span class="badge <%= badgeClass %> badge-custom"><%= orden.getEstado() %></span>
                    </div>
                </div>
            </div>
            
            <hr>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <div class="detail-label">Vehículo (Placa)</div>
                    <div class="detail-value"><%= orden.getPlaca() %></div>
                </div>
                
                <div class="col-md-6 mb-3">
                    <div class="detail-label">Tipo de Mantenimiento</div>
                    <div class="detail-value"><%= orden.getTipo() %></div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <div class="detail-label">Técnico Asignado</div>
                    <div class="detail-value"><%= orden.getNombreTecnico() != null ? orden.getNombreTecnico() : "Sin asignar" %></div>
                </div>
                
                <div class="col-md-6 mb-3">
                    <div class="detail-label">Kilometraje</div>
                    <div class="detail-value"><%= String.format("%,d", orden.getKilometraje()) %> km</div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <div class="detail-label">Fecha de Emisión</div>
                    <div class="detail-value"><%= orden.getFechaEmision() != null ? sdf.format(orden.getFechaEmision()) : "-" %></div>
                </div>
                
                <div class="col-md-6 mb-3">
                    <div class="detail-label">Fecha de Finalización</div>
                    <div class="detail-value"><%= orden.getFechaFin() != null ? sdf.format(orden.getFechaFin()) : "Pendiente" %></div>
                </div>
            </div>
            
            <hr>
            
            <div class="mb-3">
                <div class="detail-label">Diagnóstico</div>
                <div class="detail-value"><%= orden.getDiagnostico() != null ? orden.getDiagnostico() : "-" %></div>
            </div>
            
            <div class="mb-3">
                <div class="detail-label">Observaciones</div>
                <div class="detail-value"><%= orden.getObservaciones() != null && !orden.getObservaciones().isEmpty() ? orden.getObservaciones() : "Sin observaciones" %></div>
            </div>
            
            <div class="mt-4">
                <a href="<%= request.getContextPath() %>/EditarOrdenServlet?id=<%= orden.getIdOT() %>" class="btn btn-primary">✏️ Editar</a>
                <a href="<%= request.getContextPath() %>/Vistas/ordenes.jsp" class="btn btn-secondary">Cerrar</a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>