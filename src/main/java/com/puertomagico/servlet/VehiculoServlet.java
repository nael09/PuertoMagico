package com.puertomagico.servlet;

import com.google.gson.Gson;
import com.puertomagico.dao.VehiculoDAO;
import com.puertomagico.modelo.Vehiculo;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * VehiculoServlet.java
 *
 * Devuelve la lista de vehiculos disponibles.
 * Lo usa el panel admin para llenar el select
 * de vehiculos al crear o editar un tour.
 *
 * GET /api/vehiculos     → lista todos los vehiculos
 * GET /api/vehiculos?id=1 → busca un vehiculo por ID
 */
@WebServlet("/api/vehiculos")
public class VehiculoServlet extends HttpServlet {

    private VehiculoDAO vehiculoDAO;
    private Gson        gson;

    @Override
    public void init() throws ServletException {
        vehiculoDAO = new VehiculoDAO();
        gson        = new Gson();
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
                // Buscar vehiculo por ID
                Vehiculo v = vehiculoDAO.buscarPorId(
                    Integer.parseInt(paramId));
                if (v != null) {
                    out.print(gson.toJson(v));
                } else {
                    response.setStatus(
                        HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(crearError(
                        "Vehiculo no encontrado")));
                }
            } else {
                // Listar todos los vehiculos
                List<Vehiculo> vehiculos =
                    vehiculoDAO.listarTodos();
                out.print(gson.toJson(vehiculos));
            }

        } catch (Exception e) {
            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(
                crearError("Error: " + e.getMessage())));
        }
    }

    @Override
    protected void doOptions(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods",
            "GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers",
            "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private java.util.Map<String, Object> crearError(String msg) {
        java.util.Map<String, Object> err = new java.util.HashMap<>();
        err.put("error",   true);
        err.put("mensaje", msg);
        return err;
    }
}