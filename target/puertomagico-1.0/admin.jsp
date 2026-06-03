<%-- 
    isELIgnored="true" — le dice a JSP que NO interprete
    el ${} como Expression Language de Java.
    Esto es necesario porque usamos ${} en JavaScript
    (template literals) y sin esto JSP los confunde
    con variables Java y marca error.
--%>
<%@ page contentType="text/html;charset=UTF-8" 
         language="java" 
         isELIgnored="true" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin - Puerto Magico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --naranja: #F5A623;
            --naranja-dark: #D48A10;
            --azul: #2E86AB;
            --sidebar-bg: #1E1E2E;
        }

        /* ── SIDEBAR ─────────────────────────────────── */
        /*
         * position:fixed — el sidebar no se mueve al hacer scroll.
         * height:100vh   — ocupa toda la altura de la pantalla.
         * z-index:1000   — se pone encima de cualquier otro elemento.
         */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 220px;
            background-color: var(--sidebar-bg);
            display: flex;
            flex-direction: column;
            z-index: 1000;
        }

        .sidebar-logo {
            padding: 1.25rem 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        /* Boton del menu lateral */
        .nav-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 16px;
            color: rgba(255,255,255,0.7);
            background: none;
            border: none;
            border-left: 3px solid transparent;
            width: 100%;
            text-align: left;
            font-size: .9rem;
            cursor: pointer;
        }
        .nav-btn:hover {
            background-color: rgba(255,255,255,0.05);
            color: #fff;
        }
        /* Boton activo — resalta con color naranja */
        .nav-btn.activo {
            background-color: rgba(255,255,255,0.08);
            color: var(--naranja);
            border-left-color: var(--naranja);
        }

        /* ── CONTENIDO PRINCIPAL ─────────────────────── */
        /*
         * margin-left:220px — deja espacio para el sidebar fijo.
         * min-height:100vh  — ocupa toda la pantalla.
         */
        .main-content {
            margin-left: 220px;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        /* Topbar del panel */
        .topbar {
            background: #fff;
            border-bottom: 1px solid #dee2e6;
            padding: 0.75rem 1.5rem;
        }

        /* Secciones ocultas por defecto */
        .seccion { display: none; }
        .seccion.activa { display: block; }

        /* Tarjeta de estadistica */
        .stat-card {
            border-left: 4px solid var(--naranja);
            border-top: none;
            border-right: none;
            border-bottom: none;
        }

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
    </style>
</head>
<body>

    <!-- ── SIDEBAR ──────────────────────────────────────── -->
    <aside class="sidebar">

        <!-- Logo -->
        <div class="sidebar-logo">
            <div class="fw-bold"
                 style="color:var(--naranja);font-size:1rem">
                PuertoMagico
            </div>
            <div class="text-white-50" style="font-size:.75rem">
                Panel Administrativo
            </div>
        </div>

        <!-- Menu de navegacion -->
        <nav class="flex-grow-1 py-2">
            <button class="nav-btn activo"
                    onclick="mostrarSeccion('dashboard', this)">
                <i class="bi bi-speedometer2"></i> Dashboard
            </button>
            <button class="nav-btn"
                    onclick="mostrarSeccion('tours', this)">
                <i class="bi bi-map"></i> Tours
            </button>
            <button class="nav-btn"
                    onclick="mostrarSeccion('reservas', this)">
                <i class="bi bi-calendar-check"></i> Reservas
            </button>
            <button class="nav-btn"
                    onclick="mostrarSeccion('usuarios', this)">
                <i class="bi bi-people"></i> Usuarios
            </button>
        </nav>

        <!-- Pie del sidebar -->
        <div class="p-3 border-top"
             style="border-color:rgba(255,255,255,.1) !important">
            <div class="text-white-50 small mb-2"
                 id="sidebar-nombre">
                Cargando...
            </div>
            <button class="btn btn-sm btn-outline-danger w-100"
                    onclick="cerrarSesion()">
                <i class="bi bi-box-arrow-left me-1"></i>
                Cerrar sesion
            </button>
        </div>
    </aside>

    <!-- ── CONTENIDO PRINCIPAL ───────────────────────────── -->
    <div class="main-content">

        <!-- Topbar -->
        <div class="topbar d-flex justify-content-between align-items-center">
            <h6 class="mb-0 fw-bold" id="topbar-titulo">Dashboard</h6>
            <span class="text-muted small" id="topbar-nombre"></span>
        </div>

        <!-- Contenido de cada seccion -->
        <div class="p-4">

            <!-- ── DASHBOARD ─────────────────────────────── -->
            <div class="seccion activa" id="sec-dashboard">

                <!--
                    Bootstrap Grid de estadisticas.
                    row-cols-md-4: 4 columnas en pantallas medianas.
                -->
                <div class="row row-cols-1 row-cols-md-4 g-3 mb-4">
                    <div class="col">
                        <div class="card stat-card shadow-sm">
                            <div class="card-body">
                                <div class="text-muted small">
                                    Tours activos
                                </div>
                                <div class="fs-3 fw-bold"
                                     id="stat-tours">-</div>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card shadow-sm"
                             style="border-left:4px solid var(--azul)">
                            <div class="card-body">
                                <div class="text-muted small">
                                    Total reservas
                                </div>
                                <div class="fs-3 fw-bold"
                                     id="stat-reservas">-</div>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card shadow-sm"
                             style="border-left:4px solid #198754">
                            <div class="card-body">
                                <div class="text-muted small">
                                    Usuarios
                                </div>
                                <div class="fs-3 fw-bold"
                                     id="stat-usuarios">-</div>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card shadow-sm"
                             style="border-left:4px solid #dc3545">
                            <div class="card-body">
                                <div class="text-muted small">
                                    Pendientes
                                </div>
                                <div class="fs-3 fw-bold"
                                     id="stat-pendientes">-</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Ultimas reservas -->
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white fw-bold">
                        Ultimas reservas
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Cliente</th>
                                        <th>Servicio</th>
                                        <th>Fecha viaje</th>
                                        <th>Total</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody id="tabla-dash-reservas">
                                    <tr>
                                        <td colspan="5"
                                            class="text-center
                                                   text-muted py-3">
                                            Cargando...
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ── TOURS ──────────────────────────────────── -->
            <div class="seccion" id="sec-tours">

                <!-- Alerta de operaciones -->
                <div id="alerta-tours" class="d-none mb-3"></div>

                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white d-flex
                                justify-content-between align-items-center">
                        <span class="fw-bold">Gestion de Tours</span>
                        <button class="btn btn-naranja btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#modalTour"
                                onclick="prepararModalNuevo()">
                            <i class="bi bi-plus-lg me-1"></i>
                            Nuevo tour
                        </button>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Nombre</th>
                                        <th>Destino</th>
                                        <th>Precio</th>
                                        <th>Horas</th>
                                        <th>Dificultad</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="tabla-tours">
                                    <tr>
                                        <td colspan="7"
                                            class="text-center
                                                   text-muted py-3">
                                            Cargando...
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ── RESERVAS ───────────────────────────────── -->
            <div class="seccion" id="sec-reservas">

                <div id="alerta-reservas" class="d-none mb-3"></div>

                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white d-flex
                                justify-content-between align-items-center">
                        <span class="fw-bold">Gestion de Reservas</span>
                        <!--
                            Filtro por estado — onchange llama a
                            filtrarReservas() cuando cambia el valor.
                        -->
                        <select class="form-select form-select-sm w-auto"
                                id="filtro-estado"
                                onchange="filtrarReservas()">
                            <option value="">Todos los estados</option>
                            <option value="PENDIENTE">Pendiente</option>
                            <option value="PAGADA">Pagada</option>
                            <option value="CONFIRMADA">Confirmada</option>
                            <option value="CANCELADA">Cancelada</option>
                        </select>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Cliente</th>
                                        <th>Servicio</th>
                                        <th>Fecha viaje</th>
                                        <th>Personas</th>
                                        <th>Total</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="tabla-reservas">
                                    <tr>
                                        <td colspan="8"
                                            class="text-center
                                                   text-muted py-3">
                                            Cargando...
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ── USUARIOS ───────────────────────────────── -->
            <div class="seccion" id="sec-usuarios">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white fw-bold">
                        Usuarios registrados
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Nombre</th>
                                        <th>Email</th>
                                        <th>Telefono</th>
                                        <th>Rol</th>
                                        <th>Registro</th>
                                    </tr>
                                </thead>
                                <tbody id="tabla-usuarios">
                                    <tr>
                                        <td colspan="6"
                                            class="text-center
                                                   text-muted py-3">
                                            Cargando...
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!--
        MODAL DE TOUR — Bootstrap Modal
        data-bs-backdrop="static": no se cierra al hacer clic fuera.
        El boton "Nuevo tour" lo abre con data-bs-toggle="modal".
    -->
    <div class="modal fade" id="modalTour" tabindex="-1"
         data-bs-backdrop="static">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title fw-bold"
                        id="modal-titulo">Nuevo Tour</h5>
                    <button type="button" class="btn-close"
                            data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <!-- ID oculto para saber si es edicion o creacion -->
                    <input type="hidden" id="tour-id">

                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold small">
                                Nombre del tour
                            </label>
                            <input type="text" class="form-control"
                                   id="tour-nombre"
                                   placeholder="Ej: Tour Monte Alban">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">
                                Destino ID
                            </label>
                            <input type="number" class="form-control"
                                   id="tour-destino" placeholder="1">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">
                                Vehiculo ID
                            </label>
                            <input type="number" class="form-control"
                                   id="tour-vehiculo" placeholder="1">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small">
                                Precio por persona ($)
                            </label>
                            <input type="number" class="form-control"
                                   id="tour-precio"
                                   placeholder="850" step="0.01">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small">
                                Duracion (horas)
                            </label>
                            <input type="number" class="form-control"
                                   id="tour-duracion" placeholder="8">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small">
                                Cupo maximo
                            </label>
                            <input type="number" class="form-control"
                                   id="tour-cupo" placeholder="15">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">
                                Dificultad
                            </label>
                            <select class="form-select"
                                    id="tour-dificultad">
                                <option value="FACIL">Facil</option>
                                <option value="MODERADA">Moderada</option>
                                <option value="DIFICIL">Dificil</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold small">
                                Descripcion
                            </label>
                            <textarea class="form-control"
                                      id="tour-descripcion"
                                      rows="3"
                                      placeholder="Descripcion del tour...">
                            </textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button"
                            class="btn btn-outline-secondary"
                            data-bs-dismiss="modal">
                        Cancelar
                    </button>
                    <button type="button"
                            class="btn btn-naranja"
                            onclick="guardarTour()">
                        <i class="bi bi-save me-1"></i>
                        Guardar
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const BASE = '/PuertoMagico';

        // Guardamos todas las reservas para filtrar sin otra peticion
        let todasReservas = [];

        // Referencia al modal de Bootstrap para abrirlo y cerrarlo
        let modalTour;

        window.onload = async function () {
            // Inicializar el objeto Modal de Bootstrap
            modalTour = new bootstrap.Modal(
                document.getElementById('modalTour'));

            await verificarAdmin();
            cargarDashboard();
        };

        /**
         * verificarAdmin()
         * Verifica que haya sesion con rol ADMIN.
         * Si no, redirige al login — un cliente no puede
         * acceder al panel de administracion.
         */
        async function verificarAdmin() {
            try {
                const res  = await fetch(BASE + '/api/usuarios/sesion');
                const data = await res.json();

                if (data.error || data.rol !== 'ADMIN') {
                    alert('Acceso denegado. Solo administradores.');
                    window.location.href = 'login.jsp';
                    return;
                }

                // Mostrar nombre del admin en la interfaz
                document.getElementById('sidebar-nombre')
                    .textContent = data.nombre;
                document.getElementById('topbar-nombre')
                    .textContent = data.nombre;

            } catch (e) {
                window.location.href = 'login.jsp';
            }
        }

        /**
         * mostrarSeccion()
         * Oculta todas las secciones y muestra solo la seleccionada.
         * Actualiza el boton activo del sidebar.
         */
        function mostrarSeccion(nombre, btn) {
            // Ocultar todas las secciones
            document.querySelectorAll('.seccion')
                .forEach(s => s.classList.remove('activa'));

            // Mostrar la seccion seleccionada
            document.getElementById('sec-' + nombre)
                .classList.add('activa');

            // Actualizar boton activo en el sidebar
            document.querySelectorAll('.nav-btn')
                .forEach(b => b.classList.remove('activo'));
            btn.classList.add('activo');

            // Actualizar titulo del topbar
            const titulos = {
                dashboard: 'Dashboard',
                tours:     'Gestion de Tours',
                reservas:  'Gestion de Reservas',
                usuarios:  'Usuarios'
            };
            document.getElementById('topbar-titulo')
                .textContent = titulos[nombre];

            // Cargar datos de la seccion correspondiente
            if (nombre === 'tours')    cargarTours();
            if (nombre === 'reservas') cargarReservas();
            if (nombre === 'usuarios') cargarUsuarios();
        }

        // ── DASHBOARD ──────────────────────────────────────

        async function cargarDashboard() {
            try {
                const [resTours, resReservas] = await Promise.all([
                    fetch(BASE + '/api/tours'),
                    fetch(BASE + '/api/reservas/mis-reservas')
                ]);

                const tours    = await resTours.json();
                const reservas = await resReservas.json();

                document.getElementById('stat-tours')
                    .textContent = Array.isArray(tours)
                    ? tours.length : 0;

                if (Array.isArray(reservas)) {
                    document.getElementById('stat-reservas')
                        .textContent = reservas.length;

                    const pendientes = reservas.filter(
                        r => r.estado === 'PENDIENTE').length;
                    document.getElementById('stat-pendientes')
                        .textContent = pendientes;

                    llenarTablaReservas(
                        'tabla-dash-reservas',
                        reservas.slice(0, 5),
                        false);
                }

            } catch (e) {
                console.error('Error en dashboard:', e);
            }
        }

        // ── TOURS ──────────────────────────────────────────

        async function cargarTours() {
            try {
                const res   = await fetch(BASE + '/api/tours');
                const tours = await res.json();
                const tbody = document.getElementById('tabla-tours');

                if (!Array.isArray(tours) || tours.length === 0) {
                    tbody.innerHTML =
                        '<tr><td colspan="7" class="text-center' +
                        ' text-muted py-3">Sin tours</td></tr>';
                    return;
                }

                tbody.innerHTML = '';
                tours.forEach(t => {
                    const badgeClass = t.dificultad === 'FACIL'
                        ? 'bg-success'
                        : t.dificultad === 'MODERADA'
                        ? 'bg-warning text-dark'
                        : 'bg-danger';

                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td>${t.id}</td>
                        <td class="fw-semibold">${t.nombre}</td>
                        <td>${t.nombreDestino || '-'}</td>
                        <td>$${Number(t.precioBase)
                            .toLocaleString('es-MX')}</td>
                        <td>${t.duracionHoras} hrs</td>
                        <td>
                            <span class="badge ${badgeClass}">
                                ${t.dificultad}
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-outline-primary
                                           btn-sm me-1"
                                    onclick="editarTour(${t.id},
                                    '${t.nombre}',
                                    ${t.destinoId},
                                    ${t.vehiculoId},
                                    ${t.precioBase},
                                    ${t.duracionHoras},
                                    ${t.cupoMaximo},
                                    '${t.dificultad}',
                                    '${(t.descripcion||'')
                                        .replace(/'/g,"\\'")}')">
                                <i class="bi bi-pencil"></i>
                            </button>
                            <button class="btn btn-outline-danger btn-sm"
                                    onclick="desactivarTour(${t.id},
                                    '${t.nombre}')">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    `;
                    tbody.appendChild(tr);
                });

            } catch (e) {
                console.error('Error al cargar tours:', e);
            }
        }

        /**
         * prepararModalNuevo()
         * Limpia todos los campos del modal antes de abrir
         * para crear un tour nuevo.
         */
        function prepararModalNuevo() {
            document.getElementById('modal-titulo')
                .textContent = 'Nuevo Tour';
            document.getElementById('tour-id').value        = '';
            document.getElementById('tour-nombre').value    = '';
            document.getElementById('tour-destino').value   = '';
            document.getElementById('tour-vehiculo').value  = '';
            document.getElementById('tour-precio').value    = '';
            document.getElementById('tour-duracion').value  = '';
            document.getElementById('tour-cupo').value      = '';
            document.getElementById('tour-descripcion').value = '';
        }

        /**
         * editarTour()
         * Llena el modal con los datos del tour seleccionado
         * para edicion. El ID indica que es una edicion, no creacion.
         */
        function editarTour(id, nombre, destinoId, vehiculoId,
                             precio, duracion, cupo,
                             dificultad, descripcion) {
            document.getElementById('modal-titulo')
                .textContent = 'Editar Tour';
            document.getElementById('tour-id').value        = id;
            document.getElementById('tour-nombre').value    = nombre;
            document.getElementById('tour-destino').value   = destinoId;
            document.getElementById('tour-vehiculo').value  = vehiculoId;
            document.getElementById('tour-precio').value    = precio;
            document.getElementById('tour-duracion').value  = duracion;
            document.getElementById('tour-cupo').value      = cupo;
            document.getElementById('tour-dificultad').value= dificultad;
            document.getElementById('tour-descripcion').value = descripcion;
            modalTour.show();
        }

        /**
         * guardarTour()
         * Lee el formulario del modal.
         * Si tiene ID hace PUT (editar), si no hace POST (crear).
         */
        async function guardarTour() {
            const id = document.getElementById('tour-id').value;

            const tour = {
                nombre:        document.getElementById('tour-nombre').value,
                destinoId:     parseInt(document.getElementById('tour-destino').value),
                vehiculoId:    parseInt(document.getElementById('tour-vehiculo').value),
                precioBase:    parseFloat(document.getElementById('tour-precio').value),
                duracionHoras: parseInt(document.getElementById('tour-duracion').value),
                cupoMaximo:    parseInt(document.getElementById('tour-cupo').value),
                dificultad:    document.getElementById('tour-dificultad').value,
                descripcion:   document.getElementById('tour-descripcion').value
            };

            if (!tour.nombre || !tour.precioBase) {
                mostrarAlerta('alerta-tours', 'danger',
                    'Nombre y precio son obligatorios.');
                return;
            }

            try {
                // Si hay ID es edicion (PUT), si no es creacion (POST)
                if (id) tour.id = parseInt(id);

                const res  = await fetch(BASE + '/api/tours', {
                    method:  id ? 'PUT' : 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body:    JSON.stringify(tour)
                });
                const data = await res.json();

                if (data.error) {
                    mostrarAlerta('alerta-tours', 'danger', data.mensaje);
                } else {
                    modalTour.hide();
                    mostrarAlerta('alerta-tours', 'success', data.mensaje);
                    cargarTours();
                }
            } catch (e) {
                mostrarAlerta('alerta-tours', 'danger',
                    'Error de conexion.');
            }
        }

        async function desactivarTour(id, nombre) {
            if (!confirm('Desactivar el tour "' + nombre + '"?')) return;

            try {
                const res  = await fetch(
                    BASE + '/api/tours?id=' + id,
                    { method: 'DELETE' });
                const data = await res.json();

                if (data.error) {
                    mostrarAlerta('alerta-tours', 'danger', data.mensaje);
                } else {
                    mostrarAlerta('alerta-tours', 'success', data.mensaje);
                    cargarTours();
                }
            } catch (e) {
                mostrarAlerta('alerta-tours', 'danger', 'Error de conexion.');
            }
        }

        // ── RESERVAS ───────────────────────────────────────

        async function cargarReservas() {
            try {
                const res  = await fetch(
                    BASE + '/api/reservas/mis-reservas');
                todasReservas = await res.json();

                if (!Array.isArray(todasReservas)) todasReservas = [];
                llenarTablaReservas(
                    'tabla-reservas', todasReservas, true);

            } catch (e) {
                console.error('Error al cargar reservas:', e);
            }
        }

        function filtrarReservas() {
            const estado = document.getElementById('filtro-estado').value;
            const filtradas = estado
                ? todasReservas.filter(r => r.estado === estado)
                : todasReservas;
            llenarTablaReservas('tabla-reservas', filtradas, true);
        }

        /**
         * llenarTablaReservas()
         * Llena una tabla con la lista de reservas.
         * conAcciones: si muestra botones de confirmar/cancelar.
         */
        function llenarTablaReservas(tablaId, reservas, conAcciones) {
            const tbody = document.getElementById(tablaId);

            if (!reservas || reservas.length === 0) {
                tbody.innerHTML =
                    '<tr><td colspan="8" class="text-center' +
                    ' text-muted py-3">Sin reservas</td></tr>';
                return;
            }

            tbody.innerHTML = '';
            reservas.forEach(r => {
                // Badge de color segun el estado de la reserva
                const badges = {
                    'PENDIENTE':  'bg-warning text-dark',
                    'PAGADA':     'bg-primary',
                    'CONFIRMADA': 'bg-success',
                    'CANCELADA':  'bg-danger'
                };

                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>#${r.id}</td>
                    <td>${r.nombreUsuario || '-'}</td>
                    <td>${r.nombreServicio || '-'}</td>
                    <td>${r.fechaViaje || '-'}</td>
                    <td>${r.personas}</td>
                    <td>$${Number(r.total).toLocaleString('es-MX')}</td>
                    <td>
                        <span class="badge ${badges[r.estado] || 'bg-secondary'}">
                            ${r.estado}
                        </span>
                    </td>
                    <td>
                        ${conAcciones ? `
                        <button class="btn btn-success btn-sm me-1"
                            onclick="cambiarEstado(${r.id},'CONFIRMADA')">
                            <i class="bi bi-check"></i>
                        </button>
                        <button class="btn btn-danger btn-sm"
                            onclick="cambiarEstado(${r.id},'CANCELADA')">
                            <i class="bi bi-x"></i>
                        </button>` : ''}
                    </td>
                `;
                tbody.appendChild(tr);
            });
        }

        async function cambiarEstado(id, estado) {
            if (!confirm('Cambiar reserva #' + id + ' a ' + estado + '?'))
                return;

            try {
                const res = await fetch(
                    BASE + '/api/reservas/cancelar', {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body:    JSON.stringify({
                        reservaId:   id,
                        nuevoEstado: estado
                    })
                });
                const data = await res.json();

                if (!data.error) {
                    mostrarAlerta('alerta-reservas', 'success',
                        'Estado actualizado correctamente.');
                    cargarReservas();
                } else {
                    mostrarAlerta('alerta-reservas', 'danger',
                        data.mensaje);
                }
            } catch (e) {
                mostrarAlerta('alerta-reservas', 'danger',
                    'Error de conexion.');
            }
        }

        // ── USUARIOS ───────────────────────────────────────

        async function cargarUsuarios() {
            try {
                const res  = await fetch(BASE + '/api/usuarios/sesion');
                const data = await res.json();
                const tbody = document.getElementById('tabla-usuarios');
                tbody.innerHTML = `
                    <tr>
                        <td>${data.usuarioId}</td>
                        <td>${data.nombre}</td>
                        <td>${data.email}</td>
                        <td>-</td>
                        <td>
                            <span class="badge bg-warning text-dark">
                                ${data.rol}
                            </span>
                        </td>
                        <td>-</td>
                    </tr>
                `;
            } catch (e) {
                console.error('Error al cargar usuarios:', e);
            }
        }

        // ── UTILIDADES ─────────────────────────────────────

        /*
          Muestra un mensaje de exito o error usando
          los componentes de alerta de Bootstrap.
          Se oculta automaticamente en 3 segundos.
         */
        function mostrarAlerta(id, tipo, mensaje) {
            const el = document.getElementById(id);
            el.className = 'alert alert-' + tipo + ' py-2 small';
            el.textContent = mensaje;
            el.classList.remove('d-none');
            setTimeout(() => el.classList.add('d-none'), 3000);
        }

        async function cerrarSesion() {
            await fetch(BASE + '/api/usuarios/logout');
            window.location.href = 'login.jsp';
        }
    </script>
</body>
</html>