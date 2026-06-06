package com.puertomagico.servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import com.puertomagico.dao.UsuarioDAO;
import com.puertomagico.modelo.Usuario;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * UsuarioServlet.java
 *
 * Maneja todas las peticiones HTTP relacionadas con usuarios:
 * registro, login y logout.
 *
 * Rutas que maneja:
 *
 *   POST /api/usuarios/registro → Registrar usuario nuevo
 *   POST /api/usuarios/login    → Iniciar sesión
 *   GET  /api/usuarios/logout   → Cerrar sesión
 *   GET  /api/usuarios/sesion   → Verificar si hay sesión activa
 *
 * SESIONES — ¿Cómo funciona el login sin frameworks?
 *
 * Cuando un usuario hace login exitoso, guardamos sus datos
 * en una HttpSession — un objeto que Tomcat mantiene en memoria
 * asociado a ese navegador mediante una cookie llamada JSESSIONID.
 *
 * Así funciona:
 *   1. Usuario envía email + password
 *   2. Verificamos en la BD
 *   3. Si es correcto → guardamos id, nombre y rol en la sesión
 *   4. En cada petición siguiente → leemos la sesión para saber
 *      quién está logueado y qué permisos tiene
 *   5. Logout → destruimos la sesión
 */
@WebServlet("/api/usuarios/*")
public class UsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;
    private Gson gson;

    /**
     * init()
     * Inicializamos el DAO y Gson una sola vez al arrancar.
     */
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();

        GsonBuilder builder = new GsonBuilder();

        // Serializador para LocalDateTime
        builder.registerTypeAdapter(LocalDateTime.class,
            (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                context.serialize(src.format(
                    DateTimeFormatter.ISO_LOCAL_DATE_TIME)));

        // Serializador para LocalDate
        builder.registerTypeAdapter(LocalDate.class,
            (JsonSerializer<LocalDate>) (src, typeOfSrc, context) ->
                context.serialize(src.format(
                    DateTimeFormatter.ISO_LOCAL_DATE)));

        gson = builder.create();
    }

    /**
     * doGet()
     *
     * Maneja peticiones GET:
     *   /api/usuarios/logout  → Cierra la sesión activa
     *   /api/usuarios/sesion  → Devuelve datos del usuario en sesión
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", "true");

        PrintWriter out = response.getWriter();

        // getPathInfo() devuelve la parte de la URL después de /api/usuarios
        // Ejemplo: /api/usuarios/logout → pathInfo = "/logout"
        String pathInfo = request.getPathInfo();

        if ("/logout".equals(pathInfo)) {
            // ── LOGOUT ────────────────────────────────────
            manejarLogout(request, response, out);
            
            
            } else if ("/listar".equals(pathInfo)) {
          // Solo ADMIN puede ver todos los usuarios
            manejarListarUsuarios(request, response, out);

            
            
        } else if ("/sesion".equals(pathInfo)) {
            // ── VERIFICAR SESIÓN ──────────────────────────
            manejarVerificarSesion(request, response, out);

        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print(gson.toJson(crearError("Ruta no encontrada")));
        }
    }

    /**
     * doPost()
     *
     * Maneja peticiones POST:
     *   /api/usuarios/registro → Registrar usuario nuevo
     *   /api/usuarios/login    → Iniciar sesión
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", "true");

        PrintWriter out = response.getWriter();

        String pathInfo = request.getPathInfo();

        if ("/registro".equals(pathInfo)) {
            // ── REGISTRO ──────────────────────────────────
            manejarRegistro(request, response, out);

        } else if ("/login".equals(pathInfo)) {
            // ── LOGIN ─────────────────────────────────────
            manejarLogin(request, response, out);

        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print(gson.toJson(crearError("Ruta no encontrada")));
        }
    }

    /**
     * manejarRegistro()
     *
     * Lee los datos del JSON recibido, valida y registra
     * el nuevo usuario en la BD.
     *
     * JSON esperado:
     * {
     *   "nombre":   "María",
     *   "apellido": "García",
     *   "email":    "maria@email.com",
     *   "passwordHash": "miPassword123",
     *   "telefono": "2291234567"
     * }
     */
    private void manejarRegistro(HttpServletRequest request,
                                  HttpServletResponse response,
                                  PrintWriter out)
            throws IOException {

        try {
            // Leer el JSON del cuerpo de la petición
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }

            // Convertir JSON a objeto Usuario
            Usuario usuario = gson.fromJson(sb.toString(), Usuario.class);

            // ── Validaciones ──────────────────────────────
            if (usuario.getNombre() == null || 
                usuario.getNombre().trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(crearError("El nombre es obligatorio")));
                return;
            }

            if (usuario.getEmail() == null || 
                usuario.getEmail().trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(crearError("El email es obligatorio")));
                return;
            }

            if (usuario.getPasswordHash() == null || 
                usuario.getPasswordHash().length() < 6) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(
                    crearError("La contraseña debe tener mínimo 6 caracteres")));
                return;
            }

            // Verificar que el email no esté ya registrado
            if (usuarioDAO.existeEmail(usuario.getEmail())) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                out.print(gson.toJson(
                    crearError("Este email ya está registrado")));
                return;
            }

            // El rol siempre es CLIENTE al registrarse desde la web
            // Los ADMIN se crean directamente en la BD
            usuario.setRol("CLIENTE");

            // Registrar en la BD
            // El DAO se encarga de encriptar la contraseña con MD5
            boolean exito = usuarioDAO.registrar(usuario);

            if (exito) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.print(gson.toJson(
                    crearExito("Cuenta creada exitosamente")));
            } else {
                response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(
                    crearError("No se pudo crear la cuenta")));
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(
                crearError("Error del servidor: " + e.getMessage())));
        }
    }

    /**
     * manejarLogin()
     *
     * Verifica las credenciales del usuario y crea una sesión
     * si son correctas.
     *
     * JSON esperado:
     * {
     *   "email":    "maria@email.com",
     *   "password": "miPassword123"
     * }
     *
     * JSON de respuesta exitosa:
     * {
     *   "error":  false,
     *   "nombre": "María",
     *   "rol":    "CLIENTE",
     *   "mensaje":"Login exitoso"
     * }
     */
    private void manejarLogin(HttpServletRequest request,
                               HttpServletResponse response,
                               PrintWriter out)
            throws IOException {

        try {
            // Leer JSON del cuerpo
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }

            // Convertir a Map para leer email y password por separado
            // No usamos la clase Usuario aquí porque el campo se llama
            // "password" en el JSON pero "passwordHash" en la clase
            @SuppressWarnings("unchecked")
            Map<String, String> credenciales = gson.fromJson(
                sb.toString(), Map.class);

            String email    = credenciales.get("email");
            String password = credenciales.get("password");

            // Validación básica
            if (email == null || password == null ||
                email.isEmpty() || password.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(
                    crearError("Email y contraseña son obligatorios")));
                return;
            }

            // Verificar credenciales en la BD
            // El DAO encripta el password y compara con el hash guardado
            Usuario usuario = usuarioDAO.login(email, password);

            if (usuario == null) {
                // Credenciales incorrectas
                // Usamos 401 Unauthorized — estándar para login fallido
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print(gson.toJson(
                    crearError("Email o contraseña incorrectos")));
                return;
            }

            // ── Login exitoso → crear sesión ──────────────
            // HttpSession es el objeto que Tomcat usa para recordar
            // al usuario entre peticiones
            // true = crear nueva sesión si no existe
            HttpSession sesion = request.getSession(true);

            // Guardamos en la sesión los datos que necesitaremos
            // en cada petición siguiente
            sesion.setAttribute("usuarioId", usuario.getId());
            sesion.setAttribute("nombre",    usuario.getNombre());
            sesion.setAttribute("email",     usuario.getEmail());
            sesion.setAttribute("rol",       usuario.getRol());

            // La sesión expira después de 30 minutos de inactividad
            sesion.setMaxInactiveInterval(30 * 60);

            // Construimos la respuesta con los datos del usuario
            // Sin incluir el passwordHash por seguridad
            Map<String, Object> respuesta = new HashMap<>();
            respuesta.put("error",   false);
            respuesta.put("mensaje", "Login exitoso");
            respuesta.put("nombre",  usuario.getNombreCompleto());
            respuesta.put("email",   usuario.getEmail());
            respuesta.put("rol",     usuario.getRol());
            respuesta.put("id",      usuario.getId());

            out.print(gson.toJson(respuesta));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(
                crearError("Error del servidor: " + e.getMessage())));
        }
    }

    /**
     * manejarLogout()
     *
     * Destruye la sesión activa del usuario.
     * Después de esto el usuario tendrá que hacer login de nuevo.
     */
    private void manejarLogout(HttpServletRequest request,
                                HttpServletResponse response,
                                PrintWriter out) {

        // getSession(false) = obtener sesión existente sin crear una nueva
        // Si devuelve null, no había sesión activa
        HttpSession sesion = request.getSession(false);

        if (sesion != null) {
            // invalidate() destruye la sesión y borra todos sus datos
            sesion.invalidate();
        }

        out.print(gson.toJson(crearExito("Sesión cerrada correctamente")));
    }

    /**
     * manejarVerificarSesion()
     *
     * Verifica si hay una sesión activa y devuelve los datos
     * del usuario logueado.
     *
     * El frontend llama a este endpoint al cargar cada página
     * para saber si mostrar el menú de usuario o el de login.
     */
    private void manejarVerificarSesion(HttpServletRequest request,
                                         HttpServletResponse response,
                                         PrintWriter out) {

        HttpSession sesion = request.getSession(false);

        if (sesion == null || 
            sesion.getAttribute("usuarioId") == null) {
            // No hay sesión activa
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(crearError("No hay sesión activa")));
            return;
        }

        // Hay sesión activa — devolvemos los datos del usuario
        Map<String, Object> respuesta = new HashMap<>();
        respuesta.put("error",      false);
        respuesta.put("usuarioId",  sesion.getAttribute("usuarioId"));
        respuesta.put("nombre",     sesion.getAttribute("nombre"));
        respuesta.put("email",      sesion.getAttribute("email"));
        respuesta.put("rol",        sesion.getAttribute("rol"));

        out.print(gson.toJson(respuesta));
    }

    /**
     * doOptions()
     * Responde peticiones CORS preflight del navegador.
     */
    @Override
    protected void doOptions(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods",
            "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers",
            "Content-Type");
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    // ── Métodos de utilidad ────────────────────────────────────

    private Map<String, Object> crearError(String mensaje) {
        Map<String, Object> error = new HashMap<>();
        error.put("error",   true);
        error.put("mensaje", mensaje);
        return error;
    }

    private Map<String, Object> crearExito(String mensaje) {
        Map<String, Object> respuesta = new HashMap<>();
        respuesta.put("error",   false);
        respuesta.put("mensaje", mensaje);
        return respuesta;
    }

    private void manejarListarUsuarios(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        
    // Verificar que sea ADMIN
    HttpSession sesion = request.getSession(false);
    if (sesion == null ||
        !"ADMIN".equals(sesion.getAttribute("rol"))) {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        out.print(gson.toJson(crearError("Acceso denegado")));
        return;
    }

    try {
        List<com.puertomagico.modelo.Usuario> usuarios =
            usuarioDAO.listarTodos();
        out.print(gson.toJson(usuarios));

    } catch (Exception e) {
        response.setStatus(
            HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print(gson.toJson(
            crearError("Error: " + e.getMessage())));
    }
}    
    
    
    
   
    
    
} 