package com.puertomagico.servlet;

import com.google.gson.Gson;
import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.dao.DestinoDAO;
import com.puertomagico.modelo.Destino;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * DestinoServlet.java
 *
 * Maneja peticiones de la tabla destinos.
 *
 * GET  /api/destinos        → lista todos con conteo de tours
 * GET  /api/destinos?id=1   → detalle de un destino
 * POST /api/destinos        → crea un destino nuevo (solo ADMIN)
 */
@WebServlet("/api/destinos/*")
public class DestinoServlet extends HttpServlet {

    private DestinoDAO destinoDAO;
    private Gson       gson;

    @Override
    public void init() throws ServletException {
        destinoDAO = new DestinoDAO();
        gson       = new Gson();
    }

    // ── GET ────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        try {
            String paramId = request.getParameter("id");

            if (paramId != null) {
                // Buscar destino por ID
                Integer id      = Integer.parseInt(paramId);
                Destino destino = destinoDAO.buscarPorId(id);

                if (destino != null) {
                    out.print(gson.toJson(destino));
                } else {
                    response.setStatus(
                        HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(
                        crearError("Destino no encontrado")));
                }

            } else {
                // Listar todos con conteo de tours
                List<Destino> destinos = destinoDAO.listarActivos();
                List<Map<String, Object>> resultado = new ArrayList<>();

                for (Destino d : destinos) {
                    int numTours = destinoDAO
                        .contarToursPorDestino(d.getId());

                    Map<String, Object> item = new HashMap<>();
                    item.put("id",          d.getId());
                    item.put("nombre",      d.getNombre());
                    item.put("estado",      d.getEstado());
                    item.put("descripcion", d.getDescripcion());
                    item.put("activo",      d.getActivo());
                    item.put("numTours",    numTours);
                    resultado.add(item);
                }

                out.print(gson.toJson(resultado));
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(crearError("ID invalido")));
        } catch (Exception e) {
            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(
                crearError("Error: " + e.getMessage())));
        }
    }

    // ── POST ───────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        // Solo ADMIN puede crear destinos
        HttpSession sesion = request.getSession(false);
        if (sesion == null ||
            !"ADMIN".equals(sesion.getAttribute("rol"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print(gson.toJson(crearError("Acceso denegado")));
            return;
        }

        try {
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }

            Destino destino = gson.fromJson(
                sb.toString(), Destino.class);

            if (destino.getNombre() == null ||
                destino.getNombre().trim().isEmpty()) {
                response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(
                    crearError("Nombre obligatorio")));
                return;
            }

            // Insertar en la BD
            Connection conexion = null;
            try {
                conexion = ConexionDB.getConexion();
                String sql = "INSERT INTO destinos " +
                    "(nombre, estado, descripcion, activo) " +
                    "VALUES (?, ?, ?, true)";
                PreparedStatement stmt =
                    conexion.prepareStatement(sql);
                stmt.setString(1, destino.getNombre().trim());
                stmt.setString(2, destino.getEstado());
                stmt.setString(3, destino.getDescripcion());
                stmt.executeUpdate();

                response.setStatus(
                    HttpServletResponse.SC_CREATED);
                out.print(gson.toJson(crearExito(
                    "Destino creado correctamente")));

            } finally {
                ConexionDB.cerrarConexion(conexion);
            }

        } catch (Exception e) {
            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(
                crearError("Error: " + e.getMessage())));
        }
    }

    // ── OPTIONS (CORS) ─────────────────────────────────────

    @Override
    protected void doOptions(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods",
            "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers",
            "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    // ── UTILIDADES ─────────────────────────────────────────

    /**
     * configurarRespuesta()
     * Establece los headers JSON y CORS en la respuesta.
     */
    private void configurarRespuesta(HttpServletResponse response) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
    }

    /**
     * crearError()
     * Devuelve un Map con error=true para respuestas fallidas.
     */
    private Map<String, Object> crearError(String mensaje) {
        Map<String, Object> err = new HashMap<>();
        err.put("error",   true);
        err.put("mensaje", mensaje);
        return err;
    }

    /**
     * crearExito()
     * Devuelve un Map con error=false para respuestas exitosas.
     */
    private Map<String, Object> crearExito(String mensaje) {
        Map<String, Object> ok = new HashMap<>();
        ok.put("error",   false);
        ok.put("mensaje", mensaje);
        return ok;
    }
}