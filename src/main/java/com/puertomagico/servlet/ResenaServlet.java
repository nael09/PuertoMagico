package com.puertomagico.servlet;

import com.google.gson.Gson;
import com.puertomagico.dao.ResenaDAO;
import com.puertomagico.modelo.Resena;
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
 * ResenaServlet.java
 *
 * Maneja las resenas de tours y paquetes.
 * Solo pueden publicar resenas los clientes que
 * tengan una reserva de ese servicio.
 *
 * Rutas disponibles:
 *   GET  /api/resenas?tourId=1    → Lista resenas de un tour
 *   GET  /api/resenas?paqueteId=1 → Lista resenas de un paquete
 *   POST /api/resenas             → Publica una resena nueva
 */
@WebServlet("/api/resenas/*")
public class ResenaServlet extends HttpServlet {

    private ResenaDAO resenaDAO;
    private Gson      gson;

    @Override
    public void init() throws ServletException {
        resenaDAO = new ResenaDAO();
        gson      = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        try {
            String paramTourId    = request.getParameter("tourId");
            String paramPaqueteId = request.getParameter("paqueteId");

            if (paramTourId != null) {
                // Resenas de un tour especifico
                Integer tourId         = Integer.parseInt(paramTourId);
                List<Resena> resenas   = resenaDAO.listarPorTour(tourId);
                double promedio        = resenaDAO.promedioCalificacion(tourId);

                // Devolvemos las resenas y el promedio juntos
                Map<String, Object> resp = new HashMap<>();
                resp.put("resenas",  resenas);
                resp.put("promedio", Math.round(promedio * 10.0) / 10.0);
                resp.put("total",    resenas.size());
                out.print(gson.toJson(resp));

            } else if (paramPaqueteId != null) {
                // Resenas de un paquete especifico
                Integer paqueteId    = Integer.parseInt(paramPaqueteId);
                List<Resena> resenas = resenaDAO.listarPorPaquete(paqueteId);
                out.print(gson.toJson(resenas));

            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(
                    crearError("Especifica tourId o paqueteId")));
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
     * doPost()
     *
     * Publica una resena nueva.
     * Verifica que el usuario no haya resenado ese tour antes.
     *
     * JSON esperado:
     * {
     *   "tourId":       1,
     *   "calificacion": 5,
     *   "comentario":   "Excelente experiencia"
     * }
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        PrintWriter out = response.getWriter();

        // Solo usuarios con sesion pueden publicar resenas
        if (!verificarSesion(request, response, out)) return;

        try {
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null) {
                sb.append(linea);
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> datos = gson.fromJson(
                sb.toString(), Map.class);

            // Obtenemos el ID del usuario logueado desde la sesion
            HttpSession sesion  = request.getSession(false);
            Integer usuarioId   = (Integer) sesion.getAttribute("usuarioId");

            // Calificacion y comentario del JSON
            Short calificacion  = ((Double) datos.get("calificacion"))
                .shortValue();
            String comentario   = (String) datos.get("comentario");

            // Validar que la calificacion sea del 1 al 5
            if (calificacion < 1 || calificacion > 5) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(
                    crearError("La calificacion debe ser del 1 al 5")));
                return;
            }

            Resena resena = new Resena();
            resena.setUsuarioId(usuarioId);
            resena.setCalificacion(calificacion);
            resena.setComentario(comentario);

            // Determinamos si es resena de tour o de paquete
            if (datos.get("tourId") != null) {
                Integer tourId = ((Double) datos.get("tourId")).intValue();

                // Verificamos que no haya resenado este tour antes
                if (resenaDAO.existeResena(usuarioId, tourId)) {
                    response.setStatus(HttpServletResponse.SC_CONFLICT);
                    out.print(gson.toJson(
                        crearError("Ya publicaste una resena de este tour")));
                    return;
                }

                resena.setTourId(tourId);

            } else if (datos.get("paqueteId") != null) {
                Integer paqueteId = ((Double) datos.get("paqueteId")).intValue();
                resena.setPaqueteId(paqueteId);

            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(
                    crearError("Especifica tourId o paqueteId")));
                return;
            }

            boolean exito = resenaDAO.insertar(resena);

            if (exito) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.print(gson.toJson(
                    crearExito("Resena publicada correctamente")));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(crearError("No se pudo publicar la resena")));
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