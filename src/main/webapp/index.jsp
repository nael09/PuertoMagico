<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Puerto Magico - Agencia de Viajes</title>

    <!-- Bootstrap 5 CSS via CDN  no requiere instalacion -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"
          rel="stylesheet">

    <style>
        /* ── VARIABLES DE COLOR (logo Living Travel) ── */
        :root {
            --naranja:#F5A623;
            --naranja-dark:#D48A10;
            --azul:#2E86AB;
            --azul-dark:#1E6A8A;
            --gris:#2D2D2D;
            --fondo:#F8F9FA;
        }

        /* Sobrescribimos el color primario de Bootstrap */
        .btn-primary {
            background-color:var(--naranja);
            border-color:var(--naranja);
            color:#fff;
            font-weight:600;
        }
        .btn-primary:hover {
            background-color:var(--naranja-dark);
            border-color:var(--naranja-dark);
        }

        .btn-outline-primary {
            color:var(--naranja);
            border-color: var(--naranja);
        }
        .btn-outline-primary:hover {
            background-color: var(--naranja);
            border-color:var(--naranja);
        }

        .text-primary { color: var(--naranja) !important; }

        /* ── NAVBAR ──────────────────────────────────── */
        .navbar {
            border-bottom: 3px solid var(--naranja);
            background-color: #fff !important;
        }

        .navbar-brand {
            font-weight: 700;
            font-size:1.3rem;
            color:var(--gris) !important;
        }

        .navbar-brand span { color: var(--naranja); }

        .nav-link {
            color: var(--gris) !important;
            font-weight: 500;
        }
        .nav-link:hover { color: var(--naranja) !important; }

        /* ── HERO ────────────────────────────────────── */
        .hero {
            background:  var(--naranja);
            padding:     70px 0;
            color:       #fff;
        }

        .hero h1 { font-size: 2.5rem; font-weight: 700; }

        .hero p { font-size: 1.1rem; opacity: 0.9; }

        /* Barra de busqueda dentro del hero */
        .search-card {
            border-radius: 12px;
            box-shadow:    0 8px 32px rgba(0,0,0,0.15);
        }

        /* ── SECCION DESTINOS ────────────────────────── */
        .destino-card {
            border: none;
            border-radius: 10px;
            overflow:hidden;
            cursor: pointer;
            transition: transform .2s, box-shadow .2s;
        }
        .destino-card:hover {
            transform:translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        }

        /* Bloque de color superior de la tarjeta de destino */
        .destino-color {
            height:90px;
            display:flex;
            align-items:center;
            justify-content: center;
            font-size:2rem;
            color:#fff;
        }

        /* ── SECCION TOURS ───────────────────────────── */
        .tour-card {
            border:1px solid #e9ecef;
            border-radius: 10px;
            overflow:hidden;
            cursor:pointer;
            transition:transform .2s, box-shadow .2s;
            height:100%;
        }
        .tour-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }

        /* Bloque de color superior de la tarjeta de tour */
        .tour-color {
            height: 120px;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size: 2.5rem;
        }

        /* Badge de dificultad */
        .badge-facil { background-color: #198754; }
        .badge-moderada { background-color: var(--naranja); }
        .badge-dificil  { background-color: #dc3545; }

        /* Precio del tour */
        .precio {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--naranja-dark);
        }

        /* ── FILTROS ─────────────────────────────────── */
        .btn-filtro {
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            padding: 5px 16px;
            border:1.5px solid #dee2e6;
            background: #fff;
            color: #6c757d;
            cursor: pointer;
        }
        .btn-filtro.activo,
        .btn-filtro:hover {
            background: var(--naranja);
            border-color: var(--naranja);
            color:#fff;
        }

        /* ── BANNER INFERIOR ─────────────────────────── */
        .banner-azul {
            background-color: var(--azul);
            color: #fff;
            padding:60px 0;
        }

        /* ── FOOTER ──────────────────────────────────── */
        footer {
            background-color: var(--gris);
            color: rgba(255,255,255,0.7);
            padding: 20px 0;
            font-size:0.875rem;
        }
        footer span { color: var(--naranja); }
    </style>
</head>
<body class="bg-light">

    <!-- ── NAVBAR ──────────────────────────────────────── -->
    <!--
        Bootstrap Navbar con colapso para movil.
        navbar-expand-lg: se colapsa en pantallas menores a lg.
        sticky-top: se queda fijo al hacer scroll.
    -->
    <nav class="navbar navbar-expand-lg sticky-top shadow-sm">
        <div class="container">

            <!-- Logo -->
            <a class="navbar-brand" href="index.jsp">
                <img src="logo.png" alt="Logo" height="36"
                     class="rounded-circle me-2"
                     onerror="this.style.display='none'">
                Puerto<span>Magico</span>
            </a>

            <!-- Boton hamburguesa para movil -->
            <button class="navbar-toggler" type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#navbarMenu">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Links de navegacion -->
            <div class="collapse navbar-collapse" id="navbarMenu">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" href="index.jsp">
                            Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="tours.jsp">Tours</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="paquetes.jsp">
                            Paquetes
                        </a>
                    </li>
                </ul>

                <!-- Botones de sesion (derecha) -->
                <div class="d-flex gap-2" id="nav-sesion">
                    <a href="login.jsp"
                       class="btn btn-outline-secondary btn-sm">
                        Iniciar sesion
                    </a>
                    <a href="registro.jsp"
                       class="btn btn-primary btn-sm">
                        Registrarse
                    </a>
                </div>

                <!-- Se muestra cuando el usuario esta logueado -->
                <div class="d-none" id="nav-usuario">
                    <span class="me-2 text-muted small"
                          id="nav-nombre"></span>
                    <button class="btn btn-outline-danger btn-sm"
                            onclick="cerrarSesion()">
                        Salir
                    </button>
                </div>
            </div>
        </div>
    </nav>

    <!-- ── HERO ────────────────────────────────────────── -->
    <section class="hero">
        <div class="container text-center">
            <h1 class="mb-3">Descubre lo mejor de Mexico</h1>
            <p class="mb-4">
                Tours por dia y paquetes todo incluido
                a los destinos mas increibles del pais
            </p>

            <!--
                Bootstrap Card como barra de busqueda.
                Row con gutter para espaciado entre columnas.
            -->
            <div class="card search-card p-3 mx-auto"
                 style="max-width: 700px">
                <div class="row g-2 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label fw-bold
                                      text-muted small text-start
                                      d-block">
                            Destino
                        </label>
                        <select class="form-select form-select-sm"
                                id="filtro-destino">
                            <option value="">Todos los destinos</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold
                                      text-muted small text-start
                                      d-block">
                            Tipo
                        </label>
                        <select class="form-select form-select-sm">
                            <option>Tours por dia</option>
                            <option>Paquetes</option>
                            <option>Ambos</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold
                                      text-muted small text-start
                                      d-block">
                            Fecha
                        </label>
                        <input type="date"
                               class="form-control form-control-sm">
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-sm w-100"
                                style="background:var(--azul);
                                       color:#fff;font-weight:600"
                                onclick="window.location.href='tours.jsp'">
                            <i class="bi bi-search"></i> Buscar
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ── DESTINOS ─────────────────────────────────────── -->
    <section class="py-5">
        <div class="container">

            <!-- Encabezado de seccion -->
            <div class="d-flex justify-content-between
                        align-items-center mb-4">
                <h2 class="fw-bold mb-0">Destinos populares</h2>
                <a href="tours.jsp"
                   class="text-decoration-none fw-bold"
                   style="color:var(--azul)">
                    Ver todos <i class="bi bi-arrow-right"></i>
                </a>
            </div>

            <!--
                Bootstrap Grid — 4 columnas en desktop,
                2 en tablet, 1 en movil.
            -->
            <div class="row g-3" id="destinos-grid">

                <!-- Placeholder mientras carga -->
                <div class="col-12 text-center text-muted py-4">
                    <div class="spinner-border spinner-border-sm
                                text-secondary me-2"></div>
                    Cargando destinos...
                </div>
            </div>
        </div>
    </section>

    <!-- ── TOURS DESTACADOS ──────────────────────────────── -->
    <section class="py-5 bg-white">
        <div class="container">

            <div class="d-flex justify-content-between
                        align-items-center mb-3">
                <h2 class="fw-bold mb-0">Tours destacados</h2>
                <a href="tours.jsp"
                   class="text-decoration-none fw-bold"
                   style="color:var(--azul)">
                    Ver todos <i class="bi bi-arrow-right"></i>
                </a>
            </div>

            <!-- Botones de filtro por categoria -->
            <div class="d-flex gap-2 flex-wrap mb-4">
                <button class="btn-filtro activo"
                        onclick="filtrar(this, 'todos')">
                    Todos
                </button>
                <button class="btn-filtro"
                        onclick="filtrar(this, 'cultura')">
                    Cultura
                </button>
                <button class="btn-filtro"
                        onclick="filtrar(this, 'aventura')">
                    Aventura
                </button>
                <button class="btn-filtro"
                        onclick="filtrar(this, 'playa')">
                    Playa
                </button>
            </div>

            <!-- Grid de tours — 3 columnas en desktop -->
            <div class="row g-4" id="tours-grid">
                <div class="col-12 text-center text-muted py-4">
                    <div class="spinner-border spinner-border-sm
                                text-secondary me-2"></div>
                    Cargando tours...
                </div>
            </div>
        </div>
    </section>

    <!-- ── BANNER ────────────────────────────────────────── -->
    <section class="banner-azul text-center">
        <div class="container">
            <h2 class="fw-bold mb-2">
                Listo para tu proxima aventura?
            </h2>
            <p class="mb-4 opacity-75">
                Crea tu cuenta y reserva en minutos
            </p>
            <a href="registro.jsp" class="btn btn-primary btn-lg px-5">
                Comenzar ahora
            </a>
        </div>
    </section>

    
    
    <!-- ── FOOTER ────────────────────────────────────────── -->
<%-- 
    Importamos la libreria JSTL Core con el prefijo "c".
    Esto nos permite usar etiquetas como:
    <c:if>, <c:forEach>, <c:out>, <c:set>
    en lugar de escribir Java directamente en el JSP.
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 
    Guardamos el año actual en una variable JSTL
    para mostrarlo dinamicamente en el footer.
    Asi el año se actualiza solo cada 1 de enero.
--%>
<c:set var="anio" value="<%= java.time.Year.now().getValue() %>" />

<!-- FOOTER con año dinamico usando JSTL -->
<footer class="bg-dark text-white text-center py-3 mt-4">
    <small>
        &copy; <c:out value="${anio}"/> 
        Puerto<span style="color:var(--naranja)">Magico</span>
        &middot; Universidad Veracruzana
        &middot; Diseno de Aplicaciones Web
    </small>
</footer>





    <!-- Bootstrap 5 JS (necesario para el navbar hamburguesa) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // ── CONSTANTE BASE URL ─────────────────────────────
       
        const BASE = '/PuertoMagico';

        // Guardamos los tours para filtrar sin otra peticion
        let todosLosTours = [];

        // ── INICIO ─────────────────────────────────────────
        window.onload = function () {
            verificarSesion();
            cargarDestinos();
            cargarTours();
        };

        /*
          Consulta al servidor si hay sesion activa.
         Si la hay, muestra el nombre del usuario en el navbar.
          Si no, muestra los botones de login y registro.
         */
        async function verificarSesion() {
            try {
                const res  = await fetch(BASE + '/api/usuarios/sesion');
                const data = await res.json();

                if (!data.error) {
                    // Hay sesion activa — mostrar nombre de usuario
                    document.getElementById('nav-sesion')
                        .classList.add('d-none');
                    document.getElementById('nav-usuario')
                        .classList.remove('d-none');
                    document.getElementById('nav-nombre')
                        .textContent = data.nombre;
                }
            } catch (e) {
                // Sin sesion — dejamos los botones por defecto
            }
        }

        /* cerrarSesion()
          Llama al endpoint de logout y recarga la pagina.
         */
        async function cerrarSesion() {
            await fetch(BASE + '/api/usuarios/logout');
            window.location.reload();
        }

        /**
         * cargarDestinos()
         * Trae los destinos del servidor y los muestra
         * en tarjetas con su conteo de tours.
         */
        async function cargarDestinos() {
            const grid = document.getElementById('destinos-grid');
            try {
                const res = await fetch(BASE + '/api/destinos');
                const destinos = await res.json();

                // Colores para las tarjetas de destino
                const colores = [
                    '#2E86AB','#27B89C','#F5A623',
                    '#E05C2A','#9B59B6','#E74C3C'
                ];

                grid.innerHTML = '';

                // Llenar el select de busqueda con los destinos
                const select = document.getElementById('filtro-destino');
                destinos.forEach((d, i) => {
                    const opt  = document.createElement('option');
                    opt.value  = d.id;
                    opt.textContent = d.nombre;
                    select.appendChild(opt);
                });

                // Crear tarjeta por cada destino
                destinos.forEach((d, i) => {
                    const color = colores[i % colores.length];
                    const col   = document.createElement('div');
                    col.className = 'col-6 col-md-3';
                    col.innerHTML = `
                        <div class="destino-card card h-100"
                             onclick="window.location.href=
                             'tours.jsp?destino=${d.id}'">
                            <div class="destino-color"
                                 style="background:${color}">
                            </div>
                            <div class="card-body p-3">
                                <div class="fw-bold">${d.nombre}</div>
                                <small class="text-muted">
                                    ${d.numTours} tours disponibles
                                </small>
                            </div>
                        </div>
                    `;
                    grid.appendChild(col);
                });

            } catch (e) {
                grid.innerHTML = `
                    <div class="col-12 text-center text-danger">
                        No se pudieron cargar los destinos.
                    </div>`;
            }
        }

        /**
         * cargarTours()
         * Trae los tours del servidor y los muestra en tarjetas.
         */
        async function cargarTours() {
            const grid = document.getElementById('tours-grid');
            try {
                const res    = await fetch(BASE + '/api/tours');
                todosLosTours = await res.json();
                mostrarTours(todosLosTours);
            } catch (e) {
                grid.innerHTML = `
                    <div class="col-12 text-center text-danger">
                        No se pudieron cargar los tours.
                    </div>`;
            }
        }

        /**
         * mostrarTours()
         * Dibuja las tarjetas de tours en el grid.
         * Recibe la lista completa o ya filtrada.
         */
        function mostrarTours(tours) {
            const grid = document.getElementById('tours-grid');
            grid.innerHTML = '';

            if (tours.length === 0) {
                grid.innerHTML = `
                    <div class="col-12 text-center text-muted py-4">
                        No hay tours disponibles.
                    </div>`;
                return;
            }

            // Mostramos solo los primeros 6 en la pagina principal
            tours.slice(0, 6).forEach(tour => {
                const dif    = (tour.dificultad || 'FACIL').toLowerCase();
                const badge  = dif === 'facil'
                    ? 'badge-facil'
                    : dif === 'moderada'
                    ? 'badge-moderada'
                    : 'badge-dificil';
                const color  = dif === 'facil'
                    ? '#E8F4F1'
                    : dif === 'moderada'
                    ? '#FFF3D6'
                    : '#FDECEA';

                const col    = document.createElement('div');
                col.className    = 'col-md-4';
                col.dataset.cat  = obtenerCategoria(
                    tour.nombreDestino || '');

                col.innerHTML = `
                    <div class="tour-card"
                         onclick="window.location.href=
                         'detalle-tour.jsp?id=${tour.id}'">
                        <div class="tour-color"
                             style="background:${color}">
                        </div>
                        <div class="card-body">
                            <span class="badge ${badge} text-white
                                          mb-2 small">
                                ${tour.dificultad || 'FACIL'}
                            </span>
                            <h6 class="fw-bold">${tour.nombre}</h6>
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
                                        align-items-center
                                        border-top pt-3">
                                <div class="precio">
                                    $${Number(tour.precioBase)
                                        .toLocaleString('es-MX')}
                                    <span class="text-muted fw-normal"
                                          style="font-size:.8rem">
                                        /persona
                                    </span>
                                </div>
                                <button class="btn btn-primary btn-sm"
                                    onclick="event.stopPropagation();
                                    window.location.href=
                                    'detalle-tour.jsp?id=${tour.id}'">
                                    Ver tour
                                </button>
                            </div>
                        </div>
                    </div>
                `;
                grid.appendChild(col);
            });
        }

        /**
         * filtrar()
         * Filtra los tours por categoria sin otra peticion.
         */
        function filtrar(btn, cat) {
            document.querySelectorAll('.btn-filtro')
                .forEach(b => b.classList.remove('activo'));
            btn.classList.add('activo');

            const filtrados = cat === 'todos'
                ? todosLosTours
                : todosLosTours.filter(t =>
                    obtenerCategoria(t.nombreDestino || '') === cat);

            mostrarTours(filtrados);
        }

        /**
         * obtenerCategoria()
         * Asigna una categoria al tour segun el destino.
         */
        function obtenerCategoria(destino) {
            destino = destino.toLowerCase();
            if (destino.includes('cancun') ||
                destino.includes('playa') ||
                destino.includes('cabos')) return 'playa';
            if (destino.includes('sierra') ||
                destino.includes('eco'))   return 'aventura';
            return 'cultura';
        }
    </script>
</body>
</html>