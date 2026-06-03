<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Puerto Magico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"
          rel="stylesheet">
    <style>
        :root {
            --naranja: #F5A623;
            --naranja-dark: #D48A10;
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
        .registro-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        .registro-card {
            width: 100%;
            max-width: 500px;
            border: none;
            border-radius: 14px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.1);
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

    <div class="registro-wrapper">
        <div class="card registro-card">
            <div class="card-body p-4">

                <h4 class="fw-bold text-center mb-1">Crear cuenta</h4>
                <p class="text-muted text-center small mb-4">
                    Unete a PuertoMagico y empieza a explorar Mexico
                </p>

                <!-- Alerta de error -->
                <div class="alert alert-danger d-none py-2 small"
                     id="error-msg">
                </div>

                <!--
                    Bootstrap Row con 2 columnas para nombre y apellido.
                    g-3 = gutter (espacio entre columnas)
                -->
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">
                            Nombre
                        </label>
                        <input type="text" class="form-control"
                               id="nombre" placeholder="Tu nombre">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">
                            Apellido
                        </label>
                        <input type="text" class="form-control"
                               id="apellido" placeholder="Tu apellido">
                    </div>
                    <div class="col-12">
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
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">
                            Contrasena
                        </label>
                        <input type="password" class="form-control"
                               id="password"
                               placeholder="Minimo 6 caracteres">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">
                            Confirmar contrasena
                        </label>
                        <input type="password" class="form-control"
                               id="confirmar"
                               placeholder="Repite tu contrasena">
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold small">
                            Telefono (opcional)
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-telephone"></i>
                            </span>
                            <input type="tel" class="form-control"
                                   id="telefono"
                                   placeholder="229 123 4567">
                        </div>
                    </div>
                </div>

                <button class="btn btn-primary w-100 py-2 mt-4 mb-3"
                        onclick="registrar()">
                    Crear cuenta
                </button>

                <hr class="my-3">

                <p class="text-center text-muted small mb-0">
                    Ya tienes cuenta?
                    <a href="login.jsp" class="link-naranja">
                        Inicia sesion
                    </a>
                </p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const BASE = '/PuertoMagico';

        async function registrar() {
            const nombre    = document.getElementById('nombre').value.trim();
            const apellido  = document.getElementById('apellido').value.trim();
            const email     = document.getElementById('email').value.trim();
            const password  = document.getElementById('password').value;
            const confirmar = document.getElementById('confirmar').value;
            const telefono  = document.getElementById('telefono').value.trim();
            const errorMsg  = document.getElementById('error-msg');

            errorMsg.classList.add('d-none');

            if (!nombre || !apellido || !email || !password) {
                errorMsg.textContent = 'Todos los campos son obligatorios.';
                errorMsg.classList.remove('d-none');
                return;
            }
            if (password.length < 6) {
                errorMsg.textContent =
                    'La contrasena debe tener minimo 6 caracteres.';
                errorMsg.classList.remove('d-none');
                return;
            }
            if (password !== confirmar) {
                errorMsg.textContent = 'Las contrasenas no coinciden.';
                errorMsg.classList.remove('d-none');
                return;
            }

            try {
                const res = await fetch(BASE + '/api/usuarios/registro', {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body:    JSON.stringify({
                        nombre, apellido, email,
                        passwordHash: password,
                        telefono
                    })
                });
                const data = await res.json();

                if (data.error) {
                    errorMsg.textContent = data.mensaje;
                    errorMsg.classList.remove('d-none');
                } else {
                    alert('Cuenta creada correctamente. Ahora inicia sesion.');
                    window.location.href = 'login.jsp';
                }
            } catch (e) {
                errorMsg.textContent = 'Error de conexion con el servidor.';
                errorMsg.classList.remove('d-none');
            }
        }
    </script>
</body>
</html>