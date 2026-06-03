package com.puertomagico.servlet;

import com.google.gson.Gson;
import com.puertomagico.dao.PaqueteDAO;
import com.puertomagico.modelo.Paquete;
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
/**
 * PaqueteServlet.java
 *
 * Maneja las peticiones del catalogo de paquetes turisticos.
 *
 * Rutas disponibles:
 *   GET /api/paquetes           → Lista todos los paquetes activos
 *   GET /api/paquetes?id=1      → Detalle de un paquete
 *   GET /api/paquetes?cat=PLAYA → Filtra por categoria
 *   POST /api/paquetes          → Crea un paquete nuevo (solo ADMIN)
 */
@WebServlet("/api/paquetes/*")
public class PaqueteServlet extends HttpServlet {

    private PaqueteDAO paqueteDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        paqueteDAO = new PaqueteDAO();
        gson       = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        try {
            String paramId  = request.getParameter("id");
            String paramCat = request.getParameter("cat");

            if (paramId != null) {
                // Detalle de un paquete especifico
                Integer id      = Integer.parseInt(paramId);
                Paquete paquete = paqueteDAO.buscarPorId(id);

                if (paquete != null) {
                    out.print(gson.toJson(paquete));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(
                        crearError("Paquete no encontrado")));
                }

            } else if (paramCat != null) {
                // Filtrar por categoria
                List<Paquete> paquetes =
                    paqueteDAO.listarPorCategoria(paramCat);
                out.print(gson.toJson(paquetes));

            } else {
                // Todos los paquetes activos
                List<Paquete> paquetes = paqueteDAO.listarActivos();
                out.print(gson.toJson(paquetes));
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(crearError("ID invalido")));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(crearError("Error: " + e.getMessage())));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        // Solo ADMIN puede crear paquetes
        if (!verificarAdmin(request, response, out)) return;

        try {
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }

            Paquete paquete = gson.fromJson(sb.toString(), Paquete.class);

            // Validaciones basicas
            if (paquete.getNombre() == null ||
                paquete.getNombre().trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(crearError("El nombre es obligatorio")));
                return;
            }

            if (paquete.getPrecioBase() == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(crearError("El precio es obligatorio")));
                return;
            }

            boolean exito = paqueteDAO.insertar(paquete);

            if (exito) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.print(gson.toJson(crearExito("Paquete creado correctamente")));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(crearError("No se pudo crear el paquete")));
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

    private boolean verificarAdmin(HttpServletRequest request,
                                    HttpServletResponse response,
                                    PrintWriter out) {
        HttpSession sesion = request.getSession(false);
        if (sesion == null || sesion.getAttribute("usuarioId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(crearError("Debes iniciar sesion")));
            return false;
        }
        if (!"ADMIN".equals(sesion.getAttribute("rol"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print(gson.toJson(crearError("Acceso denegado")));
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