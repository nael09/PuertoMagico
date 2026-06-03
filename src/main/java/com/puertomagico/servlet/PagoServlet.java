package com.puertomagico.servlet;

import com.google.gson.Gson;
import com.puertomagico.dao.PagoDAO;
import com.puertomagico.dao.VoucherDAO;
import com.puertomagico.modelo.Pago;
import com.puertomagico.modelo.Voucher;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
/**
 * PagoServlet.java
 *
 * Simula el flujo de pago de una reserva.
 * En una aplicacion real aqui se conectaria con
 * una pasarela de pago como Stripe o MercadoPago.
 *
 * Rutas disponibles:
 *   POST /api/pagos/procesar  → Procesa el pago de una reserva
 *   GET  /api/pagos?reservaId=1 → Consulta el pago de una reserva
 */
@WebServlet("/api/pagos/*")
public class PagoServlet extends HttpServlet {

    private PagoDAO    pagoDAO;
    private VoucherDAO voucherDAO;
    private Gson       gson;

    @Override
    public void init() throws ServletException {
        pagoDAO    = new PagoDAO();
        voucherDAO = new VoucherDAO();
        gson       = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        if (!verificarSesion(request, response, out)) return;

        try {
            String paramId = request.getParameter("reservaId");

            if (paramId == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(crearError("Falta reservaId")));
                return;
            }

            Integer reservaId = Integer.parseInt(paramId);
            Pago    pago      = pagoDAO.buscarPorReserva(reservaId);

            if (pago != null) {
                out.print(gson.toJson(pago));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(crearError("Pago no encontrado")));
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(crearError("ID invalido")));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(crearError("Error: " + e.getMessage())));
        }
    }

    /**
     * doPost() — /api/pagos/procesar
     *
     * Simula el procesamiento del pago.
     * En produccion real aqui llamariamos a la API
     * de la pasarela de pago y esperariamos su respuesta.
     *
     * Flujo:
     *   1. Recibir datos del pago
     *   2. Simular aprobacion (siempre aprueba en esta version)
     *   3. Guardar el registro del pago
     *   4. Generar el voucher QR
     *   5. Devolver el codigo del voucher al cliente
     *
     * JSON esperado:
     * {
     *   "reservaId": 1,
     *   "monto":     1700.00,
     *   "metodo":    "TARJETA",
     *   "meses":     0
     * }
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        if (!verificarSesion(request, response, out)) return;

        String pathInfo = request.getPathInfo();

        if (!"/procesar".equals(pathInfo)) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print(gson.toJson(crearError("Ruta no encontrada")));
            return;
        }

        try {
            // Leer datos del pago
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> datos = gson.fromJson(
                sb.toString(), Map.class);

            Integer reservaId = ((Double) datos.get("reservaId")).intValue();
            BigDecimal monto  = new BigDecimal(datos.get("monto").toString());
            String metodo     = (String) datos.get("metodo");
            Integer meses     = datos.get("meses") != null
                ? ((Double) datos.get("meses")).intValue() : 0;

            // Validacion basica
            if (reservaId == null || monto == null || metodo == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(
                    crearError("Faltan datos del pago")));
                return;
            }

            // Generar folio unico para el pago simulado
            // En produccion esto lo genera la pasarela de pago
            String referencia = "PM-" +
                java.time.Year.now().getValue() + "-" +
                UUID.randomUUID().toString()
                    .substring(0, 6)
                    .toUpperCase();

            // Construir el objeto Pago
            Pago pago = new Pago();
            pago.setReservaId(reservaId);
            pago.setMonto(monto);
            pago.setMetodo(metodo);
            pago.setEstado("APROBADO"); // Siempre aprueba en simulacion
            pago.setReferencia(referencia);
            pago.setMesesSinIntereses(meses);

            // Guardar el pago y actualizar la reserva a PAGADA
            boolean exito = pagoDAO.registrarPago(pago);

            if (!exito) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(crearError("Error al procesar el pago")));
                return;
            }

            // Generar el voucher QR automaticamente
            // El codigo se usara para validar la entrada al tour
            Voucher voucher = voucherDAO.generarVoucher(reservaId);

            // Construir respuesta completa
            Map<String, Object> respuesta = new HashMap<>();
            respuesta.put("error",      false);
            respuesta.put("mensaje",    "Pago procesado correctamente");
            respuesta.put("referencia", referencia);
            respuesta.put("estado",     "APROBADO");

            // Incluir el codigo QR si se genero correctamente
            if (voucher != null) {
                respuesta.put("codigoQr", voucher.getCodigoQr());
                respuesta.put("mensaje",  "Pago aprobado. Tu voucher ha sido generado.");
            }

            out.print(gson.toJson(respuesta));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(crearError("Error: " + e.getMessage())));
        }
    }

    // ── Metodos de utilidad ────────────────────────────────

    private void configurarRespuesta(HttpServletResponse response) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
    }

    private boolean verificarSesion(HttpServletRequest request,
                                     HttpServletResponse response,
                                     PrintWriter out) {
        HttpSession sesion = request.getSession(false);
        if (sesion == null || sesion.getAttribute("usuarioId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(crearError("Debes iniciar sesion")));
            return false;
        }
        return true;
    }

    private Map<String, Object> crearError(String mensaje) {
        Map<String, Object> err = new HashMap<>();
        err.put("error",   true);
        err.put("mensaje", mensaje);
        return err;
    }

    private Map<String, Object> crearExito(String mensaje) {
        Map<String, Object> ok = new HashMap<>();
        ok.put("error",   false);
        ok.put("mensaje", mensaje);
        return ok;
    }

    @Override
    protected void doOptions(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods",
            "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}