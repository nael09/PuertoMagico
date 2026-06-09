<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paquetes - Puerto Magico</title>
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
        /* Tarjeta de paquete */
        .paquete-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            overflow: hidden;
            transition: transform .2s, box-shadow .2s;
            cursor: pointer;
            height: 100%;
        }
        .paquete-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }
        /* Banner de color segun categoria */
        .paquete-banner {
            height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .precio {
            font-size: 1.3rem;
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
                        <a class="nav-link" href="tours.jsp">Tours</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active fw-bold"
                           href="paquetes.jsp">Paquetes</a>
                    </li>
                </ul>
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
        </div>
    </nav>

    <!-- ENCABEZADO -->
    <div class="bg-white border-bottom py-4">
        <div class="container">
            <h1 class="h3 fw-bold mb-1">Paquetes Todo Incluido</h1>
            <p class="text-muted mb-0">
                Varios dias de experiencias inolvidables
            </p>
        </div>
    </div>

    <div class="container py-4">

        <!--
            FILTROS POR CATEGORIA
            Bootstrap Pills — botones que funcionan como pestanas.
            data-cat: atributo personalizado para saber que filtrar.
        -->
        <div class="d-flex gap-2 flex-wrap mb-4">
            <button class="btn btn-naranja btn-sm rounded-pill"
                    onclick="filtrar(this, '')">
                Todos
            </button>
            <button class="btn btn-outline-secondary btn-sm rounded-pill"
                    onclick="filtrar(this, 'PLAYA')">
                Playa
            </button>
            <button class="btn btn-outline-secondary btn-sm rounded-pill"
                    onclick="filtrar(this, 'CULTURAL')">
                Cultural
            </button>
            <button class="btn btn-outline-secondary btn-sm rounded-pill"
                    onclick="filtrar(this, 'AVENTURA')">
                Aventura
            </button>
            <button class="btn btn-outline-secondary btn-sm rounded-pill"
                    onclick="filtrar(this, 'ECO')">
                Eco
            </button>
            <button class="btn btn-outline-secondary btn-sm rounded-pill"
                    onclick="filtrar(this, 'CIUDAD')">
                Ciudad
            </button>
        </div>

        <!-- Contador de resultados -->
        <p class="text-muted small mb-3" id="contador">
            Cargando paquetes...
        </p>

        <!--
            GRID DE PAQUETES
            row-cols-md-2: 2 columnas en tablet
            row-cols-lg-3: 3 columnas en desktop
            g-4: gutter (espacio entre columnas)
        -->
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4"
             id="paquetes-grid">
            <div class="col-12 text-center py-5 text-muted">
                <div class="spinner-border spinner-border-sm me-2"></div>
                Cargando...
            </div>
        </div>
    </div>

    <!-- BANNER CTA -->
    <div class="py-5 text-center text-white mt-4"
         style="background-color:var(--azul)">
        <div class="container">
            <h4 class="fw-bold mb-2">
                Arma tu viaje a tu medida
            </h4>
            <p class="mb-3 opacity-75">
                Contactanos y creamos un paquete personalizado
            </p>
            <a href="registro.jsp" class="btn btn-naranja btn-lg px-5">
                Comenzar
            </a>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-3">
        <small>
            &copy; 2026 Puerto<span style="color:var(--naranja)">Magico</span>
            &middot; Universidad Veracruzana
        </small>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const BASE = '/PuertoMagico';

        // Guardamos todos los paquetes para filtrar sin otra peticion
        let todosPaquetes = [];

        window.onload = function () {
            verificarSesion();
            cargarPaquetes();
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
         * cargarPaquetes()
         * Hace una peticion GET al PaqueteServlet
         * y muestra todos los paquetes activos.
         */
        async function cargarPaquetes() {
            try {
                const res     = await fetch(BASE + '/api/paquetes');
                todosPaquetes = await res.json();
                mostrarPaquetes(todosPaquetes);
            } catch (e) {
                document.getElementById('paquetes-grid').innerHTML =
                    '<div class="col-12 text-center text-danger">' +
                    'Error al cargar paquetes.</div>';
            }
        }

        /**
         * filtrar()
         * Filtra los paquetes por categoria en memoria.
         * Cambia el estilo del boton activo con Bootstrap.
         */
        function filtrar(btn, categoria) {
            // Quitar estilo activo de todos los botones
            document.querySelectorAll('.btn[onclick^="filtrar"]')
                .forEach(b => {
                    b.classList.remove('btn-naranja');
                    b.classList.add('btn-outline-secondary');
                });

            // Activar el boton clickeado
            btn.classList.remove('btn-outline-secondary');
            btn.classList.add('btn-naranja');

            // Filtrar la lista en memoria
            const resultado = categoria
                ? todosPaquetes.filter(p => p.categoria === categoria)
                : todosPaquetes;

            mostrarPaquetes(resultado);
        }

        /**
         * mostrarPaquetes()
         * Construye el HTML de cada tarjeta de paquete
         * y lo inserta en el grid dinamicamente.
         */
        function mostrarPaquetes(paquetes) {
            const grid = document.getElementById('paquetes-grid');
            document.getElementById('contador').textContent =
                paquetes.length + ' paquete(s) disponible(s)';

            if (paquetes.length === 0) {
                grid.innerHTML =
                    '<div class="col-12 text-center py-5 text-muted">' +
                    '<i class="bi bi-search fs-2 d-block mb-2"></i>' +
                    'No hay paquetes en esta categoria.</div>';
                return;
            }

            grid.innerHTML = '';

            // Colores segun categoria del paquete
            const colores = {
                'PLAYA':    { bg: '#E8F4F9', icono: 'bi-water',       color: '#2E86AB' },
                'CULTURAL': { bg: '#FFF3E0', icono: 'bi-building',     color: '#F5A623' },
                'AVENTURA': { bg: '#E8F5E9', icono: 'bi-tree',         color: '#2E7D32' },
                'ECO':      { bg: '#F1F8E9', icono: 'bi-flower1',      color: '#558B2F' },
                'CIUDAD':   { bg: '#F3E5F5', icono: 'bi-buildings',    color: '#7B1FA2' }
            };

            paquetes.forEach(p => {
                const estilo = colores[p.categoria] ||
                    { bg: '#F5F5F5', icono: 'bi-bag', color: '#666' };
                const noches = (p.duracionDias || 1) - 1;
                const col    = document.createElement('div');
                col.className = 'col';

                col.innerHTML = `
                    <div class="paquete-card bg-white"
                         onclick="window.location.href=
                         'detalle-paquete.jsp?id=${p.id}'">

                        <!-- Banner de color segun categoria -->
                        <div class="paquete-banner"
                             style="background-color:${estilo.bg}">
                            <i class="bi ${estilo.icono}"
                               style="font-size:2.5rem;
                                      color:${estilo.color}"></i>
                        </div>

                        <div class="p-3">
                            <!--
                                Bootstrap badge — etiqueta de categoria.
                                rounded-pill: bordes completamente redondeados.
                            -->
                            <span class="badge rounded-pill mb-2"
                                  style="background-color:${estilo.color}">
                                ${p.categoria || 'GENERAL'}
                            </span>

                            <h6 class="fw-bold mb-1">${p.nombre}</h6>

                            <!-- Descripcion truncada a 2 lineas -->
                            <p class="text-muted small mb-2"
                               style="display:-webkit-box;
                                      -webkit-line-clamp:2;
                                      -webkit-box-orient:vertical;
                                      overflow:hidden">
                                ${p.descripcion || 'Sin descripcion.'}
                            </p>

                            <!-- Datos rapidos con iconos -->
                            <div class="d-flex gap-3 text-muted
                                        small mb-3">
                                <span>
                                    <i class="bi bi-calendar3"></i>
                                    ${p.duracionDias} dias /
                                    ${noches} noches
                                </span>
                                <span>
                                    <i class="bi bi-people"></i>
                                    Max. ${p.cupoMaximo}
                                </span>
                            </div>

                            <!-- Precio y boton -->
                            <div class="d-flex justify-content-between
                                        align-items-center
                                        border-top pt-3">
                                <div class="precio">
                                    $${Number(p.precioBase)
                                        .toLocaleString('es-MX')}
                                    <span class="text-muted fw-normal"
                                          style="font-size:.75rem">
                                        /persona
                                    </span>
                                </div>
                                <button class="btn btn-naranja btn-sm"
                                    onclick="event.stopPropagation();
                                    window.location.href=
                                    'detalle-paquete.jsp?id=${p.id}'">
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