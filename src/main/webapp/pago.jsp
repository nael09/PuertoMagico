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
    </style>
</head>
<body class="bg-light">

    <!-- NAVBAR -->
    <nav class="navbar navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                Puerto<span style="color:var(--naranja)">Magico</span>
            </a>
            <span class="text-muted small">
                <i class="bi bi-shield-check me-1 text-success"></i>
                Pago seguro
            </span>
        </div>
    </nav>

    <div class="container py-4" style="max-width:700px">

        <!-- Pasos del proceso -->
        <!--
            Bootstrap stepper visual usando badges y lineas.
            Muestra en que paso del proceso esta el usuario.
        -->
        <div class="d-flex align-items-center mb-4">
            <span class="badge bg-success rounded-pill px-3 py-2">
                1. Tour seleccionado
            </span>
            <div class="flex-grow-1 border-top mx-2"></div>
            <span class="badge rounded-pill px-3 py-2"
                  style="background:var(--naranja)">
                2. Pago
            </span>
            <div class="flex-grow-1 border-top mx-2"></div>
            <span class="badge bg-secondary rounded-pill px-3 py-2">
                3. Confirmacion
            </span>
        </div>

        <div class="row g-4">

            <!-- FORMULARIO DE PAGO -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-4">
                            <i class="bi bi-credit-card me-2"></i>
                            Datos de pago
                        </h5>

                        <!-- Alerta de error -->
                        <div class="alert alert-danger d-none py-2 small"
                             id="error-pago"></div>

                        <!-- Metodo de pago -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">
                                Metodo de pago
                            </label>
                            <select class="form-select" id="metodo">
                                <option value="TARJETA">
                                    Tarjeta de credito/debito
                                </option>
                                <option value="TRANSFERENCIA">
                                    Transferencia bancaria
                                </option>
                                <option value="EFECTIVO">
                                    Efectivo
                                </option>
                            </select>
                        </div>

                        <!-- Datos de tarjeta -->
                        <div id="datos-tarjeta">
                            <div class="mb-3">
                                <label class="form-label
                                              fw-semibold small">
                                    Numero de tarjeta
                                </label>
                                <input type="text"
                                       class="form-control"
                                       id="num-tarjeta"
                                       placeholder="1234 5678 9012 3456"
                                       maxlength="19">
                            </div>
                            <div class="row g-3 mb-3">
                                <div class="col-6">
                                    <label class="form-label
                                                  fw-semibold small">
                                        Vencimiento
                                    </label>
                                    <input type="text"
                                           class="form-control"
                                           id="vencimiento"
                                           placeholder="MM/AA"
                                           maxlength="5">
                                </div>
                                <div class="col-6">
                                    <label class="form-label
                                                  fw-semibold small">
                                        CVV
                                    </label>
                                    <input type="text"
                                           class="form-control"
                                           id="cvv"
                                           placeholder="123"
                                           maxlength="3">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label
                                              fw-semibold small">
                                    Meses sin intereses
                                </label>
                                <select class="form-select" id="meses">
                                    <option value="0">Contado</option>
                                    <option value="3">3 meses</option>
                                    <option value="6">6 meses</option>
                                    <option value="12">12 meses</option>
                                </select>
                            </div>
                        </div>

                        <button class="btn btn-naranja w-100 py-2"
                                id="btn-pagar"
                                onclick="procesarPago()">
                            <i class="bi bi-lock-fill me-1"></i>
                            Pagar ahora
                        </button>

                        <p class="text-muted text-center small mt-3 mb-0">
                            <i class="bi bi-shield-lock me-1"></i>
                            Tus datos estan protegidos con SSL
                        </p>
                    </div>
                </div>
            </div>

            <!-- RESUMEN DE COMPRA -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <h6 class="fw-bold mb-3">Resumen</h6>

                        <div class="text-muted small mb-3"
                             id="resumen-servicio">
                            Cargando...
                        </div>

                        <div class="border-top pt-3">
                            <div class="d-flex
                                        justify-content-between
                                        fw-bold">
                                <span>Total a pagar</span>
                                <span style="color:var(--naranja-dark)"
                                      id="resumen-total">
                                    $---
                                </span>
                            </div>
                        </div>

                        <div class="mt-3">
                            <small class="text-muted">
                                <i class="bi bi-check-circle
                                          text-success me-1"></i>
                                Cancelacion gratuita 24 hrs antes
                            </small>
                        </div>
                        <div class="mt-1">
                            <small class="text-muted">
                                <i class="bi bi-check-circle
                                          text-success me-1"></i>
                                Voucher enviado por email
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const BASE = '/PuertoMagico';

        // Leemos los parametros de la URL
        // reservaId: ID de la reserva creada en detalle-tour.jsp
        // total: monto calculado en detalle-tour.jsp
        const params    = new URLSearchParams(
            window.location.search);
        const reservaId = params.get('reservaId');
        const total     = parseFloat(params.get('total') || '0');

        window.onload = function() {
            verificarSesion();
            cargarResumen();

            // Mostrar/ocultar datos de tarjeta segun metodo
            document.getElementById('metodo')
                .addEventListener('change', function() {
                    var dt = document.getElementById('datos-tarjeta');
                    dt.style.display =
                        this.value === 'TARJETA' ? 'block' : 'none';
                });
        };

        function verificarSesion() {
            fetch(BASE + '/api/usuarios/sesion')
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.error) {
                        alert('Debes iniciar sesion.');
                        location.href = 'login.jsp';
                    }
                });
        }

        /**
         * cargarResumen()
         * Muestra el resumen de la reserva en la columna derecha.
         * Usa el reservaId y total que vienen en la URL.
         */
        function cargarResumen() {
            if (!reservaId) {
                alert('Reserva no encontrada.');
                location.href = 'index.jsp';
                return;
            }

            fetch(BASE + '/api/reservas?id=' + reservaId)
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    var reserva = data.reserva || data;
                    document.getElementById('resumen-servicio')
                        .innerHTML =
                        '<div class="fw-semibold mb-1">' +
                        (reserva.nombreServicio || 'Tour') +
                        '</div>' +
                        '<div>Fecha: ' +
                        (reserva.fechaViaje || '-') + '</div>' +
                        '<div>Personas: ' +
                        (reserva.personas || '-') + '</div>';
                })
                .catch(function() {
                    document.getElementById('resumen-servicio')
                        .textContent = 'Reserva #' + reservaId;
                });

            document.getElementById('resumen-total').textContent =
                '$' + total.toLocaleString('es-MX');
        }

        /**
         * procesarPago()
         * Envia los datos al PagoServlet para simular el cobro.
         * En produccion real se conectaria con Stripe o MercadoPago.
         * El pago SIEMPRE se aprueba en esta version de prueba.
         */
        function procesarPago() {
            var metodo = document.getElementById('metodo').value;
            var meses  = parseInt(
                document.getElementById('meses')
                ? document.getElementById('meses').value : 0);

            // Validacion basica para tarjeta
            if (metodo === 'TARJETA') {
                var num = document.getElementById('num-tarjeta').value;
                var venc = document.getElementById('vencimiento').value;
                var cvv  = document.getElementById('cvv').value;

                if (!num || !venc || !cvv) {
                    var err = document.getElementById('error-pago');
                    err.textContent = 'Completa los datos de la tarjeta.';
                    err.classList.remove('d-none');
                    return;
                }
            }

            // Deshabilitar boton para evitar doble pago
            var btn = document.getElementById('btn-pagar');
            btn.disabled    = true;
            btn.textContent = 'Procesando...';

            fetch(BASE + '/api/pagos/procesar', {
                method:  'POST',
                headers: { 'Content-Type': 'application/json' },
                body:    JSON.stringify({
                    reservaId: parseInt(reservaId),
                    monto:     total,
                    metodo:    metodo,
                    meses:     meses
                })
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.error) {
                    var err = document.getElementById('error-pago');
                    err.textContent = data.mensaje;
                    err.classList.remove('d-none');
                    btn.disabled    = false;
                    btn.textContent = 'Pagar ahora';
                } else {
                    // Pago exitoso — redirigir a confirmacion
                    window.location.href =
                        'confirmacion.jsp?reservaId=' + reservaId +
                        '&codigo=' + (data.codigoQr || '') +
                        '&referencia=' + (data.referencia || '');
                }
            })
            .catch(function() {
                var err = document.getElementById('error-pago');
                err.textContent = 'Error de conexion. Intenta de nuevo.';
                err.classList.remove('d-none');
                btn.disabled    = false;
                btn.textContent = 'Pagar ahora';
            });
        }
    </script>
</body>
</html>