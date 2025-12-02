<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PERU-ROAD - Login</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            font-family: Arial, sans-serif;
        }
        
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-box {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 450px;
        }
        
        .logo-container {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo-box {
            width: 80px;
            height: 80px;
            border: 2px solid #333;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #333;
        }
        
        .welcome-title {
            text-align: center;
            color: #0066cc;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 30px;
        }
        
        .form-label {
            color: #333;
            font-size: 14px;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border: 2px solid #333;
            border-radius: 4px;
            padding: 8px 12px;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #0066cc;
            box-shadow: none;
        }
        
        .btn-acceder {
            background-color: #ffeb3b;
            color: #000;
            border: 2px solid #333;
            border-radius: 4px;
            padding: 10px 40px;
            font-size: 16px;
            font-weight: 600;
            width: auto;
            display: block;
            margin: 30px auto 0;
            transition: all 0.3s;
        }
        
        .btn-acceder:hover {
            background-color: #fdd835;
            color: #000;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .mb-3 {
            margin-bottom: 20px;
        }
        
        .alert-error {
            background-color: #f8d7de;
            color: #721c24;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="logo-container">
                <div class="logo-box">
                    PERU ROAD
                </div>
            </div>
            
            <h1 class="welcome-title">Bienvenido a PERU-ROAD.</h1>
            
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert-error">
                    <%= error %>
                </div>
            <% } %>
            
            <form action="LoginServlet" method="post">
                <div class="mb-3">
                    <label for="usuario" class="form-label">Ingrese el nombre de usuario</label>
                    <input type="text" class="form-control" id="usuario" name="usuario" placeholder="Usuario" required>
                </div>
                
                <div class="mb-3">
                    <label for="contrasena" class="form-label">Ingrese la contraseña</label>
                    <input type="password" class="form-control" id="contrasena" name="contrasena" placeholder="Contraseña" required>
                </div>
                
                <button type="submit" class="btn btn-acceder">Acceder</button>
            </form>
        </div>
    </div>
</body>
</html>