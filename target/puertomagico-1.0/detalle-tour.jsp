<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
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
        .tour-banner {
            background-color: #e8f4f9;
            height: 200px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .reserva-box {
            position: sticky;
            top: 80px;
        }
        .precio-grande {
            font-size: 2rem;
            font-weight: 700;
            color: var(--naranja-dark);
        }

        /* ── ASIENTOS ─────────────────────────────── */
        .asiento {
            width: 36px;
            height: 36px;
            border-radius: 6px;
            border: 2px solid #dee2e6;
            background: #fff;
            cursor: pointer;
            font-size: 10px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all .15s;
        }
        .asiento:hover { transform: scale(1.1); }
        .asiento.disponible {
            background: #d1f5d3;
            border-color: #198754;
            color: #198754;
        }
        .asiento.seleccionado {
            background: var(--naranja);
            border-color: var(--naranja-dark);
            color: #fff;
        }
        .asiento.ocupado {
            background: #f8d7da;
            border-color: #dc3545;
            color: #dc3545;
            cursor: not-allowed;
        }
        .asiento.en-proceso {
            background: #fff3cd;
            border-color: #ffc107;
            color: #856404;
            cursor: not-allowed;
        }
        .asiento.premium { border-style: dashed; }
        .leyenda-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
        }
        .leyenda-color {
            width: 16px;
            height: 16px;
            border-radius: 4px;
            border: 2px solid;
        }

        /* ── LAYOUT AUTOBUS ───────────────────────── */
        .bus-container {
            background: #f8f9fa;
            border: 3px solid #adb5bd;
            border-radius: 16px 16px 10px 10px;
            padding: 10px;
            max-width: 220px;
            margin: 0 auto;
        }
        .bus-cabina {
            background: #dee2e6;
            border-radius: 10px 10px 0 0;
            padding: 6px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
            font-size: 11px;
            color: #495057;
            font-weight: 600;
        }
        .bus-volante {
            width: 24px;
            height: 24px;
            border: 3px solid #495057;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .bus-fila {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 4px;
            margin-bottom: 4px;
        }
        .bus-pasillo {
            width: 20px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 9px;
            color: #adb5bd;
        }
        .bus-num-fila {
            width: 16px;
            font-size: 9px;
            color: #adb5bd;
            text-align: center;
        }
        .bus-puerta {
            border-top: 2px dashed #adb5bd;
            margin-top: 6px;
            padding-top: 4px;
            text-align: center;
            font-size: 10px;
            color: #adb5bd;
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
                <a href="login.jsp" class="btn btn-outline-secondary btn-sm">
                    Iniciar sesion
                </a>
                <a href="registro.jsp" class="btn btn-naranja btn-sm">
                    Registrarse
                </a>
            </div>
            <div class="d-none" id="nav-usuario">
                <span class="text-muted small me-2" id="nav-nombre"></span>
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
                        <a href="index.jsp" class="text-decoration-none">
                            Inicio
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="tours.jsp" class="text-decoration-none">
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

            <!-- COLUMNA IZQUIERDA -->
            <div class="col-lg-8">

                <div class="tour-banner mb-4">
                    <i class="bi bi-map"
                       style="font-size:4rem;color:#2E86AB"></i>
                </div>

                <div class="mb-4">
                    <div class="d-flex gap-2 mb-2" id="tour-tags"></div>
                    <h2 class="fw-bold" id="tour-nombre">Cargando...</h2>
                    <p class="text-muted" id="tour-destino"></p>
                </div>

                <div class="row g-3 mb-4" id="tour-datos"></div>

                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="fw-bold mb-3">Descripcion</h5>
                        <p class="text-muted mb-0" id="tour-descripcion">
                            Cargando...
                        </p>
                    </div>
                </div>

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
                                Seguro de viajero
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

                            <div class="precio-grande mb-1"
                                 id="reserva-precio">$---</div>
                            <p class="text-muted small mb-3">por persona</p>

                            <!-- Disponibilidad -->
                            <div class="alert alert-success py-2 small mb-3"
                                 id="disponibilidad">
                                <i class="bi bi-check-circle me-1"></i>
                                Cargando...
                            </div>

                            <!-- Fecha preestablecida -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold small">
                                    Fecha del tour
                                </label>
                                
                                
                                <div class="alert alert-warning py-2 mb-o"
                                     id="fecha-display">
                                    <i class ="bi bi-calendar-event me-1"></i>
                                    <strong id="fecha-texto">cargando fecha..</strong>
                                </div>
                                
                                <input type="hidden" id="fecha-tour"> 
                             
                            </div>

                            <!-- Puntos de salida -->
                            <div class="alert alert-light border small mb-3"
                                 id="salida-box" style="display:none">
                                <i class="bi bi-geo-alt-fill
                                          text-danger me-1"></i>
                                <strong>Salidas desde:</strong>
                                <span id="puntos-salida"></span>
                            </div>

                            <!-- Numero de personas -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold small">
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

                            <!-- MAPA DE ASIENTOS -->
                            <div class="mb-3" id="seccion-asientos"
                                 style="display:none">
                                <label class="form-label fw-semibold small">
                                    Selecciona tus asientos
                                </label>

                                <!-- Leyenda -->
                                <div class="d-flex gap-3 flex-wrap mb-2">
                                    <div class="leyenda-item">
                                        <div class="leyenda-color"
                                             style="background:#d1f5d3;
                                             border-color:#198754"></div>
                                        Disponible
                                    </div>
                                    <div class="leyenda-item">
                                        <div class="leyenda-color"
                                             style="background:var(--naranja);
                                             border-color:var(--naranja-dark)">
                                        </div>
                                        Seleccionado
                                    </div>
                                    <div class="leyenda-item">
                                        <div class="leyenda-color"
                                             style="background:#f8d7da;
                                             border-color:#dc3545"></div>
                                        Ocupado
                                    </div>
                                </div>

                                <!-- Mapa -->
                                <div id="mapa-asientos"></div>

                                <!-- Info seleccion -->
                                <div class="mt-2 small text-muted"
                                     id="info-asientos">
                                    Ningun asiento seleccionado
                                </div>
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

                            <p class="text-muted text-center small mt-2 mb-0">
                                <i class="bi bi-shield-check me-1"></i>
                                Aceptamos 3, 6, 9 y 12 meses sin intereses
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
        const id   = new URLSearchParams(
            window.location.search).get('id');

        var precioBase            = 0;
        var asientosSeleccionados = [];
        var todosLosAsientos      = [];

        window.onload = function() {
            verificarSesion();
            if (id) cargarTour(id);
        };

        // ── SESION ─────────────────────────────────────

        function verificarSesion() {
            fetch(BASE + '/api/usuarios/sesion')
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (!data.error) {
                        document.getElementById('nav-sesion')
                            .classList.add('d-none');
                        document.getElementById('nav-usuario')
                            .classList.remove('d-none');
                        document.getElementById('nav-nombre')
                            .textContent = data.nombre;
                    }
                })
                .catch(function() {});
        }

        function cerrarSesion() {
            fetch(BASE + '/api/usuarios/logout')
                .then(function() { window.location.reload(); });
        }

        // ── TOUR ───────────────────────────────────────

        function cargarTour(tourId) {
            fetch(BASE + '/api/tours?id=' + tourId)
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.error) {
                        alert('Tour no encontrado');
                        window.location.href = 'tours.jsp';
                        return;
                    }
                    llenarDatos(data.tour, data.lugaresDisponibles);
                })
                .catch(function() {
                    alert('Error al cargar el tour');
                });
        }

        function llenarDatos(tour, disponibles) {
            document.title = tour.nombre + ' - Puerto Magico';

            document.getElementById('breadcrumb-tour')
                .textContent = tour.nombre;
            document.getElementById('tour-nombre')
                .textContent = tour.nombre;
            document.getElementById('tour-destino')
                .innerHTML = '<i class="bi bi-geo-alt"></i> ' +
                (tour.nombreDestino || 'Mexico');
            document.getElementById('tour-descripcion')
                .textContent = tour.descripcion || 'Sin descripcion.';

            // Badge dificultad
            var bc = tour.dificultad === 'FACIL' ? 'bg-success'
                : tour.dificultad === 'MODERADA'
                ? 'bg-warning text-dark' : 'bg-danger';
            document.getElementById('tour-tags').innerHTML =
                '<span class="badge ' + bc + '">' +
                (tour.dificultad || 'FACIL') + '</span>';

            // Datos rapidos
            document.getElementById('tour-datos').innerHTML =
                '<div class="col-6 col-md-3">' +
                '<div class="card border-0 bg-white shadow-sm' +
                ' text-center p-3">' +
                '<i class="bi bi-clock fs-4 text-primary mb-1"></i>' +
                '<div class="fw-bold">' +
                tour.duracionHoras + ' hrs</div>' +
                '<small class="text-muted">Duracion</small>' +
                '</div></div>' +
                '<div class="col-6 col-md-3">' +
                '<div class="card border-0 bg-white shadow-sm' +
                ' text-center p-3">' +
                '<i class="bi bi-people fs-4 text-primary mb-1"></i>' +
                '<div class="fw-bold">' +
                tour.cupoMaximo + '</div>' +
                '<small class="text-muted">Cupo max.</small>' +
                '</div></div>' +
                '<div class="col-6 col-md-3">' +
                '<div class="card border-0 bg-white shadow-sm' +
                ' text-center p-3">' +
                '<i class="bi bi-check-circle fs-4' +
                ' text-success mb-1"></i>' +
                '<div class="fw-bold">' +
                (disponibles || 0) + '</div>' +
                '<small class="text-muted">Disponibles</small>' +
                '</div></div>' +
                '<div class="col-6 col-md-3">' +
                '<div class="card border-0 bg-white shadow-sm' +
                ' text-center p-3">' +
                '<i class="bi bi-bar-chart fs-4' +
                ' text-warning mb-1"></i>' +
                '<div class="fw-bold">' +
                (tour.dificultad || '-') + '</div>' +
                '<small class="text-muted">Dificultad</small>' +
                '</div></div>';

            // Precio
            precioBase = Number(tour.precioBase);
            document.getElementById('reserva-precio').textContent =
                '$' + precioBase.toLocaleString('es-MX');

            // Disponibilidad
            var dispEl = document.getElementById('disponibilidad');
            if (disponibles > 0) {
                dispEl.className =
                    'alert alert-success py-2 small mb-3';
                dispEl.innerHTML =
                    '<i class="bi bi-check-circle me-1"></i>' +
                    disponibles + ' lugares disponibles';
            } else {
                dispEl.className =
                    'alert alert-danger py-2 small mb-3';
                dispEl.innerHTML =
                    '<i class="bi bi-x-circle me-1"></i>' +
                    'Sin disponibilidad';
            }

            // Fecha preestablecida por la agencia
            if (tour.fechaSalida) {
                document.getElementById('fecha-tour').value =
                    tour.fechaSalida;
                
                
                var partes = tour.fechaSalida.split('-');
                var fechaBonita = partes[2] + '/' +
                                  partes[1] + '/' +  partes[0];
                             
                          document.getElementById('fecha-texto')
                                  .textContent = fechaBonita;
                          cargarMapa();
            }else{
                document.getElementById('fecha-texto')
                        .textContent = 'Fecha por Confirmar';
            }

            // Puntos de salida
            if (tour.puntosSalida) {
                document.getElementById('salida-box')
                    .style.display = 'block';
                document.getElementById('puntos-salida')
                    .textContent = tour.puntosSalida;
            }

            calcularTotal();
        }

        // ── MAPA DE ASIENTOS ───────────────────────────

        function cargarMapa() {
            var seccion =
                document.getElementById('seccion-asientos');
            var mapa = document.getElementById('mapa-asientos');

            if (!id) return;

            seccion.style.display = 'block';
            mapa.innerHTML =
                '<div class="text-muted small py-2">' +
                'Cargando asientos...</div>';

            fetch(BASE + '/api/asientos?tourId=' + id)
                .then(function(r) { return r.json(); })
                .then(function(asientos) {
                    todosLosAsientos = asientos;

                    if (!Array.isArray(asientos) ||
                        asientos.length === 0) {
                        mapa.innerHTML =
                            '<div class="text-muted small py-2">' +
                            'Sin asientos disponibles.</div>';
                        return;
                    }

                    asientosSeleccionados = [];
                    actualizarInfoAsientos();
                    dibujarMapa(asientos);
                })
                .catch(function() {
                    mapa.innerHTML =
                        '<div class="text-danger small py-2">' +
                        'Error al cargar asientos.</div>';
                });
        }

        /**
         * dibujarMapa()
         *
         * Dibuja los asientos en forma de autobus.
         * Agrupa por fila (A, B, C...) y distribuye
         * 2 asientos a la izquierda y 2 a la derecha
         * con un pasillo central.
         */
        function dibujarMapa(asientos) {
            var mapa = document.getElementById('mapa-asientos');
            mapa.innerHTML = '';

            // Contenedor con forma de autobus
            var bus = document.createElement('div');
            bus.className = 'bus-container';

            // Cabina del conductor
            var cabina = document.createElement('div');
            cabina.className = 'bus-cabina';
            cabina.innerHTML =
                '<div class="bus-volante">' +
                '<i class="bi bi-circle"' +
                ' style="font-size:8px"></i>' +
                '</div>' +
                '<span>Conductor</span>' +
                '<i class="bi bi-door-open"' +
                ' style="font-size:14px"></i>';
            bus.appendChild(cabina);

            // Agrupar asientos por fila (letra inicial)
            var filas = {};
            asientos.forEach(function(a) {
                var letra = a.numero.charAt(0);
                if (!filas[letra]) filas[letra] = [];
                filas[letra].push(a);
            });

            // Ordenar filas A, B, C, D...
            var letras = Object.keys(filas).sort();

            letras.forEach(function(letra) {
                var asientosFila = filas[letra];

                // Ordenar por numero dentro de la fila
                asientosFila.sort(function(a, b) {
                    return parseInt(a.numero.slice(1)) -
                           parseInt(b.numero.slice(1));
                });

                var fila = document.createElement('div');
                fila.className = 'bus-fila';

                // Etiqueta de la fila
                var numFila = document.createElement('div');
                numFila.className   = 'bus-num-fila';
                numFila.textContent = letra;
                fila.appendChild(numFila);

                // Lado izquierdo: posiciones 1 y 2
                var izq = asientosFila.filter(function(a) {
                    return parseInt(a.numero.slice(1)) <= 2;
                });

                // Lado derecho: posiciones 3 y 4
                var der = asientosFila.filter(function(a) {
                    return parseInt(a.numero.slice(1)) > 2;
                });

                izq.forEach(function(a) {
                    fila.appendChild(crearDivAsiento(a));
                });

                // Pasillo central
                var pasillo = document.createElement('div');
                pasillo.className   = 'bus-pasillo';
                pasillo.textContent = '|';
                fila.appendChild(pasillo);

                der.forEach(function(a) {
                    fila.appendChild(crearDivAsiento(a));
                });

                bus.appendChild(fila);
            });

            // Puerta trasera
            var puerta = document.createElement('div');
            puerta.className = 'bus-puerta';
            puerta.innerHTML =
                '<i class="bi bi-door-open me-1"></i>Salida';
            bus.appendChild(puerta);

            mapa.appendChild(bus);
        }

        /**
         * crearDivAsiento()
         *
         * Crea el elemento HTML de un asiento con su
         * color segun estado y su evento de click.
         */
        function crearDivAsiento(a) {
            var div   = document.createElement('div');
            var clase = 'asiento ';

            if (a.estado === 'DISPONIBLE') {
                clase += 'disponible';
                if (a.tipo === 'PREMIUM') clase += ' premium';
            } else if (a.estado === 'EN_PROCESO') {
                clase += 'en-proceso';
            } else {
                clase += 'ocupado';
            }

            div.className   = clase;
            div.textContent = a.numero;
            div.title       = a.tipo +
                (a.precioExtra > 0
                    ? ' — +$' + Number(a.precioExtra)
                        .toLocaleString('es-MX')
                    : ' — Sin costo extra');

            if (a.estado === 'DISPONIBLE') {
                div.onclick = (function(asiento, elemento) {
                    return function() {
                        seleccionarAsiento(asiento, elemento);
                    };
                })(a, div);
            }

            return div;
        }

        /**
         * seleccionarAsiento()
         *
         * Agrega o quita un asiento de la seleccion.
         * No permite seleccionar mas asientos que personas.
         */
        function seleccionarAsiento(asiento, elemento) {
            var personas = parseInt(
                document.getElementById('num-personas').value);
            var idx = asientosSeleccionados.findIndex(
                function(a) { return a.id === asiento.id; });

            if (idx >= 0) {
                asientosSeleccionados.splice(idx, 1);
                elemento.classList.remove('seleccionado');
                elemento.classList.add('disponible');
            } else {
                if (asientosSeleccionados.length >= personas) {
                    alert('Solo puedes seleccionar ' + personas +
                        ' asiento' + (personas > 1 ? 's' : '') +
                        '.');
                    return;
                }
                asientosSeleccionados.push(asiento);
                elemento.classList.remove('disponible');
                elemento.classList.add('seleccionado');
            }

            actualizarInfoAsientos();
        }

        /**
         * actualizarInfoAsientos()
         *
         * Muestra los numeros de asientos seleccionados
         * y recalcula el total incluyendo cargos premium.
         */
        function actualizarInfoAsientos() {
            var info = document.getElementById('info-asientos');

            if (asientosSeleccionados.length === 0) {
                info.textContent = 'Ningun asiento seleccionado';
                calcularTotal();
                return;
            }

            var numeros = asientosSeleccionados
                .map(function(a) { return a.numero; })
                .join(', ');
            var extra = asientosSeleccionados
                .reduce(function(sum, a) {
                    return sum + Number(a.precioExtra || 0);
                }, 0);

            info.innerHTML =
                'Asientos: <strong>' + numeros + '</strong>' +
                (extra > 0
                    ? ' — Cargo premium: $' +
                      extra.toLocaleString('es-MX')
                    : '');

            calcularTotal();
        }

        /**
         * calcularTotal()
         *
         * Calcula subtotal + cargo de servicio (10%)
         * + extras por asientos premium.
         */
        function calcularTotal() {
            var personas = parseInt(
                document.getElementById('num-personas').value);
            var extra = asientosSeleccionados.reduce(
                function(sum, a) {
                    return sum + Number(a.precioExtra || 0);
                }, 0);

            var subtotal = (precioBase * personas) + extra;
            var cargo    = Math.round(subtotal * 0.10);
            var total    = subtotal + cargo;

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

        // ── RESERVA ────────────────────────────────────

        async function continuarReserva() {
            var fecha    =
                document.getElementById('fecha-tour').value;
            var personas = parseInt(
                document.getElementById('num-personas').value);

            if (!fecha) {
                alert('No hay fecha disponible para este tour.');
                return;
            }

            if (todosLosAsientos.length > 0 &&
                asientosSeleccionados.length < personas) {
                alert('Selecciona ' + personas + ' asiento' +
                    (personas > 1 ? 's' : '') +
                    ' para continuar. Tienes ' +
                    asientosSeleccionados.length +
                    ' seleccionado' +
                    (asientosSeleccionados.length !== 1
                        ? 's' : '') + '.');
                return;
            }

            try {
                var sesRes = await fetch(
                    BASE + '/api/usuarios/sesion');
                var sesData = await sesRes.json();

                if (sesData.error) {
                    alert('Debes iniciar sesion para reservar.');
                    window.location.href = 'login.jsp';
                    return;
                }

                // Bloquear asientos seleccionados
                for (var i = 0;
                     i < asientosSeleccionados.length; i++) {
                    var bl = await fetch(
                        BASE + '/api/asientos/bloquear', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            asientoId: asientosSeleccionados[i].id
                        })
                    });
                    var blData = await bl.json();
                    if (blData.error) {
                        alert('El asiento ' +
                            asientosSeleccionados[i].numero +
                            ' ya no esta disponible.' +
                            ' Por favor elige otro.');
                        cargarMapa();
                        return;
                    }
                }

                // Calcular total final
                var extra = asientosSeleccionados.reduce(
                    function(sum, a) {
                        return sum + Number(a.precioExtra || 0);
                    }, 0);
                var subtotal = (precioBase * personas) + extra;
                var cargo    = Math.round(subtotal * 0.10);
                var total    = subtotal + cargo;

                var asientoIds = asientosSeleccionados
                    .map(function(a) { return a.id; });

                // Crear la reserva
                var res = await fetch(
                    BASE + '/api/reservas/crear', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        tourId:       parseInt(id),
                        tipoServicio: 'TOUR',
                        fechaViaje:   fecha,
                        personas:     personas,
                        total:        total,
                        asientoIds:   asientoIds
                    })
                });
                var data = await res.json();

                if (data.error) {
                    alert('Error: ' + data.mensaje);
                    return;
                }

                // Ir al pago
                window.location.href =
                    'pago.jsp?reservaId=' + data.reservaId +
                    '&total=' + total;

            } catch (e) {
                alert('Error de conexion.');
            }
        }
    </script>
</body>
</html>