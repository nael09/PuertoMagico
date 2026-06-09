<%@ page contentType="text/html;charset=UTF-8"
         language="java"
         isELIgnored="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pago - Puerto Magico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --naranja: #F5A623;
            --naranja-dark: #D48A10;
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
        .pago-card {
            max-width: 520px;
            margin: 0 auto;
        }
        .resumen-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 16px;
        }
    </style>
</head>
<body class="bg-light">

    <%-- NAVBAR --%>
    <nav class="navbar navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                Puerto<span style="color:var(--naranja)">Magico</span>
            </a>
            <div class="d-flex align-items-center gap-2">
                <span class="text-muted small" id="nav-nombre"></span>
                <button class="btn btn-outline-danger btn-sm"
                        onclick="cerrarSesion()">
                    Salir
                </button>
            </div>
        </div>
    </nav>

    <%-- MIGA DE PAN --%>
    <div class="bg-white border-bottom py-2">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 small">
                    <li class="breadcrumb-item">
                        <a href="index.jsp"
                           class="text-decoration-none">Inicio</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="tours.jsp"
                           class="text-decoration-none">Tours</a>
                    </li>
                    <li class="breadcrumb-item active">Pago</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container py-4">
        <div class="pago-card">

            <%-- TITULO --%>
            <h4 class="fw-bold mb-4">
                <i class="bi bi-lock-fill me-2"
                   style="color:var(--naranja)"></i>
                Completar pago
            </h4>

            <%-- RESUMEN DE COMPRA --%>
            <div class="resumen-box mb-4">
                <h6 class="fw-bold mb-3">Resumen de tu reserva</h6>
                <div class="d-flex justify-content-between small mb-1">
                    <span class="text-muted">Servicio</span>
                    <span id="res-servicio" class="fw-semibold">-</span>
                </div>
                <div class="d-flex justify-content-between small mb-1">
                    <span class="text-muted">Fecha</span>
                    <span id="res-fecha">-</span>
                </div>
                <div class="d-flex justify-content-between small mb-1">
                    <span class="text-muted">Personas</span>
                    <span id="res-personas">-</span>
                </div>
                <div class="d-flex justify-content-between
                            fw-bold border-top pt-2 mt-2">
                    <span>Total a pagar</span>
                    <span id="res-total"
                          style="color:var(--naranja-dark)">-</span>
                </div>
            </div>

            <%-- TARJETA DE PAGO --%>
            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">

                    <%-- Metodo de pago — se llena con JS segun rol --%>
                    <div class="mb-3" id="seccion-metodo">
                        <div class="text-center py-3">
                            <div class="spinner-border spinner-border-sm
                                        text-secondary me-2"></div>
                            Cargando opciones de pago...
                        </div>
                    </div>

                    <%--
                        Datos de tarjeta — solo visible para CLIENTES.
                        El ADMIN no necesita tarjeta.
                    --%>
                    <div id="datos-tarjeta" style="display:none">

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">
                                Numero de tarjeta
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-credit-card"></i>
                                </span>
                                <input type="text"
                                       class="form-control"
                                       id="num-tarjeta"
                                       placeholder="1234 5678 9012 3456"
                                       maxlength="19"
                                       oninput="formatearTarjeta()"
                                       inputmode="numeric">
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-7">
                                <label class="form-label
                                              fw-semibold small">
                                    Vencimiento
                                </label>
                                <input type="text"
                                       class="form-control"
                                       id="vencimiento"
                                       placeholder="MM/YY"
                                       maxlength="5"
                                       oninput="formatearVencimiento()"
                                       inputmode="numeric">
                            </div>
                            <div class="col-5">
                                <label class="form-label
                                              fw-semibold small">
                                    CVV
                                </label>
                                <div class="input-group">
                                    <input type="password"
                                           class="form-control"
                                           id="cvv"
                                           placeholder="123"
                                           maxlength="3"
                                           inputmode="numeric">
                                    <span class="input-group-text">
                                        <i class="bi bi-question-circle"
                                           title="3 digitos al reverso">
                                        </i>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">
                                Meses sin intereses
                            </label>
                            <select class="form-select" id="meses">
                                <option value="0">Contado</option>
                                <option value="3">3 meses sin intereses</option>
                                <option value="6">6 meses sin intereses</option>
                                <option value="9">9 meses sin intereses</option>
                                <option value="12">12 meses sin intereses</option>
                            </select>
                        </div>
                    </div>

                    <%-- Mensaje de error --%>
                    <div id="error-pago"
                         class="alert alert-danger py-2 small d-none">
                    </div>

                    <%-- Boton pagar — solo para clientes --%>
                    <button class="btn btn-naranja w-100 py-2 mt-2"
                            id="btn-pagar"
                            onclick="procesarPago()"
                            style="display:none">
                        <i class="bi bi-lock-fill me-1"></i>
                        Pagar ahora
                    </button>

                    <p class="text-muted text-center small mt-3 mb-0">
                        <i class="bi bi-shield-check me-1"></i>
                        Tus datos estan protegidos con cifrado SSL
                    </p>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-4">
        <small>
            &copy; 2026
            Puerto<span style="color:var(--naranja)">Magico</span>
            &middot; Universidad Veracruzana
        </small>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const BASE = '/PuertoMagico';

        // Leer parametros de la URL
        const params     = new URLSearchParams(window.location.search);
        const tourId     = params.get('tourId');
        const paqueteId  = params.get('paqueteId');
        const fecha      = params.get('fecha');
        const personas   = parseInt(params.get('personas') || '1');
        const asientoIds = params.get('asientoIds') || '';
        var   total      = parseFloat(params.get('total') || '0');
        var   rolUsuario = '';

        window.onload = function() {
            mostrarResumen();
            verificarSesionYMostrarPago();
        };

        // ── SESION ──────────────────────────────────────────

        function verificarSesionYMostrarPago() {
            fetch(BASE + '/api/usuarios/sesion')
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.error) {
                        alert('Debes iniciar sesion para pagar.');
                        window.location.href = 'login.jsp';
                        return;
                    }

                    document.getElementById('nav-nombre')
                        .textContent = data.nombre;
                    rolUsuario = data.rol || 'CLIENTE';

                    if (rolUsuario === 'ADMIN') {
                        mostrarOpcionesAdmin();
                    } else {
                        mostrarOpcionesCliente();
                    }
                })
                .catch(function() {
                    window.location.href = 'login.jsp';
                });
        }

        function cerrarSesion() {
            fetch(BASE + '/api/usuarios/logout')
                .then(function() {
                    window.location.href = 'login.jsp';
                });
        }

        // ── RESUMEN ─────────────────────────────────────────

        /**
         * mostrarResumen()
         * Llena el resumen de la compra con los datos de la URL.
         */
        function mostrarResumen() {
            // Nombre del servicio
            if (tourId) {
                fetch(BASE + '/api/tours?id=' + tourId)
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        var tour = data.tour || data;
                        document.getElementById('res-servicio')
                            .textContent = tour.nombre || '-';
                    })
                    .catch(function() {});
            } else if (paqueteId) {
                fetch(BASE + '/api/paquetes?id=' + paqueteId)
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        document.getElementById('res-servicio')
                            .textContent = data.nombre || '-';
                    })
                    .catch(function() {});
            }

            // Fecha formateada
            if (fecha) {
                var partes = fecha.split('-');
                var fechaBonita = partes[2] + '/' +
                                  partes[1] + '/' + partes[0];
                document.getElementById('res-fecha')
                    .textContent = fechaBonita;
            }

            document.getElementById('res-personas')
                .textContent = personas + ' persona' +
                (personas > 1 ? 's' : '');

            document.getElementById('res-total')
                .textContent = '$' + total.toLocaleString('es-MX');
        }

        // ── OPCIONES POR ROL ────────────────────────────────

        /**
         * mostrarOpcionesAdmin()
         * El admin registra pagos en efectivo o transferencia.
         * No necesita ingresar datos de tarjeta.
         */
        function mostrarOpcionesAdmin() {
            document.getElementById('seccion-metodo').innerHTML =
                '<label class="form-label fw-semibold small">' +
                'Metodo de pago recibido</label>' +
                '<div class="d-grid gap-2">' +

                '<button class="btn btn-outline-success py-2"' +
                ' onclick="confirmarMetodo(\'EFECTIVO\')">' +
                '<i class="bi bi-cash-coin me-2"></i>' +
                'Registrar pago en <strong>Efectivo</strong>' +
                '</button>' +

                '<button class="btn btn-outline-primary py-2"' +
                ' onclick="confirmarMetodo(\'TRANSFERENCIA\')">' +
                '<i class="bi bi-bank me-2"></i>' +
                'Registrar <strong>Transferencia</strong>' +
                '</button>' +

                '</div>' +
                '<div class="form-text mt-2">' +
                '<i class="bi bi-info-circle me-1"></i>' +
                'Registra el pago recibido fuera de la plataforma.' +
                '</div>';

            // Ocultar boton de tarjeta
            document.getElementById('btn-pagar')
                .style.display = 'none';
            document.getElementById('datos-tarjeta')
                .style.display = 'none';
        }

        /**
         * mostrarOpcionesCliente()
         * El cliente solo puede pagar con tarjeta de credito/debito.
         */
        function mostrarOpcionesCliente() {
            document.getElementById('seccion-metodo').innerHTML =
                '<div class="alert alert-light border py-2 mb-0">' +
                '<i class="bi bi-credit-card me-1 text-primary"></i>' +
                '<strong>Pago con tarjeta</strong>' +
                ' — seguro y rapido' +
                '</div>';

            document.getElementById('datos-tarjeta')
                .style.display = 'block';
            document.getElementById('btn-pagar')
                .style.display = 'block';
        }

        // ── ADMIN: PAGO MANUAL ──────────────────────────────

        /**
         * confirmarMetodo()
         * Solo para ADMIN.
         * Crea la reserva y registra el pago en un solo paso.
         */
        async function confirmarMetodo(metodo) {
            if (!confirm('Confirmar pago por ' +
                metodo + ' de $' +
                total.toLocaleString('es-MX') + '?')) return;

            var btn = document.querySelector(
                'button[onclick="confirmarMetodo(\'' +
                metodo + '\')"]');
            if (btn) {
                btn.disabled  = true;
                btn.innerHTML =
                    '<span class="spinner-border' +
                    ' spinner-border-sm me-2"></span>' +
                    'Registrando...';
            }

            try {
                // Crear reserva
                var bodyReserva = {
                    tipoServicio: tourId ? 'TOUR' : 'PAQUETE',
                    fechaViaje:   fecha,
                    personas:     personas,
                    total:        total,
                    asientoIds:   asientoIds
                        ? asientoIds.split(',').map(Number)
                        : []
                };
                if (tourId)    bodyReserva.tourId    = parseInt(tourId);
                if (paqueteId) bodyReserva.paqueteId = parseInt(paqueteId);

                var resR = await fetch(
                    BASE + '/api/reservas/crear', {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body:    JSON.stringify(bodyReserva)
                });
                var dataR = await resR.json();

                if (dataR.error) {
                    mostrarErrorPago(dataR.mensaje);
                    if (btn) { btn.disabled = false; }
                    return;
                }

                // Registrar pago
                var resP = await fetch(
                    BASE + '/api/pagos/procesar', {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body:    JSON.stringify({
                        reservaId: dataR.reservaId,
                        monto:     total,
                        metodo:    metodo,
                        meses:     0
                    })
                });
                var dataP = await resP.json();

                if (dataP.error) {
                    mostrarErrorPago(dataP.mensaje);
                    if (btn) { btn.disabled = false; }
                } else {
                    window.location.href =
                        'confirmacion.jsp' +
                        '?reservaId=' + dataR.reservaId +
                        '&referencia=' + (dataP.referencia || '');
                }

            } catch (e) {
                mostrarErrorPago('Error de conexion.');
                if (btn) { btn.disabled = false; }
            }
        }

        // ── CLIENTE: PAGO CON TARJETA ───────────────────────

        /**
         * procesarPago()
         * Solo para CLIENTES.
         * Valida la tarjeta, crea la reserva y procesa el pago.
         */
        async function procesarPago() {
            document.getElementById('error-pago')
                .classList.add('d-none');

            if (!validarTarjeta()) return;

            var btn       = document.getElementById('btn-pagar');
            btn.disabled  = true;
            btn.innerHTML =
                '<span class="spinner-border' +
                ' spinner-border-sm me-2"></span>' +
                'Procesando...';

            try {
                // Crear reserva
                var bodyReserva = {
                    tipoServicio: tourId ? 'TOUR' : 'PAQUETE',
                    fechaViaje:   fecha,
                    personas:     personas,
                    total:        total,
                    asientoIds:   asientoIds
                        ? asientoIds.split(',').map(Number)
                        : []
                };
                if (tourId)    bodyReserva.tourId    = parseInt(tourId);
                if (paqueteId) bodyReserva.paqueteId = parseInt(paqueteId);

                var resR = await fetch(
                    BASE + '/api/reservas/crear', {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body:    JSON.stringify(bodyReserva)
                });
                var dataR = await resR.json();

                if (dataR.error) {
                    mostrarErrorPago(dataR.mensaje);
                    btn.disabled  = false;
                    btn.innerHTML =
                        '<i class="bi bi-lock-fill me-1"></i>' +
                        'Pagar ahora';
                    return;
                }

                // Procesar pago con tarjeta
                var resP = await fetch(
                    BASE + '/api/pagos/procesar', {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body:    JSON.stringify({
                        reservaId: dataR.reservaId,
                        monto:     total,
                        metodo:    'TARJETA',
                        meses:     parseInt(
                            document.getElementById('meses').value)
                    })
                });
                var dataP = await resP.json();

                if (dataP.error) {
                    mostrarErrorPago(dataP.mensaje);
                    btn.disabled  = false;
                    btn.innerHTML =
                        '<i class="bi bi-lock-fill me-1"></i>' +
                        'Pagar ahora';
                } else {
                    window.location.href =
                        'confirmacion.jsp' +
                        '?reservaId=' + dataR.reservaId +
                        '&referencia=' + (dataP.referencia || '');
                }

            } catch (e) {
                mostrarErrorPago('Error de conexion. Intenta de nuevo.');
                btn.disabled  = false;
                btn.innerHTML =
                    '<i class="bi bi-lock-fill me-1"></i>' +
                    'Pagar ahora';
            }
        }

        // ── VALIDACIONES ────────────────────────────────────

        /**
         * validarTarjeta()
         * Valida numero (16 digitos), vencimiento (MM/YY,
         * no vencida) y CVV (3 digitos).
         */
        function validarTarjeta() {
            var num  = document.getElementById('num-tarjeta').value
                .replace(/\s/g, '');
            var venc = document.getElementById('vencimiento').value;
            var cvv  = document.getElementById('cvv').value;

            if (!num || !venc || !cvv) {
                mostrarErrorPago(
                    'Completa todos los datos de la tarjeta.');
                return false;
            }

            // 16 digitos exactos
            if (!/^\d{16}$/.test(num)) {
                mostrarErrorPago(
                    'El numero de tarjeta debe tener 16 digitos.');
                return false;
            }

            // Formato MM/YY
            if (!/^\d{2}\/\d{2}$/.test(venc)) {
                mostrarErrorPago(
                    'El vencimiento debe tener formato MM/YY ' +
                    '(ejemplo: 08/27).');
                return false;
            }

            // Mes valido
            var partes = venc.split('/');
            var mes    = parseInt(partes[0]);
            var anio   = parseInt('20' + partes[1]);

            if (mes < 1 || mes > 12) {
                mostrarErrorPago(
                    'El mes debe estar entre 01 y 12.');
                return false;
            }

            // No vencida
            var hoy    = new Date();
            var limite = new Date(anio, mes, 1);
            if (limite <= hoy) {
                mostrarErrorPago('La tarjeta esta vencida.');
                return false;
            }

            // CVV 3 digitos
            if (!/^\d{3}$/.test(cvv)) {
                mostrarErrorPago(
                    'El CVV debe tener exactamente 3 digitos.');
                return false;
            }

            // Total valido
            if (!total || total <= 0) {
                mostrarErrorPago('El monto a pagar no es valido.');
                return false;
            }

            return true;
        }

        // ── FORMATO ─────────────────────────────────────────

        /**
         * formatearTarjeta()
         * Espacios cada 4 digitos: 1234 5678 9012 3456
         */
        function formatearTarjeta() {
            var input = document.getElementById('num-tarjeta');
            var valor = input.value.replace(/\D/g, '')
                .substring(0, 16);
            var grupos = valor.match(/.{1,4}/g);
            input.value = grupos ? grupos.join(' ') : '';
        }

        /**
         * formatearVencimiento()
         * Agrega slash automatico: 08/27
         */
        function formatearVencimiento() {
            var input = document.getElementById('vencimiento');
            var valor = input.value.replace(/\D/g, '')
                .substring(0, 4);
            if (valor.length >= 3) {
                input.value = valor.substring(0, 2) + '/' +
                              valor.substring(2);
            } else {
                input.value = valor;
            }
        }

        // ── UTILIDAD ─────────────────────────────────────────

        function mostrarErrorPago(mensaje) {
            var err = document.getElementById('error-pago');
            err.textContent = mensaje;
            err.classList.remove('d-none');
            setTimeout(function() {
                err.classList.add('d-none');
            }, 5000);
        }
    </script>
</body>
</html>