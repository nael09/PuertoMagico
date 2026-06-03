package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.ParadaTour;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

/*
  Consultas SQL para la tabla "paradas_tour".
  Maneja el itinerario detallado de cada tour.
 */
public class ParadaTourDAO {

    /*
      Trae todas las paradas de un tour ordenadas por secuencia.
      Lo usamos para mostrar el itinerario en la ficha del tour.
     */
    public List<ParadaTour> listarPorTour(Integer tourId) {

        List<ParadaTour> lista = new ArrayList<>();
        Connection conexion    = null;

        String sql = "SELECT id, tour_id, orden, lugar, hora, " +
                     "duracion_min, precio_extra, opcional, descripcion " +
                     "FROM paradas_tour " +
                     "WHERE tour_id = ? " +
                     "ORDER BY orden ASC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, tourId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ParadaTour p = new ParadaTour();
                p.setId(rs.getInt("id"));
                p.setTourId(rs.getInt("tour_id"));
                p.setOrden(rs.getInt("orden"));
                p.setLugar(rs.getString("lugar"));

                // La hora puede ser null si no esta definida
                Time hora = rs.getTime("hora");
                if (hora != null) {
                    p.setHora(hora.toLocalTime());
                }

                p.setDuracionMin(rs.getInt("duracion_min"));
                p.setPrecioExtra(rs.getBigDecimal("precio_extra"));
                p.setOpcional(rs.getBoolean("opcional"));
                p.setDescripcion(rs.getString("descripcion"));
                lista.add(p);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar paradas: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return lista;
    }

    /*
      Trae solo las paradas opcionales de un tour.
      Las usamos para calcular el precio extra
      cuando el cliente personaliza su itinerario.
     */
    public List<ParadaTour> listarOpcionalesPorTour(Integer tourId) {

        List<ParadaTour> lista = new ArrayList<>();
        Connection conexion    = null;

        String sql = "SELECT id, tour_id, orden, lugar, hora, " +
                     "duracion_min, precio_extra, opcional, descripcion " +
                     "FROM paradas_tour " +
                     "WHERE tour_id = ? AND opcional = true " +
                     "ORDER BY orden ASC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, tourId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ParadaTour p = new ParadaTour();
                p.setId(rs.getInt("id"));
                p.setTourId(rs.getInt("tour_id"));
                p.setOrden(rs.getInt("orden"));
                p.setLugar(rs.getString("lugar"));

                Time hora = rs.getTime("hora");
                if (hora != null) {
                    p.setHora(hora.toLocalTime());
                }

                p.setDuracionMin(rs.getInt("duracion_min"));
                p.setPrecioExtra(rs.getBigDecimal("precio_extra"));
                p.setOpcional(rs.getBoolean("opcional"));
                p.setDescripcion(rs.getString("descripcion"));
                lista.add(p);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar opcionales: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return lista;
    }

    /*
      Agrega una parada nueva al itinerario de un tour.
      Solo el admin puede agregar paradas.
     */
    public boolean insertar(ParadaTour parada) {

        Connection conexion = null;

        String sql = "INSERT INTO paradas_tour " +
                     "(tour_id, orden, lugar, hora, duracion_min, " +
                     "precio_extra, opcional, descripcion) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, parada.getTourId());
            stmt.setInt(2, parada.getOrden());
            stmt.setString(3, parada.getLugar());

            // Convertimos LocalTime a java.sql.Time para PostgreSQL
            if (parada.getHora() != null) {
                stmt.setTime(4, Time.valueOf(parada.getHora()));
            } else {
                stmt.setNull(4, java.sql.Types.TIME);
            }

            stmt.setInt(5, parada.getDuracionMin() != null
                ? parada.getDuracionMin() : 0);
            stmt.setBigDecimal(6, parada.getPrecioExtra());
            stmt.setBoolean(7, parada.getOpcional() != null
                ? parada.getOpcional() : false);
            stmt.setString(8, parada.getDescripcion());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al insertar parada: "
                + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /*
      Elimina una parada del itinerario.
      A diferencia de los tours, las paradas si se borran
      fisicamente porque no tienen historial propio.
     */
    public boolean eliminar(Integer id) {

        Connection conexion = null;
        String sql = "DELETE FROM paradas_tour WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar parada: "
                + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }
}