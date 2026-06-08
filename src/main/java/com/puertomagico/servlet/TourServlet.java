package com.puertomagico.servlet;

import com.google.gson.Gson;
import com.google.gson.JsonSerializer;
import com.puertomagico.dao.AsientoDAO;
import com.puertomagico.dao.TourDAO;
import com.puertomagico.modelo.Tour;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.GsonBuilder;


/**
 
 * Servlet que maneja todas las peticiones HTTP relacionadas
 * con los tours de la agencia.
 * 
 * La anotación @WebServlet define la URL que activa este Servlet.
 * Cuando el navegador hace una petición a /api/tours,
 * Tomcat busca qué Servlet tiene esa URL y lo ejecuta.
 * 
 * Rutas que maneja este Servlet:
 * 
 *   GET  /api/tours          → Lista todos los tours activos
 *   GET  /api/tours?id=1     → Detalle de un tour específico
 *   GET  /api/tours?destino=1 → Tours de un destino
 *   POST /api/tours          → Crear tour nuevo (solo ADMIN)
 */
@WebServlet("/api/tours")
public class TourServlet extends HttpServlet {

    // DAO que usaremos para consultar la BD
    // Lo declaramos aquí para no crearlo en cada petición
    private TourDAO tourDAO;
    private AsientoDAO asientoDAO;

    // Gson convierte objetos Java a JSON
    // Lo configuramos aquí para reutilizarlo en todas las peticiones
    private Gson gson;

    /**
     * init()
     * 
     * Tomcat llama este método UNA SOLA VEZ cuando arranca el Servlet.
     * Aquí inicializamos los objetos que se reutilizan en cada petición.
     * 
     * Es más eficiente que crear un DAO nuevo en cada petición.
     */
   @Override
public void init() throws ServletException {
    tourDAO    = new TourDAO();
    asientoDAO = new AsientoDAO(); // ← faltaba esta línea

    GsonBuilder builder = new GsonBuilder();

    builder.registerTypeAdapter(
        java.time.LocalDate.class,
        (com.google.gson.JsonSerializer<java.time.LocalDate>)
        (src, type, ctx) -> ctx.serialize(
            src.format(java.time.format.DateTimeFormatter
                .ISO_LOCAL_DATE)));

    builder.registerTypeAdapter(
        java.time.LocalDateTime.class,
        (com.google.gson.JsonSerializer<java.time.LocalDateTime>)
        (src, type, ctx) -> ctx.serialize(
            src.format(java.time.format.DateTimeFormatter
                .ISO_LOCAL_DATE_TIME)));

    gson = builder.create();
}

    /**
     * doGet()
     * 
     * Responde peticiones GET — cuando el navegador pide datos.
     * 
     * Parámetros opcionales en la URL:
     *   ?id=1       → devuelve ese tour específico
     *   ?destino=2  → devuelve tours de ese destino
     *   (sin params) → devuelve todos los tours activos
     * 
     * @param request  — contiene los datos de la petición (URL, parámetros)
     * @param response — donde escribimos la respuesta (JSON)
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Configuramos la respuesta como JSON con codificación UTF-8
        // Sin esto los acentos y caracteres especiales se corrompen
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Permitimos que el frontend (en otro puerto) pueda consumir el API
        // Sin esto el navegador bloquea las peticiones por seguridad (CORS)
        response.setHeader("Access-Control-Allow-Origin", "*");

        // PrintWriter es el canal por donde enviamos la respuesta
        PrintWriter out = response.getWriter();

        try {
            // Leemos los parámetros de la URL
            // request.getParameter("id") lee ?id=1 de la URL
            // Devuelve null si el parámetro no existe
            String paramId = request.getParameter("id");
            String paramDestino = request.getParameter("destino");

            if (paramId != null) {
                // ── Caso 1: Buscar tour por ID ─────────────────
                // URL: GET /api/tours?id=1
                Integer id = Integer.parseInt(paramId);
                Tour tour = tourDAO.buscarPorId(id);

                if (tour != null) {
                    // Agregamos los lugares disponibles al objeto
                    // antes de convertirlo a JSON
                    int disponibles = asientoDAO.contarDisponibles(id);

                    // Creamos un Map para agregar datos extra al JSON
                    // sin modificar la clase Tour
                    Map<String, Object> respuesta = new HashMap<>();
                    respuesta.put("tour", tour);
                    respuesta.put("lugaresDisponibles", disponibles);

                    // gson.toJson convierte el objeto Java a texto JSON
                    out.print(gson.toJson(respuesta));
                } else {
                    // Tour no encontrado — respondemos con error 404
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(
                        crearError("Tour no encontrado con id: " + id)));
                }

            } else if (paramDestino != null) {
                // ── Caso 2: Tours por destino ──────────────────
                // URL: GET /api/tours?destino=2
                Integer destinoId = Integer.parseInt(paramDestino);
                List<Tour> tours = tourDAO.listarPorDestino(destinoId);
                out.print(gson.toJson(tours));

            } else {
                // ── Caso 3: Listar todos los tours ─────────────
                // URL: GET /api/tours
                List<Tour> tours = tourDAO.listarTodos();
                out.print(gson.toJson(tours));
            }

        } catch (NumberFormatException e) {
            // El ID que enviaron no es un número válido
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(crearError("ID inválido: " + e.getMessage())));

        } catch (Exception e) {
            // Error inesperado del servidor
            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(
                crearError("Error del servidor: " + e.getMessage())));
        }
    }

    /**
     * doPost()
     * 
     * Responde peticiones POST — cuando el admin envía datos
     * para crear un tour nuevo.
     * 
     * El frontend envía el tour en formato JSON en el cuerpo
     * de la petición. Nosotros lo leemos y lo guardamos en la BD.
     * 
     * Solo puede usar este método un usuario ADMIN.
     * Verificamos la sesión antes de proceder.
     * 
     * @param request  — contiene el JSON con los datos del tour
     * @param response — donde escribimos la respuesta
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");

        PrintWriter out = response.getWriter();

        try {
            // ── Verificar que sea ADMIN ────────────────────────
            // La sesión guarda el rol del usuario logueado
            // Si no hay sesión o no es ADMIN, rechazamos la petición
            String rol = (String) request.getSession()
                .getAttribute("rol");

            if (!"ADMIN".equals(rol)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print(gson.toJson(
                    crearError("Acceso denegado. Se requiere rol ADMIN.")));
                return; // Terminamos aquí — no procesamos nada más
            }

            // ── Leer el JSON del cuerpo de la petición ─────────
            // request.getReader() lee el cuerpo completo de la petición
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }
            String jsonRecibido = sb.toString();

            // gson.fromJson convierte el JSON a un objeto Tour
            Tour tour = gson.fromJson(jsonRecibido, Tour.class);

            // ── Validación básica ──────────────────────────────
            if (tour.getNombre() == null || tour.getNombre().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(crearError("El nombre es obligatorio")));
                return;
            }

            if (tour.getPrecioBase() == null || 
                tour.getPrecioBase().compareTo(BigDecimal.ZERO) <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(
                    crearError("El precio debe ser mayor a 0")));
                return;
            }

            // ── Insertar en la BD ──────────────────────────────
            boolean exito = tourDAO.insertar(tour);

            if (exito) {
                // Respondemos con 201 Created — estándar HTTP para
                // indicar que se creó un recurso nuevo exitosamente
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.print(gson.toJson(crearExito("Tour creado exitosamente")));
            } else {
                response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(crearError("No se pudo crear el tour")));
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(
                crearError("Error del servidor: " + e.getMessage())));
        }
    }
    
    
    /**
 * doPut()
 *
 * Actualiza un tour existente.
 * Solo el ADMIN puede usarlo.
 *
 * URL: PUT /api/tours
 * Body: JSON con los datos actualizados del tour
 */
@Override
protected void doPut(HttpServletRequest request,
                     HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Access-Control-Allow-Origin", "*");

    PrintWriter out = response.getWriter();

    // Verificar que sea ADMIN
    String rol = (String) request.getSession().getAttribute("rol");
    if (!"ADMIN".equals(rol)) {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        out.print(gson.toJson(crearError("Acceso denegado")));
        return;
    }

    try {
        // Leer JSON del cuerpo
        StringBuilder sb = new StringBuilder();
        String linea;
        while ((linea = request.getReader().readLine()) != null) {
            sb.append(linea);
        }

        Tour tour = gson.fromJson(sb.toString(), Tour.class);

        // Validar que tenga ID
        if (tour.getId() == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(crearError("Falta el ID del tour")));
            return;
        }

        boolean exito = tourDAO.actualizar(tour);

        if (exito) {
            out.print(gson.toJson(crearExito("Tour actualizado correctamente")));
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(crearError("No se pudo actualizar el tour")));
        }

    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print(gson.toJson(crearError("Error: " + e.getMessage())));
    }
}

/**
 * doDelete()
 *
 * Desactiva un tour (borrado lógico).
 * Solo el ADMIN puede usarlo.
 *
 * URL: DELETE /api/tours?id=1
 */
@Override
protected void doDelete(HttpServletRequest request,
                        HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Access-Control-Allow-Origin", "*");

    PrintWriter out = response.getWriter();

    // Verificar que sea ADMIN
    String rol = (String) request.getSession().getAttribute("rol");
    if (!"ADMIN".equals(rol)) {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        out.print(gson.toJson(crearError("Acceso denegado")));
        return;
    }

    try {
        String paramId = request.getParameter("id");

        if (paramId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(crearError("Falta el ID del tour")));
            return;
        }

        Integer id    = Integer.parseInt(paramId);
        boolean exito = tourDAO.desactivar(id);

        if (exito) {
            out.print(gson.toJson(
                crearExito("Tour desactivado correctamente")));
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print(gson.toJson(crearError("Tour no encontrado")));
        }

    } catch (NumberFormatException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print(gson.toJson(crearError("ID inválido")));
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print(gson.toJson(crearError("Error: " + e.getMessage())));
    }
}

    /**
     * doOptions()
     * 
     * Responde peticiones OPTIONS del navegador.
     * 
     * Antes de hacer una petición POST o PUT, el navegador
     * envía una petición OPTIONS para preguntar si el servidor
     * acepta ese tipo de petición (esto se llama CORS preflight).
     * Sin este método, el navegador bloquea todas las peticiones
     * que no sean GET.
     */
    @Override
    protected void doOptions(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods",
            "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers",
            "Content-Type, Authorization");
        response.setStatus(HttpServletResponse.SC_OK);
        response.setHeader("Access-Control-Allow-Methods",
    "GET, POST, PUT, DELETE, OPTIONS"); // ← agrega PUT y DELETE
    }

    /**
     * crearError()
     * 
     * Método privado de utilidad que crea un Map con
     * estructura de error estandarizada.
     * 
     * Devuelve JSON así:
     * {
     *   "error": true,
     *   "mensaje": "Tour no encontrado con id: 99"
     * }
     * 
     * Tener un formato consistente ayuda al frontend a
     * manejar los errores siempre de la misma manera.
     */
    private Map<String, Object> crearError(String mensaje) {
        Map<String, Object> error = new HashMap<>();
        error.put("error", true);
        error.put("mensaje", mensaje);
        return error;
    }

    /**
     * crearExito()
     * 
     * Igual que crearError pero para respuestas exitosas.
     * 
     * Devuelve JSON así:
     * {
     *   "error": false,
     *   "mensaje": "Tour creado exitosamente"
     * }
     */
    private Map<String, Object> crearExito(String mensaje) {
        Map<String, Object> respuesta = new HashMap<>();
        respuesta.put("error", false);
        respuesta.put("mensaje", mensaje);
        return respuesta;
    }
}