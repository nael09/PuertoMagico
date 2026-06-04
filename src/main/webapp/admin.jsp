<%-- 
    admin.jsp — Panel de Administracion
    isELIgnored="true": evita que JSP confunda ${} de 
    JavaScript con Expression Language de Java.
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
            --naranja-dk: #D48A10;
            --azul: #2E86AB;
            --sidebar: #1E1E2E;
        }
        /* Sidebar fijo en el lado izquierdo */
        .sidebar {
            position: fixed; top: 0; left: 0;
            width: 210px; height: 100vh;
            background: var(--sidebar);
            display: flex; flex-direction: column;
            z-index: 1000;
        }
        .sidebar-logo {
            padding: 1rem;
            border-bottom: 1px solid rgba(255,255,255,.1);
        }
        /* Botones del menu lateral */
        .nav-btn {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 16px; width: 100%; text-align: left;
            color: rgba(255,255,255,.7); background: none;
            border: none; border-left: 3px solid transparent;
            font-size: .9rem; cursor: pointer;
        }
        .nav-btn:hover { background: rgba(255,255,255,.05); color: #fff; }
        .nav-btn.activo {
            background: rgba(255,255,255,.08);
            color: var(--naranja);
            border-left-color: var(--naranja);
        }
        /* Contenido principal con margen para el sidebar */
        .main { margin-left: 210px; min-height: 100vh; background: #f8f9fa; }
        .topbar {
            background: #fff;
            border-bottom: 1px solid #dee2e6;
            padding: .75rem 1.5rem;
        }
        /* Solo una seccion visible a la vez */
        .seccion { display: none; }
        .seccion.activa { display: block; }
        .btn-naranja {
            background: var(--naranja); border-color: var(--naranja);
            color: #fff; font-weight: 600;
        }
        .btn-naranja:hover { background: var(--naranja-dk); color: #fff; }
    </style>
</head>
<body>

<%-- ══ SIDEBAR ═══════════════════════════════════════ --%>
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="fw-bold" style="color:var(--naranja)">PuertoMagico</div>
        <div class="text-white-50" style="font-size:.75rem">Panel Admin</div>
    </div>
    <nav class="flex-grow-1 py-2">
        <button class="nav-btn activo" onclick="ir('dashboard',this)">
            <i class="bi bi-speedometer2"></i> Dashboard
        </button>
        <button class="nav-btn" onclick="ir('tours',this)">
            <i class="bi bi-map"></i> Tours
        </button>
        <button class="nav-btn" onclick="ir('reservas',this)">
            <i class="bi bi-calendar-check"></i> Reservas
        </button>
        <button class="nav-btn" onclick="ir('usuarios',this)">
            <i class="bi bi-people"></i> Usuarios
        </button>
    </nav>
    <div class="p-3 border-top" style="border-color:rgba(255,255,255,.1)!important">
        <small class="text-white-50 d-block mb-2" id="admin-nombre">...</small>
        <button class="btn btn-sm btn-outline-danger w-100" onclick="salir()">
            <i class="bi bi-box-arrow-left me-1"></i> Cerrar sesion
        </button>
    </div>
</aside>

<%-- ══ CONTENIDO ══════════════════════════════════════ --%>
<div class="main">
    <div class="topbar d-flex justify-content-between align-items-center">
        <h6 class="mb-0 fw-bold" id="titulo-seccion">Dashboard</h6>
        <small class="text-muted" id="admin-nombre-top"></small>
    </div>

    <div class="p-4">

        <%-- DASHBOARD --%>
        <div class="seccion activa" id="sec-dashboard">
            <%-- Tarjetas de estadisticas --%>
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="card shadow-sm"
                         style="border-left:4px solid var(--naranja)">
                        <div class="card-body">
                            <div class="text-muted small">Tours activos</div>
                            <div class="fs-3 fw-bold" id="s-tours">-</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow-sm"
                         style="border-left:4px solid var(--azul)">
                        <div class="card-body">
                            <div class="text-muted small">Reservas</div>
                            <div class="fs-3 fw-bold" id="s-reservas">-</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow-sm"
                         style="border-left:4px solid #198754">
                        <div class="card-body">
                            <div class="text-muted small">Usuarios</div>
                            <div class="fs-3 fw-bold" id="s-usuarios">-</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow-sm"
                         style="border-left:4px solid #dc3545">
                        <div class="card-body">
                            <div class="text-muted small">Pendientes</div>
                            <div class="fs-3 fw-bold" id="s-pendientes">-</div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Tabla de ultimas reservas --%>
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white fw-bold">
                    Ultimas reservas
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th><th>Cliente</th>
                                <th>Servicio</th><th>Total</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody id="tb-dash"></tbody>
                    </table>
                </div>
            </div>
        </div>

        <%-- TOURS --%>
        <div class="seccion" id="sec-tours">
            <div id="alerta-tours" class="d-none mb-3"></div>
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white d-flex
                            justify-content-between align-items-center">
                    <span class="fw-bold">Gestion de Tours</span>
                    <button class="btn btn-naranja btn-sm"
                            data-bs-toggle="modal"
                            data-bs-target="#modalTour"
                            onclick="modalNuevo()">
                        <i class="bi bi-plus-lg me-1"></i> Nuevo tour
                    </button>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th><th>Nombre</th>
                                    <th>Destino</th><th>Precio</th>
                                    <th>Horas</th><th>Dificultad</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody id="tb-tours"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <%-- RESERVAS --%>
        <div class="seccion" id="sec-reservas">
            <div id="alerta-reservas" class="d-none mb-3"></div>
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white d-flex
                            justify-content-between align-items-center">
                    <span class="fw-bold">Gestion de Reservas</span>
                    <select class="form-select form-select-sm w-auto"
                            id="filtro-estado"
                            onchange="filtrarReservas()">
                        <option value="">Todos</option>
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
                                    <th>#</th><th>Cliente</th>
                                    <th>Servicio</th><th>Fecha</th>
                                    <th>Personas</th><th>Total</th>
                                    <th>Estado</th><th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody id="tb-reservas"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <%-- USUARIOS --%>
        <div class="seccion" id="sec-usuarios">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white fw-bold">
                    Usuarios registrados
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th><th>Nombre</th><th>Email</th>
                                <th>Telefono</th><th>Rol</th>
                                <th>Registro</th>
                            </tr>
                        </thead>
                        <tbody id="tb-usuarios"></tbody>
                    </table>
                </div>
            </div>
        </div>

    </div><%-- fin p-4 --%>
</div><%-- fin main --%>

<%-- ══ MODAL TOUR ═════════════════════════════════════ --%>
<%--
    Bootstrap Modal — ventana emergente para crear o editar tours.
    data-bs-backdrop="static": no se cierra al hacer clic fuera.
--%>
<div class="modal fade" id="modalTour" tabindex="-1"
     data-bs-backdrop="static">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="modal-titulo">
                    Nuevo Tour
                </h5>
                <button type="button" class="btn-close"
                        data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="t-id">
                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label fw-semibold small">
                            Nombre del tour
                        </label>
                        <input type="text" class="form-control"
                               id="t-nombre"
                               placeholder="Ej: Tour Monte Alban">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">
                            Destino ID
                        </label>
                        <input type="number" class="form-control"
                               id="t-destino" placeholder="1">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">
                            Vehiculo ID
                        </label>
                        <input type="number" class="form-control"
                               id="t-vehiculo" placeholder="1">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold small">
                            Precio ($)
                        </label>
                        <input type="number" class="form-control"
                               id="t-precio" placeholder="850"
                               step="0.01">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold small">
                            Duracion (hrs)
                        </label>
                        <input type="number" class="form-control"
                               id="t-horas" placeholder="8">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold small">
                            Cupo maximo
                        </label>
                        <input type="number" class="form-control"
                               id="t-cupo" placeholder="15">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">
                            Dificultad
                        </label>
                        <select class="form-select" id="t-dificultad">
                            <option value="FACIL">Facil</option>
                            <option value="MODERADA">Moderada</option>
                            <option value="DIFICIL">Dificil</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold small">
                            Descripcion
                        </label>
                        <textarea class="form-control" id="t-desc"
                                  rows="3"
                                  placeholder="Descripcion...">
                        </textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline-secondary"
                        data-bs-dismiss="modal">
                    Cancelar
                </button>
                <button class="btn btn-naranja" onclick="guardarTour()">
                    <i class="bi bi-save me-1"></i> Guardar
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const BASE = '/PuertoMagico';
    let reservasData = [];
    let modal;

    // Al cargar la pagina: verificar admin y cargar dashboard
    window.onload = async function() {
        modal = new bootstrap.Modal(document.getElementById('modalTour'));
        await verificarAdmin();
        cargarDashboard();
    };

    // ── SESION ─────────────────────────────────────────────

    /**
     * verificarAdmin()
     * Consulta la sesion activa. Si no es ADMIN redirige al login.
     */
    async function verificarAdmin() {
        try {
            const data = await fetch(BASE + '/api/usuarios/sesion')
                .then(function(r) { return r.json(); });
            if (data.error || data.rol !== 'ADMIN') {
                alert('Acceso denegado.');
                location.href = 'login.jsp';
                return;
            }
            document.getElementById('admin-nombre')
                .textContent = data.nombre;
            document.getElementById('admin-nombre-top')
                .textContent = data.nombre;
        } catch(e) {
            location.href = 'login.jsp';
        }
    }

    async function salir() {
        await fetch(BASE + '/api/usuarios/logout');
        location.href = 'login.jsp';
    }

    // ── NAVEGACION ─────────────────────────────────────────

    /**
     * ir()
     * Muestra la seccion seleccionada y oculta las demas.
     * Tambien carga los datos de esa seccion.
     */
    function ir(sec, btn) {
        document.querySelectorAll('.seccion')
            .forEach(function(s) { s.classList.remove('activa'); });
        document.getElementById('sec-' + sec).classList.add('activa');

        document.querySelectorAll('.nav-btn')
            .forEach(function(b) { b.classList.remove('activo'); });
        btn.classList.add('activo');

        var titulos = {
            dashboard: 'Dashboard',
            tours: 'Gestion de Tours',
            reservas: 'Gestion de Reservas',
            usuarios: 'Usuarios'
        };
        document.getElementById('titulo-seccion')
            .textContent = titulos[sec];

        if (sec === 'tours')    cargarTours();
        if (sec === 'reservas') cargarReservas();
        if (sec === 'usuarios') cargarUsuarios();
    }

    // ── DASHBOARD ──────────────────────────────────────────

    async function cargarDashboard() {
        try {
            var tours = await fetch(BASE + '/api/tours')
                .then(function(r) { return r.json(); });
            var reservas = await fetch(BASE + '/api/reservas/mis-reservas')
                .then(function(r) { return r.json(); });

            document.getElementById('s-tours')
                .textContent = Array.isArray(tours) ? tours.length : 0;

            if (Array.isArray(reservas)) {
                document.getElementById('s-reservas')
                    .textContent = reservas.length;
                document.getElementById('s-pendientes')
                    .textContent = reservas.filter(function(r) {
                        return r.estado === 'PENDIENTE';
                    }).length;
                renderReservas('tb-dash', reservas.slice(0, 5), false);
            }
        } catch(e) { console.error(e); }
    }

    // ── TOURS ──────────────────────────────────────────────

    async function cargarTours() {
        try {
            var tours = await fetch(BASE + '/api/tours')
                .then(function(r) { return r.json(); });
            var tb = document.getElementById('tb-tours');

            if (!Array.isArray(tours) || tours.length === 0) {
                tb.innerHTML = '<tr><td colspan="7"' +
                    ' class="text-center text-muted py-3">' +
                    'Sin tours</td></tr>';
                return;
            }

            tb.innerHTML = '';
            tours.forEach(function(t) {
                var bc = t.dificultad === 'FACIL' ? 'bg-success'
                    : t.dificultad === 'MODERADA' ? 'bg-warning text-dark'
                    : 'bg-danger';
                var desc = (t.descripcion || '').replace(/'/g, "\\'");

                // Construimos la fila con concatenacion de strings
                // (no template literals, para evitar conflictos con JSP)
                tb.innerHTML +=
                    '<tr>' +
                    '<td>' + t.id + '</td>' +
                    '<td class="fw-semibold">' + t.nombre + '</td>' +
                    '<td>' + (t.nombreDestino || '-') + '</td>' +
                    '<td>$' + Number(t.precioBase)
                        .toLocaleString('es-MX') + '</td>' +
                    '<td>' + t.duracionHoras + ' hrs</td>' +
                    '<td><span class="badge ' + bc + '">' +
                    t.dificultad + '</span></td>' +
                    '<td>' +
                    '<button class="btn btn-outline-primary btn-sm me-1"' +
                    ' onclick="abrirEditar(' + t.id + ',\'' + t.nombre +
                    '\',' + t.destinoId + ',' + t.vehiculoId + ',' +
                    t.precioBase + ',' + t.duracionHoras + ',' +
                    t.cupoMaximo + ',\'' + t.dificultad + '\',\'' +
                    desc + '\')">' +
                    '<i class="bi bi-pencil"></i></button>' +
                    '<button class="btn btn-outline-danger btn-sm"' +
                    ' onclick="borrarTour(' + t.id + ',\'' +
                    t.nombre + '\')">' +
                    '<i class="bi bi-trash"></i></button>' +
                    '</td></tr>';
            });
        } catch(e) { console.error(e); }
    }

    // Limpia el modal para un tour nuevo
    function modalNuevo() {
        document.getElementById('modal-titulo').textContent = 'Nuevo Tour';
        document.getElementById('t-id').value      = '';
        document.getElementById('t-nombre').value  = '';
        document.getElementById('t-destino').value = '';
        document.getElementById('t-vehiculo').value= '';
        document.getElementById('t-precio').value  = '';
        document.getElementById('t-horas').value   = '';
        document.getElementById('t-cupo').value    = '';
        document.getElementById('t-desc').value    = '';
    }

    // Llena el modal con datos del tour a editar
    function abrirEditar(id, nombre, dest, veh,
                          precio, horas, cupo, dif, desc) {
        document.getElementById('modal-titulo').textContent = 'Editar Tour';
        document.getElementById('t-id').value         = id;
        document.getElementById('t-nombre').value     = nombre;
        document.getElementById('t-destino').value    = dest;
        document.getElementById('t-vehiculo').value   = veh;
        document.getElementById('t-precio').value     = precio;
        document.getElementById('t-horas').value      = horas;
        document.getElementById('t-cupo').value       = cupo;
        document.getElementById('t-dificultad').value = dif;
        document.getElementById('t-desc').value       = desc;
        modal.show();
    }

    /**
     * guardarTour()
     * POST = crear nuevo, PUT = editar existente.
     * Depende de si hay ID en el campo oculto.
     */
    async function guardarTour() {
        var id = document.getElementById('t-id').value;
        var tour = {
            nombre:        document.getElementById('t-nombre').value,
            destinoId:     parseInt(document.getElementById('t-destino').value),
            vehiculoId:    parseInt(document.getElementById('t-vehiculo').value),
            precioBase:    parseFloat(document.getElementById('t-precio').value),
            duracionHoras: parseInt(document.getElementById('t-horas').value),
            cupoMaximo:    parseInt(document.getElementById('t-cupo').value),
            dificultad:    document.getElementById('t-dificultad').value,
            descripcion:   document.getElementById('t-desc').value
        };

        if (!tour.nombre || !tour.precioBase) {
            alerta('alerta-tours', 'danger', 'Nombre y precio son obligatorios.');
            return;
        }

        if (id) tour.id = parseInt(id);

        try {
            var data = await fetch(BASE + '/api/tours', {
                method:  id ? 'PUT' : 'POST',
                headers: { 'Content-Type': 'application/json' },
                body:    JSON.stringify(tour)
            }).then(function(r) { return r.json(); });

            if (data.error) {
                alerta('alerta-tours', 'danger', data.mensaje);
            } else {
                modal.hide();
                alerta('alerta-tours', 'success', data.mensaje);
                cargarTours();
            }
        } catch(e) {
            alerta('alerta-tours', 'danger', 'Error de conexion.');
        }
    }

    async function borrarTour(id, nombre) {
        if (!confirm('Desactivar el tour "' + nombre + '"?')) return;
        try {
            var data = await fetch(BASE + '/api/tours?id=' + id,
                { method: 'DELETE' })
                .then(function(r) { return r.json(); });
            if (data.error) {
                alerta('alerta-tours', 'danger', data.mensaje);
            } else {
                alerta('alerta-tours', 'success', data.mensaje);
                cargarTours();
            }
        } catch(e) {
            alerta('alerta-tours', 'danger', 'Error de conexion.');
        }
    }

    // ── RESERVAS ───────────────────────────────────────────

    async function cargarReservas() {
        try {
            reservasData = await fetch(BASE + '/api/reservas/mis-reservas')
                .then(function(r) { return r.json(); });
            if (!Array.isArray(reservasData)) reservasData = [];
            renderReservas('tb-reservas', reservasData, true);
        } catch(e) { console.error(e); }
    }

    function filtrarReservas() {
        var estado = document.getElementById('filtro-estado').value;
        var lista = estado
            ? reservasData.filter(function(r) {
                return r.estado === estado; })
            : reservasData;
        renderReservas('tb-reservas', lista, true);
    }

    /**
     * renderReservas()
     * Dibuja las filas de la tabla de reservas.
     * conAcciones = true muestra botones confirmar/cancelar.
     */
    function renderReservas(tbId, lista, conAcciones) {
        var tb = document.getElementById(tbId);
        var cols = conAcciones ? 8 : 5;

        if (!lista || lista.length === 0) {
            tb.innerHTML = '<tr><td colspan="' + cols + '"' +
                ' class="text-center text-muted py-3">' +
                'Sin reservas</td></tr>';
            return;
        }

        var badges = {
            'PENDIENTE':  'bg-warning text-dark',
            'PAGADA':     'bg-primary',
            'CONFIRMADA': 'bg-success',
            'CANCELADA':  'bg-danger'
        };

        tb.innerHTML = '';
        lista.forEach(function(r) {
            var bc  = badges[r.estado] || 'bg-secondary';
            var acc = '';

            // Botones de accion solo para la seccion de reservas
            if (conAcciones) {
                acc =
                    '<button class="btn btn-success btn-sm me-1"' +
                    ' onclick="cambiarEstado(' + r.id +
                    ',\'CONFIRMADA\')">' +
                    '<i class="bi bi-check"></i></button>' +
                    '<button class="btn btn-danger btn-sm"' +
                    ' onclick="cambiarEstado(' + r.id +
                    ',\'CANCELADA\')">' +
                    '<i class="bi bi-x"></i></button>';
            }

            tb.innerHTML +=
                '<tr>' +
                '<td>#' + r.id + '</td>' +
                '<td>' + (r.nombreUsuario || '-') + '</td>' +
                '<td>' + (r.nombreServicio || '-') + '</td>' +
                (conAcciones ? '<td>' + (r.fechaViaje || '-') + '</td>' +
                '<td>' + r.personas + '</td>' : '') +
                '<td>$' + Number(r.total).toLocaleString('es-MX') + '</td>' +
                '<td><span class="badge ' + bc + '">' +
                r.estado + '</span></td>' +
                '<td>' + acc + '</td>' +
                '</tr>';
        });
    }

    async function cambiarEstado(id, estado) {
        if (!confirm('Cambiar reserva #' + id + ' a ' + estado + '?'))
            return;
        try {
            var data = await fetch(BASE + '/api/reservas/cancelar', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ reservaId: id, nuevoEstado: estado })
            }).then(function(r) { return r.json(); });

            if (!data.error) {
                alerta('alerta-reservas', 'success',
                    'Estado actualizado.');
                cargarReservas();
            } else {
                alerta('alerta-reservas', 'danger', data.mensaje);
            }
        } catch(e) {
            alerta('alerta-reservas', 'danger', 'Error de conexion.');
        }
    }

    // ── USUARIOS ───────────────────────────────────────────

    async function cargarUsuarios() {
        try {
            var data = await fetch(BASE + '/api/usuarios/sesion')
                .then(function(r) { return r.json(); });
            document.getElementById('tb-usuarios').innerHTML =
                '<tr>' +
                '<td>' + data.usuarioId + '</td>' +
                '<td>' + data.nombre + '</td>' +
                '<td>' + data.email + '</td>' +
                '<td>-</td>' +
                '<td><span class="badge bg-warning text-dark">' +
                data.rol + '</span></td>' +
                '<td>-</td>' +
                '</tr>';
        } catch(e) { console.error(e); }
    }

    // ── UTILIDAD ───────────────────────────────────────────

    /**
     * alerta()
     * Muestra un mensaje Bootstrap de exito o error
     * que desaparece automaticamente en 3 segundos.
     */
    function alerta(id, tipo, msg) {
        var el = document.getElementById(id);
        el.className = 'alert alert-' + tipo + ' py-2 small';
        el.textContent = msg;
        el.classList.remove('d-none');
        setTimeout(function() { el.classList.add('d-none'); }, 3000);
    }
</script>
</body>
</html>