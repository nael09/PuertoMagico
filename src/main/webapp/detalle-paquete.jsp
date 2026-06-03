<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle del Paquete - Puerto Magico</title>
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
        /* Banner superior del paquete */
        .paquete-banner {
            height: 200px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #e8f4f9;
        }
        /* Caja de reserva fija al hacer scroll */
        .reserva-box { position: sticky; top: 80px; }
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
                <a href="registro.jsp" class="btn btn-naranja btn-sm">
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

    <!-- MIGA DE PAN -->
    <div class="bg-white border-bottom py-2">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 small">
                    <li class="breadcrumb-item">
                        <a href="index.jsp"
                           class="text-decoration-none">Inicio</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="paquetes.jsp"
                           class="text-decoration-none">Paquetes</a>
                    </li>
                    <li class="breadcrumb-item active"
                        id="breadcrumb-paquete">
                        Cargando...
                    </li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container py-4">
        <div class="row g-4">

            <!-- COLUMNA IZQUIERDA: Detalle del paquete -->
            <div class="col-lg-8">

                <!-- Banner -->
                <div class="paquete-banner mb-4"
                     id="paquete-banner">
                    <i class="bi bi-bag-heart"
                       style="font-size:4rem;color:var(--azul)"></i>
                </div>

                <!-- Titulo y categoria -->
                <div class="mb-4">
                    <div class="mb-2" id="paquete-badge"></div>
                    <h2 class="fw-bold" id="paquete-nombre">
                        Cargando...
                    </h2>
                    <p class="text-muted" id="paquete-categoria"></p>
                </div>

                <!-- Datos rapidos -->
                <div class="row g-3 mb-4" id="paquete-datos"></div>

                <!-- Descripcion -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="fw-bold mb-3">Descripcion</h5>
                        <p class="text-muted mb-0"
                           id="paquete-descripcion">
                            Cargando...
                        </p>
                    </div>
                </div>

                <!-- Que incluye -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="fw-bold mb-3">Que incluye</h5>
                        <div class="row g-2">
                            <div class="col-md-6">
                                <span class="text-success me-2">
                                    <i class="bi bi-check-circle-fill"></i>
                                </span>
                                Transporte terrestre
                            </div>
                            <div class="col-md-6">
                                <span class="text-success me-2">
                                    <i class="bi bi-check-circle-fill"></i>
                                </span>
                                Hospedaje incluido
                            </div>
                            <div class="col-md-6">
                                <span class="text-success me-2">
                                    <i class="bi bi-check-circle-fill"></i>
                                </span>
                                Tours del itinerario
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
                                Desayunos incluidos
                            </div>
                            <div class="col-md-6">
                                <span class="text-danger me-2">
                                    <i class="bi bi-x-circle-fill"></i>
                                </span>
                                Vuelos
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tours del itinerario -->
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <h5 class="fw-bold mb-3">
                            Itinerario del paquete
                        </h5>
                        <div id="paquete-itinerario">
                            <p class="text-muted small">
                                Cargando itinerario...
                            </p>
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
                                 id="reserva-precio">$---</div>
                            <p class="text-muted small mb-3">
                                por persona — todo incluido
                            </p>

                            <!-- Duracion -->
                            <div class="alert alert-info py-2
                                        small mb-3"
                                 id="paquete-duracion">
                                <i class="bi bi-calendar3 me-1"></i>
                                Cargando...
                            </div>

                            <!-- Disponibilidad -->
                            <div class="alert alert-success py-2
                                        small mb-3"
                                 id="disponibilidad">
                                <i class="bi bi-check-circle me-1"></i>
                                Verificando disponibilidad...
                            </div>

                            <!-- Fecha de inicio -->
                            <div class="mb-3">
                                <label class="form-label
                                              fw-semibold small">
                                    Fecha de inicio
                                </label>
                                <input type="date"
                                       class="form-control"
                                       id="fecha-inicio">
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
                                    <option value="2" selected>
                                        2 personas
                                    </option>
                                    <option value="3">3 personas</option>
                                    <option value="4">4 personas</option>
                                    <option value="5">5 personas</option>
                                </select>
                            </div>

                            <!-- Resumen de precio -->
                            <div class="bg-light rounded p-3 mb-3">
                                <div class="d-flex
                                            justify-content-between
                                            small mb-1">
                                    <span id="desc-precio">
                                        $0 x 2 personas
                                    </span>
                                    <span id="subtotal">$0</span>
                                </div>
                                <div class="d-flex
                                            justify-content-between
                                            small mb-2">
                                    <span>Cargo servicio (10%)</span>
                                    <span id="cargo">$0</span>
                                </div>
                                <div class="d-flex
                                            justify-content-between
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
                                Reservar paquete
                            </button>

                            <p class="text-muted text-center
                                      small mt-2 mb-0">
                                <i class="bi bi-shield-check me-1"></i>
                                Pago seguro garantizado
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
        const BASE = '/PuertoMagico';

        // Leemos el ID del paquete desde la URL: ?id=1
        const id = new URLSearchParams(
            window.location.search).get('id');

        // Guardamos el precio para calcular el total
        let precioBase = 0;

        window.onload = function () {
            verificarSesion();
            if (id) cargarPaquete(id);
            else {
                alert('Paquete no especificado.');
                window.location.href = 'paquetes.jsp';
            }
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

        /**
         * cargarPaquete()
         * Hace GET al PaqueteServlet con el ID del paquete
         * y llena todos los datos en la pagina.
         */
        async function cargarPaquete(paqueteId) {
            try {
                const res  = await fetch(
                    BASE + '/api/paquetes?id=' + paqueteId);
                const data = await res.json();

                if (!data || data.error) {
                    alert('Paquete no encontrado.');
                    window.location.href = 'paquetes.jsp';
                    return;
                }

                llenarDatos(data);

            } catch (e) {
                alert('Error al cargar el paquete.');
            }
        }

        /**
         * llenarDatos()
         * Llena todos los elementos HTML con los datos
         * del paquete que vino del servidor.
         */
        function llenarDatos(p) {
            document.title = p.nombre + ' - Puerto Magico';

            // Miga de pan y titulo
            document.getElementById('breadcrumb-paquete')
                .textContent = p.nombre;
            document.getElementById('paquete-nombre')
                .textContent = p.nombre;
            document.getElementById('paquete-categoria')
                .textContent = p.categoria || '';
            document.getElementById('paquete-descripcion')
                .textContent = p.descripcion || 'Sin descripcion.';

            // Colores segun categoria
            const colores = {
                'PLAYA':    { bg: '#E8F4F9', color: '#2E86AB' },
                'CULTURAL': { bg: '#FFF3E0', color: '#F5A623' },
                'AVENTURA': { bg: '#E8F5E9', color: '#2E7D32' },
                'ECO':      { bg: '#F1F8E9', color: '#558B2F' },
                'CIUDAD':   { bg: '#F3E5F5', color: '#7B1FA2' }
            };
            const estilo = colores[p.categoria] ||
                { bg: '#F5F5F5', color: '#666' };

            // Banner con color de categoria
            document.getElementById('paquete-banner')
                .style.backgroundColor = estilo.bg;

            // Badge de categoria
            document.getElementById('paquete-badge').innerHTML =
                `<span class="badge rounded-pill text-white"
                       style="background-color:${estilo.color}">
                    ${p.categoria || 'GENERAL'}
                 </span>`;

            // Duracion
            const noches = (p.duracionDias || 1) - 1;
            document.getElementById('paquete-duracion').innerHTML =
                `<i class="bi bi-calendar3 me-1"></i>
                 ${p.duracionDias} dias / ${noches} noches`;

            // Datos rapidos en tarjetas
            document.getElementById('paquete-datos').innerHTML = `
                <div class="col-6 col-md-3">
                    <div class="card border-0 bg-white
                                shadow-sm text-center p-3">
                        <i class="bi bi-calendar3 fs-4
                                  text-primary mb-1"></i>
                        <div class="fw-bold">${p.duracionDias} dias</div>
                        <small class="text-muted">Duracion</small>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="card border-0 bg-white
                                shadow-sm text-center p-3">
                        <i class="bi bi-moon fs-4
                                  text-primary mb-1"></i>
                        <div class="fw-bold">${noches} noches</div>
                        <small class="text-muted">Hospedaje</small>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="card border-0 bg-white
                                shadow-sm text-center p-3">
                        <i class="bi bi-people fs-4
                                  text-success mb-1"></i>
                        <div class="fw-bold">${p.cupoMaximo}</div>
                        <small class="text-muted">Cupo max.</small>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="card border-0 bg-white
                                shadow-sm text-center p-3">
                        <i class="bi bi-tag fs-4
                                  text-warning mb-1"></i>
                        <div class="fw-bold">${p.categoria}</div>
                        <small class="text-muted">Categoria</small>
                    </div>
                </div>
            `;

            // Precio en la caja de reserva
            precioBase = Number(p.precioBase);
            document.getElementById('reserva-precio').textContent =
                '$' + precioBase.toLocaleString('es-MX');

            // Disponibilidad
            const dispEl = document.getElementById('disponibilidad');
            if (p.cupoMaximo > 0) {
                dispEl.className =
                    'alert alert-success py-2 small mb-3';
                dispEl.innerHTML =
                    '<i class="bi bi-check-circle me-1"></i>' +
                    p.cupoMaximo + ' lugares disponibles';
            } else {
                dispEl.className =
                    'alert alert-danger py-2 small mb-3';
                dispEl.innerHTML =
                    '<i class="bi bi-x-circle me-1"></i>' +
                    'Sin disponibilidad';
            }

            calcularTotal();
        }

        /**
         * calcularTotal()
         * Recalcula el precio cuando cambia el numero de personas.
         * total = (precio x personas) + 10% de cargo por servicio
         */
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

        /**
         * continuarReserva()
         * Verifica sesion activa antes de proceder al pago.
         * Si no hay sesion, redirige al login.
         */
        async function continuarReserva() {
            const fecha = document.getElementById('fecha-inicio').value;
            if (!fecha) {
                alert('Selecciona una fecha de inicio.');
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

                // Aqui conectaremos con el flujo de reserva de paquetes
                alert('Reserva de paquete en proceso.\n' +
                      'Paquete ID: ' + id + '\n' +
                      'Fecha: ' + fecha);

            } catch (e) {
                alert('Error de conexion.');
            }
        }
    </script>
</body>
</html>