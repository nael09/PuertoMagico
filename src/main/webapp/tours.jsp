<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tours - Puerto Magico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --naranja: #F5A623;
            --naranja-dark: #D48A10;
            --azul: #2E86AB;
        }
        /* Solo las clases que Bootstrap no tiene */
        .navbar  { border-bottom: 3px solid var(--naranja); }
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
        .tour-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            overflow: hidden;
            transition: transform .2s, box-shadow .2s;
            cursor: pointer;
            height: 100%;
        }
        .tour-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }
        .tour-banner {
            height: 110px;
            background-color: #e9f5ff;
        }
        .precio {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--naranja-dark);
        }
    </style>
</head>
<body class="bg-light">

    <!-- NAVBAR — igual en todas las paginas -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                Puerto<span style="color:var(--naranja)">Magico</span>
            </a>
            <button class="navbar-toggler" type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#nav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="nav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active fw-bold" href="tours.jsp">Tours</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="paquetes.jsp">Paquetes</a>
                    </li>
                </ul>
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
        </div>
    </nav>

    <!-- ENCABEZADO DE PAGINA -->
    <div class="bg-white border-bottom py-4">
        <div class="container">
            <h1 class="h3 fw-bold mb-1">Catalogo de Tours</h1>
            <p class="text-muted mb-0">
                Explora todos nuestros tours disponibles
            </p>
        </div>
    </div>

    <div class="container py-4">
        <div class="row g-4">

            <!-- COLUMNA IZQUIERDA: Filtros -->
            <!--
                col-lg-3: ocupa 3/12 columnas en pantallas grandes.
                En movil ocupa el ancho completo (col-12 por defecto).
            -->
            <div class="col-lg-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3">
                            <i class="bi bi-funnel me-1"></i>
                            Filtrar tours
                        </h6>

                        <!-- Filtro por destino -->
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">
                                Destino
                            </label>
                            <select class="form-select form-select-sm"
                                    id="filtro-destino"
                                    onchange="aplicarFiltros()">
                                <option value="">Todos</option>
                            </select>
                        </div>

                        <!-- Filtro por dificultad -->
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">
                                Dificultad
                            </label>
                            <select class="form-select form-select-sm"
                                    id="filtro-dificultad"
                                    onchange="aplicarFiltros()">
                                <option value="">Todas</option>
                                <option value="FACIL">Facil</option>
                                <option value="MODERADA">Moderada</option>
                                <option value="DIFICIL">Dificil</option>
                            </select>
                        </div>

                        <!-- Filtro por duracion -->
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">
                                Duracion maxima (horas)
                            </label>
                            <input type="range" class="form-range"
                                   id="filtro-horas"
                                   min="1" max="24" value="24"
                                   oninput="actualizarHoras(this.value)">
                            <div class="text-muted small text-center">
                                Hasta <span id="horas-valor">24</span> horas
                            </div>
                        </div>

                        <button class="btn btn-outline-secondary btn-sm w-100"
                                onclick="limpiarFiltros()">
                            Limpiar filtros
                        </button>
                    </div>
                </div>
            </div>

            <!-- COLUMNA DERECHA: Resultados -->
            <div class="col-lg-9">

                <!-- Barra de resultados y orden -->
                <div class="d-flex justify-content-between
                            align-items-center mb-3">
                    <span class="text-muted small"
                          id="contador-resultados">
                        Cargando...
                    </span>
                    <select class="form-select form-select-sm w-auto"
                            id="orden"
                            onchange="ordenarTours()">
                        <option value="nombre">Nombre A-Z</option>
                        <option value="precio-asc">Menor precio</option>
                        <option value="precio-desc">Mayor precio</option>
                        <option value="duracion">Menor duracion</option>
                    </select>
                </div>

                <!-- Grid de tarjetas -->
                <div class="row g-3" id="tours-grid">
                    <div class="col-12 text-center py-5 text-muted">
                        <div class="spinner-border spinner-border-sm me-2"></div>
                        Cargando tours...
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- FOOTER simple -->
    <footer class="bg-dark text-white text-center py-3 mt-4">
        <small>
            &copy; 2026 Puerto<span style="color:var(--naranja)">Magico</span>
            &middot; Universidad Veracruzana
        </small>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const BASE = '/PuertoMagico';
        let todosLosTours = [];

        window.onload = function () {
            verificarSesion();
            cargarDestinos();
            cargarTours();
        };

        async function verificarSesion() {
            try {
                const res  = await fetch(BASE + '/api/usuarios/sesion');
                const data = await res.json();
                if (!data.error) {
                    document.getElementById('nav-sesion').classList.add('d-none');
                    document.getElementById('nav-usuario').classList.remove('d-none');
                    document.getElementById('nav-nombre').textContent = data.nombre;
                }
            } catch (e) {}
        }

        async function cerrarSesion() {
            await fetch(BASE + '/api/usuarios/logout');
            window.location.reload();
        }

        async function cargarDestinos() {
            try {
                const res      = await fetch(BASE + '/api/destinos');
                const destinos = await res.json();
                const select   = document.getElementById('filtro-destino');
                destinos.forEach(d => {
                    const opt = document.createElement('option');
                    opt.value = d.id;
                    opt.textContent = d.nombre;
                    select.appendChild(opt);
                });
                // Si viene ?destino=ID en la URL, preselecciona
                const params = new URLSearchParams(window.location.search);
                if (params.get('destino')) {
                    select.value = params.get('destino');
                }
            } catch (e) {}
        }

        async function cargarTours() {
            try {
                const res     = await fetch(BASE + '/api/tours');
                todosLosTours = await res.json();
                aplicarFiltros();
            } catch (e) {
                document.getElementById('tours-grid').innerHTML =
                    '<div class="col-12 text-center text-danger">' +
                    'Error al cargar tours.</div>';
            }
        }

        /**
         * aplicarFiltros()
         * Lee todos los filtros activos y muestra
         * solo los tours que cumplen todas las condiciones.
         */
        function aplicarFiltros() {
            const destino    = document.getElementById('filtro-destino').value;
            const dificultad = document.getElementById('filtro-dificultad').value;
            const maxHoras   = parseInt(document.getElementById('filtro-horas').value);

            let resultado = todosLosTours.filter(t => {
                const cumpleDestino = !destino ||
                    String(t.destinoId) === destino;
                const cumpleDif = !dificultad ||
                    t.dificultad === dificultad;
                const cumpleHoras = t.duracionHoras <= maxHoras;
                return cumpleDestino && cumpleDif && cumpleHoras;
            });

            ordenarYMostrar(resultado);
        }

        function actualizarHoras(valor) {
            document.getElementById('horas-valor').textContent = valor;
            aplicarFiltros();
        }

        function limpiarFiltros() {
            document.getElementById('filtro-destino').value    = '';
            document.getElementById('filtro-dificultad').value = '';
            document.getElementById('filtro-horas').value      = 24;
            document.getElementById('horas-valor').textContent = 24;
            aplicarFiltros();
        }

        function ordenarTours() {
            aplicarFiltros();
        }

        function ordenarYMostrar(tours) {
            const orden = document.getElementById('orden').value;
            tours.sort((a, b) => {
                if (orden === 'nombre')
                    return a.nombre.localeCompare(b.nombre);
                if (orden === 'precio-asc')
                    return a.precioBase - b.precioBase;
                if (orden === 'precio-desc')
                    return b.precioBase - a.precioBase;
                if (orden === 'duracion')
                    return a.duracionHoras - b.duracionHoras;
                return 0;
            });
            mostrarTours(tours);
        }

        function mostrarTours(tours) {
            const grid = document.getElementById('tours-grid');
            document.getElementById('contador-resultados').textContent =
                tours.length + ' tour(s) encontrado(s)';

            if (tours.length === 0) {
                grid.innerHTML =
                    '<div class="col-12 text-center py-5 text-muted">' +
                    '<i class="bi bi-search fs-2 d-block mb-2"></i>' +
                    'No se encontraron tours con esos filtros.</div>';
                return;
            }

            grid.innerHTML = '';
            tours.forEach(tour => {
                const col = document.createElement('div');
                col.className = 'col-md-6 col-lg-4';

                // Color del badge segun dificultad
                const badgeClass = tour.dificultad === 'FACIL'
                    ? 'bg-success'
                    : tour.dificultad === 'MODERADA'
                    ? 'bg-warning text-dark'
                    : 'bg-danger';

                col.innerHTML = `
                    <div class="tour-card bg-white"
                         onclick="window.location.href=
                         'detalle-tour.jsp?id=${tour.id}'">
                        <div class="tour-banner bg-light
                                    d-flex align-items-center
                                    justify-content-center">
                            <i class="bi bi-map text-secondary"
                               style="font-size:2rem"></i>
                        </div>
                        <div class="p-3">
                            <span class="badge ${badgeClass} mb-2">
                                ${tour.dificultad || 'FACIL'}
                            </span>
                            <h6 class="fw-bold mb-1">${tour.nombre}</h6>
                            <p class="text-muted small mb-2">
                                <i class="bi bi-geo-alt"></i>
                                ${tour.nombreDestino || 'Mexico'}
                            </p>
                            <div class="d-flex gap-3 text-muted
                                        small mb-3">
                                <span>
                                    <i class="bi bi-clock"></i>
                                    ${tour.duracionHoras} hrs
                                </span>
                                <span>
                                    <i class="bi bi-people"></i>
                                    Max. ${tour.cupoMaximo}
                                </span>
                            </div>
                            <div class="d-flex justify-content-between
                                        align-items-center pt-2 border-top">
                                <div class="precio">
                                    $${Number(tour.precioBase)
                                        .toLocaleString('es-MX')}
                                    <span class="text-muted fw-normal"
                                          style="font-size:.75rem">
                                        /persona
                                    </span>
                                </div>
                                <button class="btn btn-naranja btn-sm"
                                    onclick="event.stopPropagation();
                                    window.location.href=
                                    'detalle-tour.jsp?id=${tour.id}'">
                                    Ver
                                </button>
                            </div>
                        </div>
                    </div>
                `;
                grid.appendChild(col);
            });
        }
    </script>
</body>
</html>