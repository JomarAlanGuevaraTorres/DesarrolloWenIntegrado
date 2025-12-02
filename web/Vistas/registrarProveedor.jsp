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
    <title>Registrar Proveedor - PERU-ROAD</title>
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
            max-width: 900px;
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
        
        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-row-triple {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
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
        
        .rating-input {
            display: flex;
            gap: 5px;
            align-items: center;
        }
        
        .star {
            font-size: 24px;
            cursor: pointer;
            color: #ddd;
            transition: color 0.2s;
        }
        
        .star.active {
            color: #ffc107;
        }
        
        .star:hover {
            color: #ffc107;
        }
        
        .form-help {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <a href="proveedores.jsp" class="back-link">← Volver a Proveedores</a>
        
        <div class="form-header">
            <h1 class="form-title">🏭 Registrar Nuevo Proveedor</h1>
            <p class="form-subtitle">Complete la información del proveedor</p>
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
        
        <form action="<%= request.getContextPath() %>/RegistrarProveedorServlet" method="post" onsubmit="return validarFormulario()">
            <div class="form-group">
                <label class="form-label required" for="razonSocial">Razón Social / Nombre Comercial</label>
                <input type="text" class="form-control" id="razonSocial" name="razonSocial" 
                       placeholder="Ej: Repuestos del Norte S.A.C." required maxlength="200">
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="contacto">Persona de Contacto</label>
                    <input type="text" class="form-control" id="contacto" name="contacto" 
                           placeholder="Nombre del contacto principal" maxlength="100">
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="telefono">Teléfono</label>
                    <input type="tel" class="form-control" id="telefono" name="telefono" 
                           placeholder="(044) 123-4567" maxlength="20">
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="email">Correo Electrónico</label>
                <input type="email" class="form-control" id="email" name="email" 
                       placeholder="contacto@proveedor.com" maxlength="100">
                <div class="form-help">Correo electrónico para comunicaciones y pedidos</div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="direccion">Dirección Completa</label>
                <textarea class="form-control" id="direccion" name="direccion" 
                          placeholder="Av. Principal 123, Distrito, Ciudad" maxlength="200"></textarea>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="calificacion">Calificación</label>
                    <div class="rating-input">
                        <span class="star" data-value="1">⭐</span>
                        <span class="star" data-value="2">⭐</span>
                        <span class="star" data-value="3">⭐</span>
                        <span class="star" data-value="4">⭐</span>
                        <span class="star" data-value="5">⭐</span>
                        <input type="hidden" id="calificacion" name="calificacion" value="0">
                    </div>
                    <div class="form-help">Califica la calidad del proveedor (1-5 estrellas)</div>
                </div>
                
                <div class="form-group">
                    <label class="form-label required" for="idAlmacen">Almacén Asociado</label>
                    <select class="form-control" id="idAlmacen" name="idAlmacen" required>
                        <option value="">Seleccione un almacén</option>
                        <option value="1">Almacén Central - Piso 1 Sector A</option>
                        <option value="2">Almacén Norte - Almacén Principal</option>
                    </select>
                    <div class="form-help">Almacén al que suministra este proveedor</div>
                </div>
            </div>
            
            <div class="button-group">
                <button type="submit" class="btn btn-primary">💾 Guardar Proveedor</button>
                <button type="button" class="btn btn-secondary" onclick="window.location.href='<%= request.getContextPath() %>/ListarProveedoresServlet'">
                    ❌ Cancelar
                </button>
            </div>
        </form>
    </div>
    
    <script>
        // Sistema de calificación con estrellas
        const stars = document.querySelectorAll('.star');
        const calificacionInput = document.getElementById('calificacion');
        
        stars.forEach(star => {
            star.addEventListener('click', function() {
                const value = this.getAttribute('data-value');
                calificacionInput.value = value;
                
                // Actualizar visualización de estrellas
                stars.forEach(s => {
                    const starValue = s.getAttribute('data-value');
                    if (starValue <= value) {
                        s.classList.add('active');
                    } else {
                        s.classList.remove('active');
                    }
                });
            });
            
            // Efecto hover
            star.addEventListener('mouseenter', function() {
                const value = this.getAttribute('data-value');
                stars.forEach(s => {
                    const starValue = s.getAttribute('data-value');
                    if (starValue <= value) {
                        s.style.color = '#ffc107';
                    }
                });
            });
        });
        
        // Resetear hover
        document.querySelector('.rating-input').addEventListener('mouseleave', function() {
            const currentValue = calificacionInput.value;
            stars.forEach(s => {
                const starValue = s.getAttribute('data-value');
                if (starValue <= currentValue) {
                    s.style.color = '#ffc107';
                } else {
                    s.style.color = '#ddd';
                }
            });
        });
        
        function validarFormulario() {
            const razonSocial = document.getElementById('razonSocial').value.trim();
            const idAlmacen = document.getElementById('idAlmacen').value;
            
            if (!razonSocial) {
                alert('Por favor, ingrese la razón social del proveedor');
                return false;
            }
            
            if (!idAlmacen) {
                alert('Por favor, seleccione un almacén');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>