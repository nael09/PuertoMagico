<%@ page contentType="text/html;charset=UTF-8"
         language="java"
         isELIgnored="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirmacion de Reserva - Puerto Magico</title>
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
            color: #fff; font-weight: 600;
        }
        .btn-naranja:hover {
            background-color: var(--naranja-dark); color: #fff;
        }

        /* ── VOUCHER ──────────────────────────────── */
        .voucher {
            max-width: 600px;
            margin: 0 auto;
            border: 2px solid #dee2e6;
            border-radius: 16px;
            overflow: hidden;
        }
        .voucher-header {
            background: linear-gradient(135deg,
                #1E1E2E 0%, #2E86AB 100%);
            color: #fff;
            padding: 24px;
        }
        .voucher-body { padding: 24px; background: #fff; }
        .voucher-footer {
            background: #f8f9fa;
            padding: 16px 24px;
            border-top: 1px dashed #dee2e6;
        }

        /* QR simulado */
        .qr-box {
            width: 120px;
            height: 120px;
            background: repeating-linear-gradient(
                0deg,
                #000 0px, #000 4px,
                #fff 4px, #fff 8px
            ),
            repeating-linear-gradient(
                90deg,
                #000 0px, #000 4px,
                #fff 4px, #fff 8px
            );
            background-blend-mode: difference;
            border: 4px solid #000;
            border-radius: 8px;
            margin: 0 auto;
        }

        /* Separador de salidas */
        .salida-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 12px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 6px;
        }
        .salida-hora {
            background: var(--naranja);
            color: #fff;
            font-weight: 700;
            font-size: 12px;
            padding: 2px 8px;
            border-radius: 12px;
            white-space: nowrap;
        }

        /* ── CSS DE IMPRESION / PDF ───────────────── */
        @media print {
            /* Ocultar elementos que no van en el PDF */
            .no-print { display: none !important; }
            .navbar   { display: none !important; }
            footer    { display: none !important; }
            body      { background: #fff !important; }

            /* El voucher ocupa toda la pagina */
            .voucher {
                max-width: 100%;
                border: 2px solid #000;
                box-shadow: none !important;
            }

            /* Forzar colores en impresion */
            .voucher-header {
                background: #1E1E2E !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
            .salida-hora {
                background: var(--naranja) !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
        }
    </style>
</head>
<body class="bg-light">

    <%-- NAVBAR — oculto al imprimir --%>
    <nav class="navbar navbar-light bg-white shadow-sm no-print">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                Puerto<span style="color:var(--naranja)">Magico</span>
            </a>
            <a href="index.jsp" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-house me-1"></i> Inicio
            </a>
        </div>
    </nav>

    <div class="container py-4">

        <%-- Botones de accion — ocultos al imprimir --%>
        <div class="text-center mb-4 no-print">
            <div class="alert alert-success d-inline-flex
                        align-items-center gap-2 px-4">
                <i class="bi bi-check-circle-fill fs-5"></i>
                <strong>Pago procesado correctamente</strong>
            </div>
            <div class="mt-3 d-flex gap-2 justify-content-center">
                <button class="btn btn-naranja"
                        onclick="descargarPDF()">
                    <i class="bi bi-file-earmark-pdf me-1"></i>
                    Descargar voucher PDF
                </button>
                <a href="index.jsp"
                   class="btn btn-outline-secondary">
                    <i class="bi bi-house me-1"></i>
                    Volver al inicio
                </a>
            </div>
        </div>

        <%-- VOUCHER --%>
        <div class="voucher shadow-sm" id="voucher">

            <%-- Encabezado --%>
            <div class="voucher-header">
                <div class="d-flex justify-content-between
                            align-items-start">
                    <div>
                        <h4 class="fw-bold mb-1">
                            Puerto<span style="color:var(--naranja)">
                            Magico</span>
                        </h4>
                        <p class="mb-0 opacity-75 small">
                            Agencia de Viajes Turísticos
                        </p>
                        <p class="mb-0 opacity-75 small">
                            Reg. Turismo: 04301930110
                        </p>
                    </div>
                    <div class="text-end">
                        <div class="badge bg-success fs-6 mb-1">
                            CONFIRMADO
                        </div>
                        <div class="small opacity-75">
                            Referencia:
                            <strong id="v-referencia">-</strong>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Cuerpo --%>
            <div class="voucher-body">
                <div class="row g-4">

                    <%-- Columna izquierda: datos del tour --%>
                    <div class="col-8">
                        <h5 class="fw-bold mb-3"
                            id="v-tour-nombre">
                            Cargando...
                        </h5>

                        <%-- Datos del viaje --%>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <div class="small text-muted">
                                    Fecha de salida
                                </div>
                                <div class="fw-semibold"
                                     id="v-fecha">-</div>
                            </div>
                            <div class="col-6">
                                <div class="small text-muted">
                                    Personas
                                </div>
                                <div class="fw-semibold"
                                     id="v-personas">-</div>
                            </div>
                            <div class="col-6">
                                <div class="small text-muted">
                                    Asientos
                                </div>
                                <div class="fw-semibold"
                                     id="v-asientos">-</div>
                            </div>
                            <div class="col-6">
                                <div class="small text-muted">
                                    Destino
                                </div>
                                <div class="fw-semibold"
                                     id="v-destino">-</div>
                            </div>
                        </div>

                        <%-- Horarios de salida por ciudad --%>
                        <div class="mb-3">
                            <div class="small text-muted fw-semibold
                                        mb-2">
                                <i class="bi bi-geo-alt-fill
                                          text-danger me-1"></i>
                                Horarios de salida
                            </div>
                            <div id="v-salidas">
                                <div class="text-muted small">
                                    Cargando horarios...
                                </div>
                            </div>
                        </div>

                        <%-- Datos del viajero --%>
                        <div class="small text-muted fw-semibold mb-2">
                            <i class="bi bi-person-fill me-1"></i>
                            Datos del viajero
                        </div>
                        <div class="small">
                            <div id="v-viajero-nombre">-</div>
                            <div id="v-viajero-email"
                                 class="text-muted">-</div>
                            <div id="v-viajero-tel"
                                 class="text-muted">-</div>
                        </div>
                    </div>

                    <%-- Columna derecha: QR y pago --%>
                    <div class="col-4 text-center">
                        <div class="qr-box mb-2"></div>
                        <div class="small text-muted">
                            Muestra este codigo
                        </div>
                        <div class="small text-muted">
                            al abordar el vehiculo
                        </div>
                    </div>
                </div>
            </div>

            <%-- Pie del voucher: resumen de pago --%>
            <div class="voucher-footer">
                <div class="row align-items-center">
                    <div class="col-8">
                        <div class="small text-muted mb-1">
                            Resumen de pago
                        </div>
                        <div class="d-flex gap-3 small">
                            <span>
                                Metodo:
                                <strong id="v-metodo">-</strong>
                            </span>
                            <span>
                                Estado:
                                <span class="badge bg-success"
                                      id="v-estado">PAGADA</span>
                            </span>
                        </div>
                    </div>
                    <div class="col-4 text-end">
                        <div class="small text-muted">Total pagado</div>
                        <div class="fw-bold fs-5"
                             style="color:var(--naranja-dark)"
                             id="v-total">-</div>
                    </div>
                </div>
            </div>
        </div>

        <%-- Nota informativa --%>
        <div class="text-center mt-3 no-print">
            <small class="text-muted">
                <i class="bi bi-info-circle me-1"></i>
                Guarda tu voucher — lo necesitaras al abordar
            </small>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-4 no-print">
        <small>
            &copy; 2026
            Puerto<span style="color:var(--naranja)">Magico</span>
            &middot; Universidad Veracruzana
        </small>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const BASE = '/PuertoMagico';

        const params    = new URLSearchParams(window.location.search);
        const reservaId = params.get('reservaId');
        const referencia = params.get('referencia') || generarRef();

        window.onload = function() {
            if (!reservaId) {
                window.location.href = 'index.jsp';
                return;
            }
            cargarDatosVoucher();
        };

        /**
         * cargarDatosVoucher()
         * Carga todos los datos de la reserva para llenar
         * el voucher con informacion completa.
         */
        function cargarDatosVoucher() {
            // Cargar reserva
            fetch(BASE + '/api/reservas/detalle?id=' + reservaId)
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.error) {
                        // Si no hay endpoint de detalle,
                        // llenamos con lo que tenemos
                        llenarBasico();
                        return;
                    }
                    llenarVoucher(data);
                })
                .catch(function() {
                    llenarBasico();
                });

            // Cargar sesion para datos del viajero
            fetch(BASE + '/api/usuarios/sesion')
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (!data.error) {
                        document.getElementById('v-viajero-nombre')
                            .textContent =
                            (data.nombre || '') + ' ' +
                            (data.apellido || '');
                        document.getElementById('v-viajero-email')
                            .textContent = data.email || '';
                        document.getElementById('v-viajero-tel')
                            .textContent = data.telefono
                            ? 'Tel: ' + data.telefono : '';
                    }
                })
                .catch(function() {});
        }

        /**
         * llenarVoucher()
         * Llena el voucher con todos los datos de la reserva.
         */
        function llenarVoucher(r) {
            document.getElementById('v-referencia')
                .textContent = referencia;
            document.getElementById('v-tour-nombre')
                .textContent = r.nombreServicio || 'Tour';
            document.getElementById('v-personas')
                .textContent = (r.personas || '-') + ' persona' +
                    ((r.personas || 0) > 1 ? 's' : '');
            document.getElementById('v-total')
                .textContent = '$' + Number(r.total || 0)
                    .toLocaleString('es-MX');
            document.getElementById('v-metodo')
                .textContent = r.metodoPago || 'TARJETA';
            document.getElementById('v-destino')
                .textContent = r.nombreDestino || '-';

            // Fecha formateada
            if (r.fechaViaje) {
                var p = r.fechaViaje.split('-');
                document.getElementById('v-fecha')
                    .textContent = p[2] + '/' + p[1] + '/' + p[0];
            }

            // Asientos
            document.getElementById('v-asientos')
                .textContent = r.asientos
                ? r.asientos.join(', ') : 'Sin asiento asignado';

            // Cargar horarios de salida del tour
            if (r.tourId) {
                cargarHorarios(r.tourId);
            }
        }

        /**
         * llenarBasico()
         * Fallback cuando no hay endpoint de detalle.
         * Llena con los datos de la URL y lo que ya tenemos.
         */
        function llenarBasico() {
            document.getElementById('v-referencia')
                .textContent = referencia;
            document.getElementById('v-total')
                .textContent = '$' + parseFloat(
                    new URLSearchParams(window.location.search)
                    .get('total') || '0')
                    .toLocaleString('es-MX');
            document.getElementById('v-salidas').innerHTML =
                '<div class="text-muted small">' +
                'Consulta tu punto de salida con la agencia.' +
                '</div>';
        }

        /**
         * cargarHorarios()
         * Carga los puntos de salida con horarios del tour
         * y los muestra como items visuales en el voucher.
         */
        function cargarHorarios(tourId) {
            fetch(BASE + '/api/tours?id=' + tourId)
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    var tour = data.tour || data;
                    if (!tour.puntosSalida) return;

                    var container =
                        document.getElementById('v-salidas');
                    container.innerHTML = '';

                    /*
                     * puntosSalida tiene formato:
                     * "Veracruz 6:00am, Cardel 7:00am, Xalapa 8:00am"
                     * Separamos por coma y creamos un item por ciudad.
                     */
                    var puntos = tour.puntosSalida.split(',');
                    puntos.forEach(function(punto) {
                        punto = punto.trim();
                        if (!punto) return;

                        /*
                         * Separar ciudad y hora.
                         * Buscamos el patron HH:MMam/pm
                         */
                        var match = punto.match(
                            /^(.+?)\s+(\d{1,2}:\d{2}(?:am|pm))$/i);

                        var ciudad = match ? match[1] : punto;
                        var hora   = match ? match[2] : '';

                        var div = document.createElement('div');
                        div.className = 'salida-item';
                        div.innerHTML =
                            '<i class="bi bi-geo-alt-fill' +
                            ' text-danger"></i>' +
                            '<span class="fw-semibold">' +
                            ciudad + '</span>' +
                            (hora
                                ? '<span class="salida-hora ms-auto">' +
                                  hora + '</span>'
                                : '');
                        container.appendChild(div);
                    });

                    // Tambien llenar destino si no estaba
                    if (tour.nombreDestino) {
                        document.getElementById('v-destino')
                            .textContent = tour.nombreDestino;
                    }
                })
                .catch(function() {});
        }

        /**
         * descargarPDF()
         * Abre el dialogo de impresion del navegador.
         * El usuario puede elegir "Guardar como PDF".
         * El CSS @media print oculta navbar, botones y footer.
         */
        function descargarPDF() {
            window.print();
        }

        /**
         * generarRef()
         * Genera un codigo de referencia unico para el voucher.
         */
        function generarRef() {
            return 'PM-' + Date.now().toString(36).toUpperCase()
                .substring(0, 8);
        }
    </script>
</body>
</html>