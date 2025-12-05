<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.OrdenTrabajo" %>
<%@ page import="modelo.Vehiculo" %>
<%@ page import="dao.VehiculoDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String usuarioLogueado = (String) session.getAttribute("usuario");
    
    OrdenTrabajo orden = (OrdenTrabajo) request.getAttribute("orden");
    if (orden == null) {
        response.sendRedirect("ordenes.jsp");
        return;
    }
    
    VehiculoDAO vehDAO = new VehiculoDAO();
    List<Vehiculo> listaVehiculos = vehDAO.listarVehiculos();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Orden de Trabajo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="mb-4">
            <a href="ordenes.jsp" class="btn btn-secondary">← Volver a Órdenes</a>
        </div>
        
        <div class="card shadow-sm">
            <div class="card-body p-4">
                <h2 class="mb-4">✏️ Editar Orden de Trabajo: <%= orden.getIdOT() %></h2>
                
                <form action="../ActualizarOrdenServlet" method="POST">
                    <input type="hidden" name="idOT" value="<%= orden.getIdOT() %>">
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Vehículo <span class="text-danger">*</span></label>
                            <select class="form-select" name="idVehiculo" required>
                                <% for (Vehiculo v : listaVehiculos) { %>
                                    <option value="<%= v.getIdVehiculo() %>" <%= v.getIdVehiculo() == orden.getIdVehiculo() ? "selected" : "" %>>
                                        <%= v.getPlaca() %> - <%= v.getMarca() %> <%= v.getModelo() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Kilometraje <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="kilometrajeActual" value="<%= orden.getKilometraje() %>" required>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Tipo <span class="text-danger">*</span></label>
                            <select class="form-select" name="tipo" required>
                                <option value="Mantenimiento Preventivo" <%= "Mantenimiento Preventivo".equals(orden.getTipo()) ? "selected" : "" %>>Mantenimiento Preventivo</option>
                                <option value="Mantenimiento Correctivo" <%= "Mantenimiento Correctivo".equals(orden.getTipo()) ? "selected" : "" %>>Mantenimiento Correctivo</option>
                                <option value="Reparación" <%= "Reparación".equals(orden.getTipo()) ? "selected" : "" %>>Reparación</option>
                                <option value="Inspección" <%= "Inspección".equals(orden.getTipo()) ? "selected" : "" %>>Inspección</option>
                            </select>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Estado <span class="text-danger">*</span></label>
                            <select class="form-select" name="estado" required>
                                <option value="Abierta" <%= "Abierta".equals(orden.getEstado()) ? "selected" : "" %>>Abierta</option>
                                <option value="En Proceso" <%= "En Proceso".equals(orden.getEstado()) ? "selected" : "" %>>En Proceso</option>
                                <option value="Completado" <%= "Completado".equals(orden.getEstado()) ? "selected" : "" %>>Completado</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Fecha de Emisión <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" name="fechaEmision" value="<%= orden.getFechaEmision() != null ? sdf.format(orden.getFechaEmision()) : "" %>" required>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Fecha de Finalización</label>
                            <input type="date" class="form-control" name="fechaFin" value="<%= orden.getFechaFin() != null ? sdf.format(orden.getFechaFin()) : "" %>">
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Técnico Asignado</label>
                        <select class="form-select" name="idTecnico">
                            <option value="">Sin asignar</option>
                            <option value="1" <%= orden.getIdTecnico() == 1 ? "selected" : "" %>>Juan Pérez</option>
                            <option value="2" <%= orden.getIdTecnico() == 2 ? "selected" : "" %>>María López</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Diagnóstico <span class="text-danger">*</span></label>
                        <textarea class="form-control" name="diagnostico" rows="3" required><%= orden.getDiagnostico() != null ? orden.getDiagnostico() : "" %></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Observaciones</label>
                        <textarea class="form-control" name="observaciones" rows="3"><%= orden.getObservaciones() != null ? orden.getObservaciones() : "" %></textarea>
                    </div>
                    
                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">💾 Guardar Cambios</button>
                        <a href="ordenes.jsp" class="btn btn-secondary">Cancelar</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>