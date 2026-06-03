package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.PaqueteTour;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * PaqueteTourDAO.java
 * Maneja la relacion entre paquetes y tours.
 * Permite saber que tours incluye cada paquete
 * y en que dia y orden se realizan.
 */
public class PaqueteTourDAO {

    /**
     * listarPorPaquete()
     * Trae todos los tours de un paquete ordenados
     * por dia y secuencia para mostrar el itinerario.
     * Incluye el nombre del tour con un JOIN.
     */
    public List<PaqueteTour> listarPorPaquete(Integer paqueteId) {

        List<PaqueteTour> lista = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT pt.id, pt.paquete_id, pt.tour_id, " +
                     "pt.dia_numero, pt.orden, " +
                     "t.nombre AS nombre_tour " +
                     "FROM paquete_tours pt " +
                     "JOIN tours t ON pt.tour_id = t.id " +
                     "WHERE pt.paquete_id = ? " +
                     "ORDER BY pt.dia_numero ASC, pt.orden ASC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, paqueteId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                PaqueteTour pt = new PaqueteTour();
                pt.setId(rs.getInt("id"));
                pt.setPaqueteId(rs.getInt("paquete_id"));
                pt.setTourId(rs.getInt("tour_id"));
                pt.setDiaNumero(rs.getInt("dia_numero"));
                pt.setOrden(rs.getInt("orden"));
                pt.setNombreTour(rs.getString("nombre_tour"));
                lista.add(pt);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar paquete-tours: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return lista;
    }

    /**
     * agregarTour()
     * Agrega un tour a un paquete existente.
     * El admin lo usa para armar el itinerario del paquete.
     */
    public boolean agregarTour(PaqueteTour pt) {

        Connection conexion = null;

        String sql = "INSERT INTO paquete_tours " +
                     "(paquete_id, tour_id, dia_numero, orden) " +
                     "VALUES (?, ?, ?, ?)";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, pt.getPaqueteId());
            stmt.setInt(2, pt.getTourId());
            stmt.setInt(3, pt.getDiaNumero());
            stmt.setInt(4, pt.getOrden() != null ? pt.getOrden() : 1);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al agregar tour al paquete: "
                + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /**
     * eliminarTour()
     * Quita un tour de un paquete.
     * No borra el tour ni el paquete, solo la relacion.
     */
    public boolean eliminarTour(Integer paqueteId, Integer tourId) {

        Connection conexion = null;

        String sql = "DELETE FROM paquete_tours " +
                     "WHERE paquete_id = ? AND tour_id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, paqueteId);
            stmt.setInt(2, tourId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar tour del paquete: "
                + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }
}