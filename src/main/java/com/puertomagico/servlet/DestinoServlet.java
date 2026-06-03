package com.puertomagico.servlet;

import com.google.gson.Gson;
import com.puertomagico.dao.DestinoDAO;
import com.puertomagico.modelo.Destino;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.annotation.WebServlet;

/*
 * Responde peticiones relacionadas con destinos.
 *
 * GET /api/destinos   Lista todos los destinos activos
 *                           con su conteo de tours
 * GET /api/destinos?id=1   Detalle de un destino específico
 */
@WebServlet("/api/destinos/*")
public class DestinoServlet extends HttpServlet {

    private DestinoDAO destinoDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        destinoDAO = new DestinoDAO();
        gson       = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");

        PrintWriter out = response.getWriter();

        try {
            String paramId = request.getParameter("id");

            if (paramId != null) {
                // ── Buscar por ID ──────────────────────
                Integer id = Integer.parseInt(paramId);
                Destino destino = destinoDAO.buscarPorId(id);

                if (destino != null) {
                    out.print(gson.toJson(destino));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(
                        crearError("Destino no encontrado")));
                }

            } else {
                // ── Listar todos con conteo de tours ───
                List<Destino> destinos = destinoDAO.listarActivos();

                // Creamos una lista de Maps para agregar
                // el conteo de tours a cada destino
                List<Map<String, Object>> resultado = new ArrayList<>();

                for (Destino d : destinos) {
                    int numTours = destinoDAO
                        .contarToursPorDestino(d.getId());

                    Map<String, Object> item = new HashMap<>();
                    item.put("id",          d.getId());
                    item.put("nombre",      d.getNombre());
                    item.put("estado",      d.getEstado());
                    item.put("descripcion", d.getDescripcion());
                    item.put("numTours",    numTours);

                    resultado.add(item);
                }

                out.print(gson.toJson(resultado));
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(crearError("ID inválido")));
        } catch (Exception e) {
            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(
                crearError("Error: " + e.getMessage())));
        }
    }

    private Map<String, Object> crearError(String mensaje) {
        Map<String, Object> error = new HashMap<>();
        error.put("error",   true);
        error.put("mensaje", mensaje);
        return error;
    }
}