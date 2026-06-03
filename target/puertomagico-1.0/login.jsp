<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar sesion - Puerto Magico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"
          rel="stylesheet">
    <style>
        :root {
            --naranja: #F5A623;
            --naranja-dark: #D48A10;
            --azul: #2E86AB;
            --gris: #2D2D2D;
        }
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar {
            border-bottom: 3px solid var(--naranja);
            background: #fff !important;
        }
        .navbar-brand { font-weight: 700; color: var(--gris) !important; }
        .navbar-brand span { color: var(--naranja); }
        .btn-primary {
            background-color: var(--naranja);
            border-color: var(--naranja);
            font-weight: 600;
        }
        .btn-primary:hover {
            background-color: var(--naranja-dark);
            border-color: var(--naranja-dark);
        }
        /* Contenedor centrado verticalmente */
        .login-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        .login-card {
            width: 100%;
            max-width: 420px;
            border: none;
            border-radius: 14px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.1);
        }
        /* Tabs de tipo Cliente / Admin */
        .tab-selector {
            display: flex;
            background: #f8f9fa;
            border-radius: 8px;
            padding: 4px;
            margin-bottom: 1.5rem;
        }
        .tab-btn {
            flex: 1;
            padding: 8px;
            border: none;
            border-radius: 6px;
            background: none;
            font-weight: 600;
            font-size: .9rem;
            color: #6c757d;
            cursor: pointer;
        }
        .tab-btn.activo {
            background: #fff;
            color: var(--naranja);
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
        }
        .form-control:focus {
            border-color: var(--naranja);
            box-shadow: 0 0 0 .2rem rgba(245,166,35,.2);
        }
        .link-naranja {
            color: var(--naranja);
            font-weight: 600;
            text-decoration: none;
        }
        .link-naranja:hover { color: var(--naranja-dark); }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav class="navbar navbar-expand-lg shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                Puerto<span>Magico</span>
            </a>
            <a href="index.jsp"
               class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left"></i> Volver
            </a>
        </div>
    </nav>

    <!-- FORMULARIO CENTRADO -->
    <div class="login-wrapper">
        <div class="card login-card">
            <div class="card-body p-4">

                <!-- Titulo -->
                <h4 class="fw-bold text-center mb-1">Bienvenido</h4>
                <p class="text-muted text-center small mb-4">
                    Ingresa a tu cuenta de PuertoMagico
                </p>

                <!-- Selector Cliente / Admin -->
                <div class="tab-selector">
                    <button class="tab-btn activo"
                            onclick="cambiarTab(this)">
                        Cliente
                    </button>
                    <button class="tab-btn"
                            onclick="cambiarTab(this)">
                        Administrador
                    </button>
                </div>

                <!-- Alerta de error (oculta por defecto) -->
                <div class="alert alert-danger d-none py-2 small"
                     id="error-msg">
                </div>

                <!-- Formulario -->
                <div class="mb-3">
                    <label class="form-label fw-semibold small">
                        Correo electronico
                    </label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-envelope"></i>
                        </span>
                        <input type="email" class="form-control"
                               id="email"
                               placeholder="tu@correo.com">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold small">
                        Contrasena
                    </label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-lock"></i>
                        </span>
                        <input type="password" class="form-control"
                               id="password"
                               placeholder="Minimo 6 caracteres">
                    </div>
                </div>

                <button class="btn btn-primary w-100 py-2 mb-3"
                        onclick="iniciarSesion()">
                    Iniciar sesion
                </button>

                <hr class="my-3">

                <p class="text-center text-muted small mb-0">
                    No tienes cuenta?
                    <a href="registro.jsp" class="link-naranja">
                        Registrate aqui
                    </a>
                </p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const BASE = '/PuertoMagico';

        function cambiarTab(btn) {
            document.querySelectorAll('.tab-btn')
                .forEach(b => b.classList.remove('activo'));
            btn.classList.add('activo');
        }

        async function iniciarSesion() {
            const email    = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const errorMsg = document.getElementById('error-msg');

            errorMsg.classList.add('d-none');

            if (!email || !password) {
                errorMsg.textContent = 'Por favor llena todos los campos.';
                errorMsg.classList.remove('d-none');
                return;
            }

            try {
                const res  = await fetch(BASE + '/api/usuarios/login', {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body:    JSON.stringify({ email, password })
                });
                const data = await res.json();

                if (data.error) {
                    errorMsg.textContent = data.mensaje;
                    errorMsg.classList.remove('d-none');
                } else {
                    localStorage.setItem('nombreUsuario', data.nombre);
                    localStorage.setItem('rolUsuario', data.rol);
                    window.location.href = data.rol === 'ADMIN'
                        ? 'admin.jsp'
                        : 'index.jsp';
                }
            } catch (e) {
                errorMsg.textContent = 'Error de conexion con el servidor.';
                errorMsg.classList.remove('d-none');
            }
        }
    </script>
</body>
</html>