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
        }
        .btn-naranja {
            background-color: var(--naranja);
            border-color: var(--naranja);
            color: #fff;
            font-weight: 600;
        }
        .btn-naranja:hover {
            background-color: var(--naranja-dk);
            color: #fff;
        }
        .seccion { display: none; }
        .seccion.activa { display: block; }
        /* Borde naranja en botones activos del sidebar */
        .list-group-item.activo {
            background-color: #fff3cd;
            border-left: 4px solid var(--naranja);
            font-weight: 600;
            color: var(--naranja-dk);
        }
    </style>
</head>
<body class="bg-light">

<%-- NAVBAR superior simple --%>
<nav class="navbar navbar-expand-lg navbar-dark"
     style="background-color:#1E1E2E;
            border-bottom:3px solid var(--naranja)">
    <div class="container-fluid">
        <span class="navbar-brand fw-bold"
              style="color:var(--naranja)">
            PuertoMagico — Admin
        </span>
        <div class="d-flex align-items-center gap-3">
            <small class="text-white-50" id="admin-nombre">...</small>
            <a href="index.jsp" class="btn btn-outline-light btn-sm">
                <i class="bi bi-house me-1"></i> Ir al inicio
            </a>
            <button class="btn btn-outline-danger btn-sm"
                    onclick="salir()">
                <i class="bi bi-box-arrow-left me-1"></i> Salir
            </button>
        </div>
    </div>
</nav>

<div class="container-fluid py-3">
    <div class="row g-3">

        <%-- SIDEBAR como lista de Bootstrap --%>
        <div class="col-md-2">
            <div class="list-group">
                <button class="list-group-item list-group-item-action
                               activo"
                        id="btn-dashboard"
                        onclick="ir('dashboard', this)">
                    <i class="bi bi-speedometer2 me-2"></i>Dashboard
                </button>
                <button class="list-group-item list-group-item-action"
                        id="btn-tours"
                        onclick="ir('tours', this)">
                    <i class="bi bi-map me-2"></i>Tours
                </button>
                <button class="list-group-item list-group-item-action"
                        id="btn-reservas"
                        onclick="ir('reservas', this)">
                    <i class="bi bi-calendar-check me-2"></i>Reservas
                </button>
                <button class="list-group-item list-group-item-action"
                        id="btn-usuarios"
                        onclick="ir('usuarios', this)">
                    <i class="bi bi-people me-2"></i>Usuarios
                </button>
            </div>
        </div>

        <%-- CONTENIDO PRINCIPAL --%>
        <div class="col-md-10">

            <%-- DASHBOARD --%>
            <div class="seccion activa" id="sec-dashboard">
                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm"
                             style="border-left:4px solid
                                    var(--naranja)!important">
                            <div class="card-body">
                                <div class="text-muted small">
                                    Tours activos
                                </div>
                                <div class="fs-3 fw-bold"
                                     id="s-tours">-</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <div class="text-muted small">
                                    Reservas
                                </div>
                                <div class="fs-3 fw-bold"
                                     id="s-reservas">-</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <div class="text-muted small">
                                    Usuarios
                                </div>
                                <div class="fs-3 fw-bold"
                                     id="s-usuarios">-</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <div class="text-muted small">
                                    Pendientes
                                </div>
                                <div class="fs-3 fw-bold"
                                     id="s-pendientes">-</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white fw-bold">
                        Ultimas reservas
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Cliente</th>
                                        <th>Servicio</th>
                                        <th>Total</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody id="tb-dash">
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

            <%-- TOURS --%>
            <div class="seccion" id="sec-tours">
                <div id="alerta-tours" class="d-none mb-3"></div>
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white d-flex
                                justify-content-between
                                align-items-center">
                        <span class="fw-bold">Gestion de Tours</span>
                        <button class="btn btn-naranja btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#modalTour"
                                onclick="modalNuevo()">
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
                                        <th>Fecha salida</th>
                                        <th>Salidas desde</th>
                                        <th>Precio</th>
                                        <th>Horas</th>
                                        <th>Dificultad</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="tb-tours">
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

            <%-- RESERVAS --%>
            <div class="seccion" id="sec-reservas">
                <div id="alerta-reservas" class="d-none mb-3"></div>
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white d-flex
                                justify-content-between
                                align-items-center">
                        <span class="fw-bold">Gestion de Reservas</span>
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
                                        <th>Fecha</th>
                                        <th>Personas</th>
                                        <th>Total</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="tb-reservas">
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

            <%-- USUARIOS --%>
            <div class="seccion" id="sec-usuarios">
                <div class="card border-0 shadow-sm">
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
                                <tbody id="tb-usuarios">
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

        </div><%-- fin col-md-10 --%>
    </div><%-- fin row --%>
</div><%-- fin container-fluid --%>

<%-- MODAL TOUR --%>
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
                        <label class="form-label small fw-semibold">
                            Nombre
                        </label>
                        <input type="text" class="form-control"
                               id="t-nombre"
                               placeholder="Ej: Tour Monte Alban">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">
                            Destino ID
                        </label>
                        <input type="number" class="form-control"
                               id="t-destino" placeholder="1">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">
                            Vehiculo ID
                        </label>
                        <input type="number" class="form-control"
                               id="t-vehiculo" placeholder="1">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">
                            Precio ($)
                        </label>
                        <input type="number" class="form-control"
                               id="t-precio" step="0.01"
                               placeholder="850">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">
                            Duracion (hrs)
                        </label>
                        <input type="number" class="form-control"
                               id="t-horas" placeholder="8">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">
                            Cupo maximo
                        </label>
                        <input type="number" class="form-control"
                               id="t-cupo" placeholder="15">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">
                            Dificultad
                        </label>
                        <select class="form-select" id="t-dificultad">
                            <option value="FACIL">Facil</option>
                            <option value="MODERADA">Moderada</option>
                            <option value="DIFICIL">Dificil</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label small fw-semibold">
                            Descripcion
                        </label>
                        <textarea class="form-control" id="t-desc"
                                  rows="3"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline-secondary"
                        data-bs-dismiss="modal">
                    Cancelar
                </button>
                <button class="btn btn-naranja"
                        onclick="guardarTour()">
                    <i class="bi bi-save me-1"></i> Guardar
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const BASE = '/PuertoMagico';
    var reservasData = [];
    var modal;

    window.onload = function() {
        modal = new bootstrap.Modal(
            document.getElementById('modalTour'));
        cargarSesion();
        cargarDashboard();
    };

    // ── SESION ─────────────────────────────────────────────

    /**
     * cargarSesion()
     * Solo muestra el nombre del admin.
     * NO redirige automaticamente — deja que el usuario
     * navegue libremente sin interrupciones.
     */
    function cargarSesion() {
        fetch(BASE + '/api/usuarios/sesion')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (!data.error) {
                    document.getElementById('admin-nombre')
                        .textContent = data.nombre;
                }
            })
            .catch(function() {
                // Si falla la sesion solo limpiamos el nombre
                document.getElementById('admin-nombre')
                    .textContent = 'Sin sesion';
            });
    }

    function salir() {
        fetch(BASE + '/api/usuarios/logout')
            .then(function() {
                location.href = 'login.jsp';
            });
    }

    // ── NAVEGACION ─────────────────────────────────────────

    /**
     * ir()
     * Cambia la seccion visible del panel.
     * Usa .then() en lugar de async/await para evitar
     * problemas con llamadas encadenadas.
     */
    function ir(sec, btn) {
        // Ocultar todas las secciones
        document.querySelectorAll('.seccion')
            .forEach(function(s) {
                s.classList.remove('activa');
            });

        // Mostrar la seccion elegida
        var el = document.getElementById('sec-' + sec);
        if (el) el.classList.add('activa');

        // Actualizar boton activo
        document.querySelectorAll('.list-group-item')
            .forEach(function(b) {
                b.classList.remove('activo');
            });
        btn.classList.add('activo');

        // Cargar datos segun la seccion
        if (sec === 'tours')    cargarTours();
        if (sec === 'reservas') cargarReservas();
        if (sec === 'usuarios') cargarUsuarios();
    }

    // ── DASHBOARD ──────────────────────────────────────────

    function cargarDashboard() {
        // Cargamos tours
        fetch(BASE + '/api/tours')
            .then(function(r) { return r.json(); })
            .then(function(tours) {
                document.getElementById('s-tours').textContent =
                    Array.isArray(tours) ? tours.length : 0;
            })
            .catch(function() {
                document.getElementById('s-tours').textContent = 'Error';
            });

        // Cargamos reservas
        fetch(BASE + '/api/reservas/mis-reservas')
            .then(function(r) { return r.json(); })
            .then(function(reservas) {
                if (!Array.isArray(reservas)) return;
                document.getElementById('s-reservas')
                    .textContent = reservas.length;
                document.getElementById('s-pendientes')
                    .textContent = reservas.filter(function(r) {
                        return r.estado === 'PENDIENTE';
                    }).length;
                renderReservas('tb-dash', reservas.slice(0, 5), false);
            })
            .catch(function() {
                document.getElementById('s-reservas')
                    .textContent = 'Error';
            });
            
            
            
           
        fetch(BASE + '/api/usuarios/listar')
             .then(function(r) { return r.json(); })
             .then(function(usuarios) {
              document.getElementById('s-usuarios').textContent =
            Array.isArray(usuarios) ? usuarios.length : 0;
            })
             .catch(function() {
                document.getElementById('s-usuarios')
            .textContent = 'Error';
             });
            
    }
    

    // ── TOURS ──────────────────────────────────────────────

    function cargarTours() {
        var tb = document.getElementById('tb-tours');
        tb.innerHTML = '<tr><td colspan="7"' +
            ' class="text-center py-3 text-muted">' +
            'Cargando...</td></tr>';

        fetch(BASE + '/api/tours')
            .then(function(r) { return r.json(); })
            .then(function(tours) {
                if (!Array.isArray(tours) || tours.length === 0) {
                    tb.innerHTML = '<tr><td colspan="7"' +
                        ' class="text-center py-3 text-muted">' +
                        'Sin tours.</td></tr>';
                    return;
                }
                var html = '';
                tours.forEach(function(t) {
                    var bc = t.dificultad === 'FACIL'
                        ? 'bg-success'
                        : t.dificultad === 'MODERADA'
                        ? 'bg-warning text-dark' : 'bg-danger';
                    var desc = (t.descripcion || '')
                        .replace(/'/g, "\\'");
                    html +=
                        '<tr>' +
                        '<td>' + t.id + '</td>' +
                        '<td class="fw-semibold">' + t.nombre + '</td>' +
                        '<td>' + (t.nombreDestino || '-') + '</td>' +
                        
                        
                        // Fecha de salida formateada
                        '<td>' +
                        (t.fechaSalida
                           ? '<span class="badge bg-info text-dark">' +
                            t.fechaSalida + '</span>'
                          : '<span class="badge bg-secondary">Sin fecha</span>') +
                      '</td>' +

                        // Puntos de salida
                        '<td><small class="text-muted">' +
                        (t.puntosSalida || '-') + '</small></td>' +
                      
                        '<td>$' + Number(t.precioBase)
                            .toLocaleString('es-MX') + '</td>' +
                        '<td>' + t.duracionHoras + ' hrs</td>' +
                        '<td><span class="badge ' + bc + '">' +
                        t.dificultad + '</span></td>' +
                        '<td>' +
                        '<button class="btn btn-outline-primary' +
                        ' btn-sm me-1" onclick="abrirEditar(' +
                        t.id + ',\'' + t.nombre + '\',' +
                        t.destinoId + ',' + t.vehiculoId + ',' +
                        t.precioBase + ',' + t.duracionHoras + ',' +
                        t.cupoMaximo + ',\'' + t.dificultad +
                        '\',\'' + desc + '\')">' +
                        '<i class="bi bi-pencil"></i></button>' +
                        '<button class="btn btn-outline-danger btn-sm"' +
                        ' onclick="borrarTour(' + t.id +
                        ',\'' + t.nombre + '\')">' +
                        '<i class="bi bi-trash"></i></button>' +
                        '</td></tr>';
                });
                tb.innerHTML = html;
            })
            .catch(function() {
                tb.innerHTML = '<tr><td colspan="7"' +
                    ' class="text-center py-3 text-danger">' +
                    'Error al cargar.</td></tr>';
            });
    }

    function modalNuevo() {
        document.getElementById('modal-titulo')
            .textContent = 'Nuevo Tour';
        ['t-id','t-nombre','t-destino','t-vehiculo',
         't-precio','t-horas','t-cupo','t-desc']
            .forEach(function(id) {
                document.getElementById(id).value = '';
            });
    }

    function abrirEditar(id, nombre, dest, veh,
                          precio, horas, cupo, dif, desc) {
        document.getElementById('modal-titulo')
            .textContent = 'Editar Tour';
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

    function guardarTour() {
        var id   = document.getElementById('t-id').value;
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
            alerta('alerta-tours', 'danger',
                'Nombre y precio son obligatorios.');
            return;
        }

        if (id) tour.id = parseInt(id);

        fetch(BASE + '/api/tours', {
            method:  id ? 'PUT' : 'POST',
            headers: { 'Content-Type': 'application/json' },
            body:    JSON.stringify(tour)
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.error) {
                alerta('alerta-tours', 'danger', data.mensaje);
            } else {
                modal.hide();
                alerta('alerta-tours', 'success', data.mensaje);
                cargarTours();
            }
        })
        .catch(function() {
            alerta('alerta-tours', 'danger', 'Error de conexion.');
        });
    }

    function borrarTour(id, nombre) {
        if (!confirm('Desactivar "' + nombre + '"?')) return;
        fetch(BASE + '/api/tours?id=' + id, { method: 'DELETE' })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.error) {
                    alerta('alerta-tours', 'danger', data.mensaje);
                } else {
                    alerta('alerta-tours', 'success', data.mensaje);
                    cargarTours();
                }
            })
            .catch(function() {
                alerta('alerta-tours', 'danger', 'Error de conexion.');
            });
    }

    // ── RESERVAS ───────────────────────────────────────────

    function cargarReservas() {
        var tb = document.getElementById('tb-reservas');
        tb.innerHTML = '<tr><td colspan="8"' +
            ' class="text-center py-3 text-muted">' +
            'Cargando...</td></tr>';

        fetch(BASE + '/api/reservas/mis-reservas')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                reservasData = Array.isArray(data) ? data : [];
                renderReservas('tb-reservas', reservasData, true);
            })
            .catch(function() {
                tb.innerHTML = '<tr><td colspan="8"' +
                    ' class="text-center py-3 text-danger">' +
                    'Error al cargar.</td></tr>';
            });
    }

    function filtrarReservas() {
        var estado   = document.getElementById('filtro-estado').value;
        var filtradas = estado
            ? reservasData.filter(function(r) {
                return r.estado === estado; })
            : reservasData;
        renderReservas('tb-reservas', filtradas, true);
    }

    function renderReservas(tbId, lista, conAcciones) {
        var tb   = document.getElementById(tbId);
        var cols = conAcciones ? 8 : 5;

        if (!lista || lista.length === 0) {
            tb.innerHTML = '<tr><td colspan="' + cols + '"' +
                ' class="text-center py-3 text-muted">' +
                'Sin reservas.</td></tr>';
            return;
        }

        var badges = {
            'PENDIENTE':  'bg-warning text-dark',
            'PAGADA':     'bg-primary',
            'CONFIRMADA': 'bg-success',
            'CANCELADA':  'bg-danger'
        };

        var html = '';
        lista.forEach(function(r) {
            var bc  = badges[r.estado] || 'bg-secondary';
            var acc = '';
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
            html +=
                '<tr>' +
                '<td>#' + r.id + '</td>' +
                '<td>' + (r.nombreUsuario || '-') + '</td>' +
                '<td>' + (r.nombreServicio || '-') + '</td>' +
                (conAcciones
                    ? '<td>' + (r.fechaViaje || '-') + '</td>' +
                      '<td>' + r.personas + '</td>'
                    : '') +
                '<td>$' + Number(r.total)
                    .toLocaleString('es-MX') + '</td>' +
                '<td><span class="badge ' + bc + '">' +
                r.estado + '</span></td>' +
                '<td>' + acc + '</td>' +
                '</tr>';
        });
        tb.innerHTML = html;
    }

    function cambiarEstado(id, estado) {
        if (!confirm('Cambiar #' + id + ' a ' + estado + '?')) return;
        fetch(BASE + '/api/reservas/cancelar', {
            method:  'POST',
            headers: { 'Content-Type': 'application/json' },
            body:    JSON.stringify({
                reservaId: id, nuevoEstado: estado })
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (!data.error) {
                alerta('alerta-reservas', 'success', 'Actualizado.');
                cargarReservas();
            } else {
                alerta('alerta-reservas', 'danger', data.mensaje);
            }
        })
        .catch(function() {
            alerta('alerta-reservas', 'danger', 'Error de conexion.');
        });
    }

    // ── USUARIOS ───────────────────────────────────────────

     function cargarUsuarios() {
       var tb = document.getElementById('tb-usuarios');
       tb.innerHTML = '<tr><td colspan="6"' +
        ' class="text-center py-3 text-muted">' +
        'Cargando...</td></tr>';

    // Ahora llama al endpoint que lista TODOS los usuarios
       fetch(BASE + '/api/usuarios/listar')
        .then(function(r) { return r.json(); })
        .then(function(usuarios) {

            if (!Array.isArray(usuarios) ||
                usuarios.length === 0) {
                tb.innerHTML = '<tr><td colspan="6"' +
                    ' class="text-center py-3 text-muted">' +
                    'Sin usuarios.</td></tr>';
                return;
            }

            var html = '';
            usuarios.forEach(function(u) {
                var badge = u.rol === 'ADMIN'
                    ? 'bg-danger'
                    : 'bg-primary';

                // Formatear la fecha de registro
                var fecha = u.createdAt
                    ? u.createdAt.substring(0, 10)
                    : '-';

                html +=
                    '<tr>' +
                    '<td>' + u.id + '</td>' +
                    '<td>' + u.nombre + ' ' + u.apellido + '</td>' +
                    '<td>' + u.email + '</td>' +
                    '<td>' + (u.telefono || '-') + '</td>' +
                    '<td><span class="badge ' + badge + '">' +
                    u.rol + '</span></td>' +
                    '<td>' + fecha + '</td>' +
                    '</tr>';
            });

            tb.innerHTML = html;
        })
        .catch(function() {
            tb.innerHTML = '<tr><td colspan="6"' +
                ' class="text-center py-3 text-danger">' +
                'Error al cargar usuarios.</td></tr>';
        });
}

    // ── UTILIDAD ───────────────────────────────────────────

    function alerta(id, tipo, msg) {
        var el = document.getElementById(id);
        if (!el) return;
        el.className   = 'alert alert-' + tipo + ' py-2 small';
        el.textContent = msg;
        el.classList.remove('d-none');
        setTimeout(function() {
            el.classList.add('d-none');
        }, 3000);
    }
</script>
</body>
</html>