package com.puertomagico.servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.puertomagico.dao.AsientoDAO;
import com.puertomagico.modelo.Asiento;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

  /*
 * AsientoServlet.java
 *
 * Maneja las peticiones relacionadas con asientos de un tour.
 * Es el Servlet mas critico del sistema porque resuelve
 * la concurrencia — evitar que dos usuarios reserven
 * el mismo asiento al mismo tiempo.
 *
 * Rutas disponibles:
 *   GET  /api/asientos?tourId=1  → Lista asientos de un tour
 *   POST /api/asientos/bloquear  → Bloquea un asiento (inicio de pago)
 *   POST /api/asientos/liberar   → Libera un asiento (pago cancelado)
 */
@WebServlet("/api/asientos/*")
public class AsientoServlet extends HttpServlet {

    private AsientoDAO asientoDAO;
    private Gson gson;

@Override
public void init() throws ServletException {
    asientoDAO = new AsientoDAO();

    /*
     * GsonBuilder con serializadores personalizados para
     * LocalDateTime y LocalDate — sin esto Gson lanza error
     * al intentar convertir esos tipos a JSON porque no son
     * tipos nativos que Gson reconozca por defecto.
     */
    GsonBuilder builder = new GsonBuilder();

    builder.registerTypeAdapter(
        java.time.LocalDateTime.class,
        (com.google.gson.JsonSerializer<java.time.LocalDateTime>)
        (src, type, ctx) -> ctx.serialize(
            src.format(java.time.format.DateTimeFormatter
                .ISO_LOCAL_DATE_TIME)));

    builder.registerTypeAdapter(
        java.time.LocalDate.class,
        (com.google.gson.JsonSerializer<java.time.LocalDate>)
        (src, type, ctx) -> ctx.serialize(
            src.format(java.time.format.DateTimeFormatter
                .ISO_LOCAL_DATE)));

    gson = builder.create();
}

    /**
     * doGet()
     *
     * Devuelve todos los asientos de un tour con su estado actual.
     * El frontend usa esto para dibujar el mapa visual de asientos.
     *
     * URL: GET /api/asientos?tourId=1
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        String paramTourId = request.getParameter("tourId");

        if (paramTourId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(crearError("Falta el parametro tourId")));
            return;
        }

        try {
            Integer tourId = Integer.parseInt(paramTourId);
            List<Asiento> asientos  = asientoDAO.listarPorTour(tourId);
            out.print(gson.toJson(asientos));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(crearError("tourId invalido")));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(crearError("Error: " + e.getMessage())));
        }
    }

    /**
     * doPost()
     *
     * Maneja dos acciones segun la ruta:
     *   /api/asientos/bloquear → bloquea el asiento para pago
     *   /api/asientos/liberar  → lo regresa a disponible
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        // Solo usuarios con sesion pueden bloquear asientos
        if (!verificarSesion(request, response, out)) return;

        String pathInfo = request.getPathInfo();

        if ("/bloquear".equals(pathInfo)) {
            manejarBloqueo(request, response, out);

        } else if ("/liberar".equals(pathInfo)) {
            manejarLiberacion(request, response, out);

        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print(gson.toJson(crearError("Ruta no encontrada")));
        }
    }

    /**
     * manejarBloqueo()
     *
     * Intenta bloquear un asiento para que el cliente
     * pueda proceder al pago sin que otro usuario lo tome.
     *
     * Usa SELECT FOR UPDATE en la BD para garantizar que
     * solo UN usuario pueda bloquear el asiento a la vez.
     *
     * JSON esperado: { "asientoId": 5 }
     */
    private void manejarBloqueo(HttpServletRequest request,
                                 HttpServletResponse response,
                                 PrintWriter out) throws IOException {

        try {
            // Leer JSON del cuerpo
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> datos = gson.fromJson(
                sb.toString(), Map.class);

            Integer asientoId = ((Double) datos.get("asientoId")).intValue();

            // Intentamos bloquear el asiento
            // Este metodo usa una transaccion con SELECT FOR UPDATE
            boolean exito = asientoDAO.bloquearAsiento(asientoId);

            if (exito) {
                // Asiento bloqueado — el cliente tiene 10 minutos para pagar
                Map<String, Object> resp = new HashMap<>();
                resp.put("error",   false);
                resp.put("mensaje", "Asiento bloqueado. Tienes 10 minutos para completar el pago.");
                resp.put("minutos", 10);
                out.print(gson.toJson(resp));

            } else {
                // El asiento ya no estaba disponible
                // Otro usuario lo tomo antes
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                out.print(gson.toJson(
                    crearError("El asiento ya no esta disponible. Por favor elige otro.")));
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(crearError("Error: " + e.getMessage())));
        }
    }

    /**
     * manejarLiberacion()
     *
     * Libera un asiento que estaba bloqueado.
     * Se llama cuando el cliente cancela el proceso de pago
     * o cierra la ventana sin pagar.
     *
     * JSON esperado: { "asientoId": 5 }
     */
    private void manejarLiberacion(HttpServletRequest request,
                                    HttpServletResponse response,
                                    PrintWriter out) throws IOException {

        try {
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> datos = gson.fromJson(
                sb.toString(), Map.class);

            Integer asientoId = ((Double) datos.get("asientoId")).intValue();
            boolean exito     = asientoDAO.liberarAsiento(asientoId);

            if (exito) {
                out.print(gson.toJson(crearExito("Asiento liberado correctamente")));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(crearError("Asiento no encontrado")));
            }

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
            out.print(gson.toJson(
                crearError("Debes iniciar sesion para continuar")));
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