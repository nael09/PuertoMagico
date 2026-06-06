package com.puertomagico.servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import com.puertomagico.dao.ReservaDAO;
import com.puertomagico.modelo.Reserva;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ReservaServlet.java
 *
 * Maneja las peticiones HTTP relacionadas con reservas.
 *
 * Rutas disponibles:
 *
 *   GET  /api/reservas/mis-reservas → Lista las reservas del cliente
 *   GET  /api/reservas?id=1         → Detalle de una reserva
 *   POST /api/reservas/crear        → Crear una reserva nueva
 *   POST /api/reservas/cancelar     → Cancelar una reserva
 *
 * IMPORTANTE: Todas las rutas requieren que el usuario
 * haya iniciado sesión. Si no hay sesión activa,
 * respondemos con error 401 (No autorizado).
 */
@WebServlet("/api/reservas/*")
public class ReservaServlet extends HttpServlet {

    private ReservaDAO reservaDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        reservaDAO = new ReservaDAO();

        GsonBuilder builder = new GsonBuilder();

        builder.registerTypeAdapter(java.time.LocalDateTime.class,
            (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                context.serialize(src.format(
                    DateTimeFormatter.ISO_LOCAL_DATE_TIME)));

        builder.registerTypeAdapter(LocalDate.class,
            (JsonSerializer<LocalDate>) (src, typeOfSrc, context) ->
                context.serialize(src.format(
                    DateTimeFormatter.ISO_LOCAL_DATE)));

        gson = builder.create();
    }

    // ── GET ────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        // Verificamos que el usuario esté logueado
        // Si no hay sesión, no puede ver reservas
        if (!verificarSesion(request, response, out)) return;

        String pathInfo = request.getPathInfo();
        
        HttpSession sesion = request.getSession(false);
        String rol = (String) sesion.getAttribute("rol");

        if ("/mis-reservas".equals(pathInfo)) {
            // Si es ADMIN devuelve TODAS las reservas
            // Si es CLIENTE devuelve solo las suyas
            if("ADMIN".equals(rol)){
                manejarTodasLasReservas(request, response , out);
            } else {
                // Reservas del cliente logueado
                 manejarMisReservas(request, response, out);
            }
            
        } else {
            // Detalle de una reserva por ID
            // URL: GET /api/reservas?id=5
            manejarDetalle(request, response, out);
        }
    }

    // ── POST ───────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");

        PrintWriter out = response.getWriter();

        if (!verificarSesion(request, response, out)) return;

        String pathInfo = request.getPathInfo();

        if ("/crear".equals(pathInfo)) {
            manejarCrear(request, response, out);

        } else if ("/cancelar".equals(pathInfo)) {
            manejarCancelar(request, response, out);

        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print(gson.toJson(crearError("Ruta no encontrada")));
        }
    }

    // ── MÉTODOS PRIVADOS ───────────────────────────────────────

    /**
     * manejarMisReservas()
     *
     * Devuelve todas las reservas del usuario en sesión.
     * El cliente solo puede ver SUS reservas — no las de otros.
     */
    private void manejarMisReservas(HttpServletRequest request,
                                     HttpServletResponse response,
                                     PrintWriter out) {
        try {
            // Obtenemos el ID del usuario desde la sesión
            HttpSession sesion = request.getSession(false);
            Integer usuarioId  = (Integer) sesion.getAttribute("usuarioId");

            // Consultamos solo las reservas de ese usuario
            List<Reserva> reservas = reservaDAO.listarPorUsuario(usuarioId);

            out.print(gson.toJson(reservas));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(
                crearError("Error al obtener reservas: " + e.getMessage())));
        }
    }

    /**
     * manejarDetalle()
     *
     * Devuelve el detalle de una reserva específica.
     * Verificamos que la reserva le pertenezca al usuario
     * para que un cliente no pueda ver la reserva de otro.
     */
    private void manejarDetalle(HttpServletRequest request,
                                 HttpServletResponse response,
                                 PrintWriter out) {
        try {
            String paramId = request.getParameter("id");

            if (paramId == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(crearError("Falta el parámetro id")));
                return;
            }

            Integer id     = Integer.parseInt(paramId);
            Reserva reserva = reservaDAO.buscarPorId(id);

            if (reserva == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(crearError("Reserva no encontrada")));
                return;
            }

            // Verificar que la reserva le pertenezca al usuario
            HttpSession sesion    = request.getSession(false);
            Integer usuarioId     = (Integer) sesion.getAttribute("usuarioId");
            String rol            = (String)  sesion.getAttribute("rol");

            // Un ADMIN puede ver cualquier reserva
            // Un CLIENTE solo puede ver las suyas
            boolean esAdmin       = "ADMIN".equals(rol);
            boolean esDelUsuario  = reserva.getUsuarioId().equals(usuarioId);

            if (!esAdmin && !esDelUsuario) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print(gson.toJson(
                    crearError("No tienes permiso para ver esta reserva")));
                return;
            }

            out.print(gson.toJson(reserva));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(crearError("ID inválido")));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(crearError("Error: " + e.getMessage())));
        }
    }

    /**
     * manejarCrear()
     *
     * Crea una reserva nueva.
     *
     * JSON esperado:
     * {
     *   "tipoServicio": "TOUR",
     *   "tourId":       1,
     *   "fechaViaje":   "2026-05-15",
     *   "personas":     2,
     *   "total":        1700.00,
     *   "asientosIds":  [3, 7]
     * }
     */
    private void manejarCrear(HttpServletRequest request,
                               HttpServletResponse response,
                               PrintWriter out) {
        try {
            // Leer el JSON del cuerpo de la petición
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }

            // Convertimos el JSON a un Map para leer cada campo
            @SuppressWarnings("unchecked")
            Map<String, Object> datos = gson.fromJson(
                sb.toString(), Map.class);

            // ── Validaciones básicas ───────────────────────
            if (datos.get("tipoServicio") == null ||
                datos.get("fechaViaje")   == null ||
                datos.get("personas")     == null ||
                datos.get("total")        == null) {

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(
                    crearError("Faltan datos obligatorios")));
                return;
            }

            // ── Construir objeto Reserva ───────────────────
            Reserva reserva = new Reserva();

            // Asignamos el usuario desde la sesión
            // El cliente no puede reservar a nombre de otro
            HttpSession sesion = request.getSession(false);
            reserva.setUsuarioId((Integer) sesion.getAttribute("usuarioId"));

            reserva.setTipoServicio((String) datos.get("tipoServicio"));

            // tourId o paqueteId según el tipo de servicio
            if ("TOUR".equals(reserva.getTipoServicio())) {
                Integer tourId = ((Double) datos.get("tourId")).intValue();
                reserva.setTourId(tourId);
            } else {
                Integer paqueteId = ((Double) datos.get("paqueteId")).intValue();
                reserva.setPaqueteId(paqueteId);
            }

            // Convertimos el texto "2026-05-15" a LocalDate
            reserva.setFechaViaje(
                LocalDate.parse((String) datos.get("fechaViaje")));

            reserva.setPersonas(((Double) datos.get("personas")).intValue());
            reserva.setTotal(
                new java.math.BigDecimal(datos.get("total").toString()));

            // Lista de IDs de asientos seleccionados
            @SuppressWarnings("unchecked")
            List<Double> asientosRaw =
                (List<Double>) datos.get("asientosIds");

            List<Integer> asientosIds = new ArrayList<>();
            if (asientosRaw != null) {
                for (Double id : asientosRaw) {
                    asientosIds.add(id.intValue());
                }
            }

            // ── Crear la reserva en la BD ──────────────────
            // Este método usa una transacción — inserta la reserva
            // y confirma los asientos en una sola operación
            Integer reservaId = reservaDAO.crearReservaCompleta(
                reserva, asientosIds);

            if (reservaId == -1) {
                // Falló — probablemente un asiento ya no estaba disponible
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                out.print(gson.toJson(
                    crearError("No se pudo completar la reserva. " +
                               "Algún asiento ya no está disponible.")));
                return;
            }

            // Reserva creada exitosamente
            response.setStatus(HttpServletResponse.SC_CREATED);
            Map<String, Object> respuesta = new HashMap<>();
            respuesta.put("error",     false);
            respuesta.put("mensaje",   "Reserva creada exitosamente");
            respuesta.put("reservaId", reservaId);
            out.print(gson.toJson(respuesta));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(crearError("Error: " + e.getMessage())));
        }
    }

    /**
     * manejarCancelar()
     *
     * Cancela una reserva existente.
     *
     * JSON esperado:
     * {
     *   "reservaId": 5
     * }
     */
    private void manejarCancelar(HttpServletRequest request,
                                  HttpServletResponse response,
                                  PrintWriter out) {
        try {
            // Leer JSON
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> datos = gson.fromJson(
                sb.toString(), Map.class);

            Integer reservaId = ((Double) datos.get("reservaId")).intValue();

            // Buscamos la reserva para validarla
            Reserva reserva = reservaDAO.buscarPorId(reservaId);

            if (reserva == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(crearError("Reserva no encontrada")));
                return;
            }

            // Verificar que la reserva le pertenezca al usuario
            HttpSession sesion   = request.getSession(false);
            Integer usuarioId    = (Integer) sesion.getAttribute("usuarioId");
            String rol           = (String)  sesion.getAttribute("rol");

            boolean esAdmin      = "ADMIN".equals(rol);
            boolean esDelUsuario = reserva.getUsuarioId().equals(usuarioId);

            if (!esAdmin && !esDelUsuario) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print(gson.toJson(
                    crearError("No puedes cancelar una reserva que no es tuya")));
                return;
            }

            // Verificar que la reserva se pueda cancelar
            // Solo se pueden cancelar reservas PENDIENTE o PAGADA
            if (!reserva.isCancelable()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(
                    crearError("Esta reserva ya no se puede cancelar")));
                return;
            }

            // Cambiar el estado a CANCELADA
            boolean exito = reservaDAO.cambiarEstado(reservaId, "CANCELADA");

            if (exito) {
                out.print(gson.toJson(
                    crearExito("Reserva cancelada correctamente")));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(crearError("No se pudo cancelar")));
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(crearError("Error: " + e.getMessage())));
        }
    }

    /**
     * verificarSesion()
     *
     * Verifica que haya una sesión activa.
     * Si no hay sesión, responde con error 401 y devuelve false.
     *
     * Lo llamamos al inicio de cada método para proteger
     * todas las rutas de este Servlet.
     *
     * @return true si hay sesión, false si no hay
     */
    private boolean verificarSesion(HttpServletRequest request,
                                     HttpServletResponse response,
                                     PrintWriter out) {

        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("usuarioId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(
                crearError("Debes iniciar sesión para continuar")));
            return false;
        }

        return true;
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

    private Map<String, Object> crearError(String mensaje) {
        Map<String, Object> error = new HashMap<>();
        error.put("error",   true);
        error.put("mensaje", mensaje);
        return error;
    }

    private Map<String, Object> crearExito(String mensaje) {
        Map<String, Object> ok = new HashMap<>();
        ok.put("error",   false);
        ok.put("mensaje", mensaje);
        return ok;
    }
/*
    
  /**
 * manejarTodasLasReservas()
 *
 * Solo accesible por el ADMIN.
 * Devuelve todas las reservas del sistema
 * para mostrarlas en el panel de administracion.
 */
    private void manejarTodasLasReservas(HttpServletRequest request,
                                      HttpServletResponse response,
                                      PrintWriter out) {
      try {
        List<Reserva> reservas = reservaDAO.listarTodas();
        out.print(gson.toJson(reservas));

    } catch (Exception e) {
        response.setStatus(
            HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print(gson.toJson(
            crearError("Error al obtener reservas: "
                + e.getMessage())));
    }
      
  }      

   /**
 * configurarRespuesta()
 * Configura los headers de la respuesta HTTP.
 * Se llama al inicio de cada doGet, doPost, etc.
 * para que el navegador sepa que la respuesta es JSON.
 */
  private void configurarRespuesta(HttpServletResponse response) {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Access-Control-Allow-Origin", "*");
  }
  
  
}
