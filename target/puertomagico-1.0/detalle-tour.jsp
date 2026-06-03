<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle del Tour - Puerto Magico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --naranja: #F5A623;
            --naranja-dark: #D48A10;
            --azul: #2E86AB;
        }
        .navbar { border-bottom: 3px solid var(--naranja); }
        .btn-naranja {
            background-color: var(--naranja);
            border-color: var(--naranja);
            color: #fff;
            font-weight: 600;
        }
        .btn-naranja:hover {
            background-color: var(--naranja-dark);
            color: #fff;
        }
        /* Banner superior del tour */
        .tour-banner {
            background-color: #e8f4f9;
            height: 200px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        /* Caja de reserva — se queda fija al hacer scroll */
        .reserva-box {
            position: sticky;
            top: 80px;
        }
        .precio-grande {
            font-size: 2rem;
            font-weight: 700;
            color: var(--naranja-dark);
        }
    </style>
</head>
<body class="bg-light">

    <!-- NAVBAR -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                Puerto<span style="color:var(--naranja)">Magico</span>
            </a>
            <div class="d-flex gap-2" id="nav-sesion">
                <a href="login.jsp"
                   class="btn btn-outline-secondary btn-sm">
                    Iniciar sesion
                </a>
                <a href="registro.jsp"
                   class="btn btn-naranja btn-sm">
                    Registrarse
                </a>
            </div>
            <div class="d-none" id="nav-usuario">
                <span class="text-muted small me-2"
                      id="nav-nombre"></span>
                <button class="btn btn-outline-danger btn-sm"
                        onclick="cerrarSesion()">
                    Salir
                </button>
            </div>
        </div>
    </nav>

    <!-- MIGA DE PAN (breadcrumb) -->
    <div class="bg-white border-bottom py-2">
        <div class="container">
            <nav aria-label="breadcrumb">
                <!--
                    Bootstrap breadcrumb — muestra la ruta
                    de navegacion: Inicio / Tours / Nombre del tour
                -->
                <ol class="breadcrumb mb-0 small">
                    <li class="breadcrumb-item">
                        <a href="index.jsp"
                           class="text-decoration-none">
                            Inicio
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="tours.jsp"
                           class="text-decoration-none">
                            Tours
                        </a>
                    </li>
                    <li class="breadcrumb-item active"
                        id="breadcrumb-tour">
                        Cargando...
                    </li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container py-4">
        <div class="row g-4">

            <!-- COLUMNA IZQUIERDA: Detalle del tour -->
            <div class="col-lg-8">

                <!-- Banner -->
                <div class="tour-banner mb-4">
                    <i class="bi bi-map"
                       style="font-size:4rem;color:#2E86AB"></i>
                </div>

                <!-- Titulo y badges -->
                <div class="mb-4">
                    <div class="d-flex gap-2 mb-2" id="tour-tags">
                        <!-- Se llena con JS -->
                    </div>
                    <h2 class="fw-bold" id="tour-nombre">Cargando...</h2>
                    <p class="text-muted" id="tour-destino"></p>
                </div>

                <!-- Datos rapidos con iconos Bootstrap -->
                <div class="row g-3 mb-4" id="tour-datos">
                    <!-- Se llena con JS -->
                </div>

                <!-- Descripcion -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="fw-bold mb-3">Descripcion</h5>
                        <p class="text-muted mb-0" id="tour-descripcion">
                            Cargando...
                        </p>
                    </div>
                </div>

                <!-- Itinerario -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="fw-bold mb-3">Itinerario</h5>
                        <div id="tour-paradas">
                            <p class="text-muted small">
                                Sin paradas registradas.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Que incluye -->
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <h5 class="fw-bold mb-3">Que incluye</h5>
                        <div class="row g-2">
                            <div class="col-md-6">
                                <span class="text-success me-2">
                                    <i class="bi bi-check-circle-fill"></i>
                                </span>
                                Transporte ida y vuelta
                            </div>
                            <div class="col-md-6">
                                <span class="text-success me-2">
                                    <i class="bi bi-check-circle-fill"></i>
                                </span>
                                Guia certificado
                            </div>
                            <div class="col-md-6">
                                <span class="text-success me-2">
                                    <i class="bi bi-check-circle-fill"></i>
                                </span>
                                Entradas incluidas
                            </div>
                            <div class="col-md-6">
                                <span class="text-success me-2">
                                    <i class="bi bi-check-circle-fill"></i>
                                </span>
                                Agua embotellada
                            </div>
                            <div class="col-md-6">
                                <span class="text-danger me-2">
                                    <i class="bi bi-x-circle-fill"></i>
                                </span>
                                Vuelos
                            </div>
                            <div class="col-md-6">
                                <span class="text-danger me-2">
                                    <i class="bi bi-x-circle-fill"></i>
                                </span>
                                Hospedaje
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- COLUMNA DERECHA: Caja de reserva -->
            <div class="col-lg-4">
                <div class="reserva-box">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4">

                            <!-- Precio -->
                            <div class="precio-grande mb-1"
                                 id="reserva-precio">
                                $---
                            </div>
                            <p class="text-muted small mb-3">
                                por persona
                            </p>

                            <!-- Disponibilidad -->
                            <div class="alert alert-success py-2
                                        small mb-3"
                                 id="disponibilidad">
                                <i class="bi bi-check-circle me-1"></i>
                                Cargando disponibilidad...
                            </div>

                            <!-- Fecha -->
                            <div class="mb-3">
                                <label class="form-label
                                              fw-semibold small">
                                    Fecha del tour
                                </label>
                                <input type="date"
                                       class="form-control"
                                       id="fecha-tour">
                            </div>

                            <!-- Personas -->
                            <div class="mb-3">
                                <label class="form-label
                                              fw-semibold small">
                                    Numero de personas
                                </label>
                                <select class="form-select"
                                        id="num-personas"
                                        onchange="calcularTotal()">
                                    <option value="1">1 persona</option>
                                    <option value="2" selected>2 personas</option>
                                    <option value="3">3 personas</option>
                                    <option value="4">4 personas</option>
                                    <option value="5">5 personas</option>
                                </select>
                            </div>

                            <!-- Resumen de precio -->
                            <div class="bg-light rounded p-3 mb-3">
                                <div class="d-flex justify-content-between
                                            small mb-1">
                                    <span id="desc-precio">
                                        $0 x 2 personas
                                    </span>
                                    <span id="subtotal">$0</span>
                                </div>
                                <div class="d-flex justify-content-between
                                            small mb-2">
                                    <span>Cargo servicio (10%)</span>
                                    <span id="cargo">$0</span>
                                </div>
                                <div class="d-flex justify-content-between
                                            fw-bold border-top pt-2">
                                    <span>Total</span>
                                    <span id="total"
                                          style="color:var(--naranja-dark)">
                                        $0
                                    </span>
                                </div>
                            </div>

                            <button class="btn btn-naranja w-100 py-2"
                                    onclick="continuarReserva()">
                                <i class="bi bi-calendar-check me-1"></i>
                                Continuar al pago
                            </button>

                            <p class="text-muted text-center
                                      small mt-2 mb-0">
                                <i class="bi bi-shield-check me-1"></i>
                                Pago seguro
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-4">
        <small>
            &copy; 2026 Puerto<span style="color:var(--naranja)">Magico</span>
            &middot; Universidad Veracruzana
        </small>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const BASE  = '/PuertoMagico';
        const id    = new URLSearchParams(window.location.search).get('id');
        let precioBase = 0;

        window.onload = function () {
            verificarSesion();
            if (id) cargarTour(id);
        };

        async function verificarSesion() {
            try {
                const res  = await fetch(BASE + '/api/usuarios/sesion');
                const data = await res.json();
                if (!data.error) {
                    document.getElementById('nav-sesion')
                        .classList.add('d-none');
                    document.getElementById('nav-usuario')
                        .classList.remove('d-none');
                    document.getElementById('nav-nombre')
                        .textContent = data.nombre;
                }
            } catch (e) {}
        }

        async function cerrarSesion() {
            await fetch(BASE + '/api/usuarios/logout');
            window.location.reload();
        }

        async function cargarTour(tourId) {
            try {
                const res  = await fetch(BASE + '/api/tours?id=' + tourId);
                const data = await res.json();

                if (data.error) {
                    alert('Tour no encontrado');
                    window.location.href = 'tours.jsp';
                    return;
                }

                const tour = data.tour;
                llenarDatos(tour, data.lugaresDisponibles);

            } catch (e) {
                alert('Error al cargar el tour');
            }
        }

        function llenarDatos(tour, disponibles) {
            document.title = tour.nombre + ' - Puerto Magico';
            document.getElementById('breadcrumb-tour')
                .textContent = tour.nombre;
            document.getElementById('tour-nombre')
                .textContent = tour.nombre;
            document.getElementById('tour-destino')
                .innerHTML =
                '<i class="bi bi-geo-alt"></i> ' +
                (tour.nombreDestino || 'Mexico');
            document.getElementById('tour-descripcion')
                .textContent = tour.descripcion || 'Sin descripcion.';

            // Badge de dificultad
            const badgeClass = tour.dificultad === 'FACIL'
                ? 'bg-success'
                : tour.dificultad === 'MODERADA'
                ? 'bg-warning text-dark'
                : 'bg-danger';
            document.getElementById('tour-tags').innerHTML =
                `<span class="badge ${badgeClass}">
                    ${tour.dificultad || 'FACIL'}
                </span>`;

            // Datos rapidos en tarjetas pequeñas
            document.getElementById('tour-datos').innerHTML = `
                <div class="col-6 col-md-3">
                    <div class="card border-0 bg-white shadow-sm
                                text-center p-3">
                        <i class="bi bi-clock fs-4
                                  text-primary mb-1"></i>
                        <div class="fw-bold">${tour.duracionHoras} hrs</div>
                        <small class="text-muted">Duracion</small>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="card border-0 bg-white shadow-sm
                                text-center p-3">
                        <i class="bi bi-people fs-4
                                  text-primary mb-1"></i>
                        <div class="fw-bold">${tour.cupoMaximo}</div>
                        <small class="text-muted">Cupo max.</small>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="card border-0 bg-white shadow-sm
                                text-center p-3">
                        <i class="bi bi-check-circle fs-4
                                  text-success mb-1"></i>
                        <div class="fw-bold">${disponibles}</div>
                        <small class="text-muted">Disponibles</small>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="card border-0 bg-white shadow-sm
                                text-center p-3">
                        <i class="bi bi-bar-chart fs-4
                                  text-warning mb-1"></i>
                        <div class="fw-bold">${tour.dificultad}</div>
                        <small class="text-muted">Dificultad</small>
                    </div>
                </div>
            `;

            // Precio en la caja de reserva
            precioBase = Number(tour.precioBase);
            document.getElementById('reserva-precio').textContent =
                '$' + precioBase.toLocaleString('es-MX');

            // Disponibilidad
            const dispEl = document.getElementById('disponibilidad');
            if (disponibles > 0) {
                dispEl.className = 'alert alert-success py-2 small mb-3';
                dispEl.innerHTML =
                    '<i class="bi bi-check-circle me-1"></i>' +
                    disponibles + ' lugares disponibles';
            } else {
                dispEl.className = 'alert alert-danger py-2 small mb-3';
                dispEl.innerHTML =
                    '<i class="bi bi-x-circle me-1"></i>' +
                    'Sin disponibilidad';
            }

            calcularTotal();
        }

        function calcularTotal() {
            const personas = parseInt(
                document.getElementById('num-personas').value);
            const subtotal = precioBase * personas;
            const cargo    = Math.round(subtotal * 0.10);
            const total    = subtotal + cargo;

            document.getElementById('desc-precio').textContent =
                '$' + precioBase.toLocaleString('es-MX') +
                ' x ' + personas + ' persona' +
                (personas > 1 ? 's' : '');
            document.getElementById('subtotal').textContent =
                '$' + subtotal.toLocaleString('es-MX');
            document.getElementById('cargo').textContent =
                '$' + cargo.toLocaleString('es-MX');
            document.getElementById('total').textContent =
                '$' + total.toLocaleString('es-MX');
        }

        async function continuarReserva() {
            const fecha = document.getElementById('fecha-tour').value;
            if (!fecha) {
                alert('Selecciona una fecha para el tour.');
                return;
            }
            try {
                const res  = await fetch(BASE + '/api/usuarios/sesion');
                const data = await res.json();
                if (data.error) {
                    alert('Debes iniciar sesion para reservar.');
                    window.location.href = 'login.jsp';
                    return;
                }
                // Aqui conectaremos con el flujo de pago
                alert('Reserva en proceso.\nTour ID: ' + id +
                      '\nFecha: ' + fecha);
            } catch (e) {
                alert('Error de conexion.');
            }
        }
    </script>
</body>
</html>