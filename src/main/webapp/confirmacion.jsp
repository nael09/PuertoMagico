<%@ page contentType="text/html;charset=UTF-8"
         language="java"
         isELIgnored="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirmacion - Puerto Magico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root { --naranja: #F5A623; }
        .navbar { border-bottom: 3px solid var(--naranja); }
        /* Icono de exito animado */
        .icono-exito {
            width: 80px;
            height: 80px;
            background-color: #d1f5d3;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 2.5rem;
            color: #198754;
        }
        /* Caja del codigo QR */
        .voucher-box {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 1.5rem;
            background: #fff;
        }
        /* Codigo QR simulado con CSS */
        .qr-simulado {
            width: 120px;
            height: 120px;
            background:
                repeating-linear-gradient(
                    0deg,
                    #000 0px, #000 4px,
                    #fff 4px, #fff 8px),
                repeating-linear-gradient(
                    90deg,
                    #000 0px, #000 4px,
                    #fff 4px, #fff 8px);
            background-blend-mode: multiply;
            margin: 0 auto;
            border: 3px solid #000;
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
        </div>
    </nav>

    <div class="container py-5" style="max-width:600px">

        <div class="card border-0 shadow-sm">
            <div class="card-body p-5 text-center">

                <!-- Icono de exito -->
                <div class="icono-exito">
                    <i class="bi bi-check-lg"></i>
                </div>

                <h3 class="fw-bold mb-2">
                    Pago confirmado
                </h3>
                <p class="text-muted mb-4">
                    Tu reserva ha sido procesada exitosamente
                </p>

                <!-- Voucher QR -->
                <div class="voucher-box mb-4">
                    <p class="text-muted small mb-3">
                        Presenta este codigo al guia el dia del tour
                    </p>

                    <!-- QR simulado con CSS -->
                    <div class="qr-simulado mb-3"></div>

                    <!-- Codigo del voucher -->
                    <div class="fw-bold fs-5 letter-spacing-1 mt-3"
                         id="codigo-voucher">
                        Cargando...
                    </div>
                    <small class="text-muted">
                        Codigo de reserva
                    </small>
                </div>

                <!-- Detalles de la transaccion -->
                <div class="bg-light rounded p-3 mb-4 text-start">
                    <div class="d-flex justify-content-between
                                small mb-2">
                        <span class="text-muted">
                            Reserva #
                        </span>
                        <span class="fw-semibold"
                              id="conf-reserva-id">-</span>
                    </div>
                    <div class="d-flex justify-content-between
                                small mb-2">
                        <span class="text-muted">
                            Referencia de pago
                        </span>
                        <span class="fw-semibold"
                              id="conf-referencia">-</span>
                    </div>
                    <div class="d-flex justify-content-between small">
                        <span class="text-muted">Estado</span>
                        <span class="badge bg-success">
                            PAGADO
                        </span>
                    </div>
                </div>

                <!-- Botones -->
                <div class="d-grid gap-2">
                    <a href="index.jsp"
                       class="btn btn-outline-secondary">
                        <i class="bi bi-house me-1"></i>
                        Volver al inicio
                    </a>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Leemos los parametros que vienen de pago.jsp
        const params     = new URLSearchParams(
            window.location.search);
        const reservaId  = params.get('reservaId');
        const codigo     = params.get('codigo');
        const referencia = params.get('referencia');

        window.onload = function() {
            // Mostrar datos de la confirmacion
            document.getElementById('conf-reserva-id')
                .textContent = '#' + (reservaId || '-');
            document.getElementById('conf-referencia')
                .textContent = referencia || '-';
            document.getElementById('codigo-voucher')
                .textContent = codigo || 'PM-' + reservaId;
        };
    </script>
</body>
</html>