package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.Resena;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/*
  Maneja las opiniones de los clientes sobre tours y paquetes.
  Un cliente solo puede resenar un servicio si lo ha reservado
  y esa logica se verifica en el Servlet antes de llamar al DAO.
 */
public class ResenaDAO {

    /*
      Guarda una resena nueva en la BD.
      La calificacion debe ser del 1 al 5
      (validado por CHECK CONSTRAINT en PostgreSQL).
     */
    public boolean insertar(Resena resena) {

        Connection conexion = null;

        String sql = "INSERT INTO resenas " +
                     "(usuario_id, tour_id, paquete_id, " +
                     "calificacion, comentario, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);

            stmt.setInt(1, resena.getUsuarioId());

            // tourId o paqueteId — uno de los dos sera null
            if (resena.getTourId() != null) {
                stmt.setInt(2, resena.getTourId());
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }

            if (resena.getPaqueteId() != null) {
                stmt.setInt(3, resena.getPaqueteId());
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }

            stmt.setShort(4, resena.getCalificacion());
            stmt.setString(5, resena.getComentario());
            stmt.setTimestamp(6,
                Timestamp.valueOf(LocalDateTime.now()));

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al insertar resena: "
                + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /*
      listarPorTour()
      Trae todas las resenas de un tour ordenadas
      de la mas reciente a la mas antigua.
      Incluye el nombre del usuario con un JOIN.
     */
    public List<Resena> listarPorTour(Integer tourId) {

        List<Resena> lista = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT r.id, r.usuario_id, r.tour_id, " +
                     "r.paquete_id, r.calificacion, r.comentario, " +
                     "r.created_at, " +
                     "u.nombre || ' ' || u.apellido AS nombre_usuario " +
                     "FROM resenas r " +
                     "JOIN usuarios u ON r.usuario_id = u.id " +
                     "WHERE r.tour_id = ? " +
                     "ORDER BY r.created_at DESC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, tourId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                lista.add(mapearResena(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar resenas: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return lista;
    }

    /**
     * listarPorPaquete()
     * Igual que listarPorTour pero para paquetes.
     */
    public List<Resena> listarPorPaquete(Integer paqueteId) {

        List<Resena> lista  = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT r.id, r.usuario_id, r.tour_id, " +
                     "r.paquete_id, r.calificacion, r.comentario, " +
                     "r.created_at, " +
                     "u.nombre || ' ' || u.apellido AS nombre_usuario " +
                     "FROM resenas r " +
                     "JOIN usuarios u ON r.usuario_id = u.id " +
                     "WHERE r.paquete_id = ? " +
                     "ORDER BY r.created_at DESC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, paqueteId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                lista.add(mapearResena(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar resenas paquete: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return lista;
    }

    /**
     * promedioCalificacion()
     * Calcula el promedio de estrellas de un tour.
     * Lo mostramos en la ficha del tour junto a las resenas.
     * Devuelve 0.0 si no hay resenas todavia.
     */
    public double promedioCalificacion(Integer tourId) {

        Connection conexion = null;
        double promedio     = 0.0;

        String sql = "SELECT AVG(calificacion) AS promedio " +
                     "FROM resenas WHERE tour_id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, tourId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next() && rs.getObject("promedio") != null) {
                promedio = rs.getDouble("promedio");
            }

        } catch (SQLException e) {
            System.err.println("Error al calcular promedio: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return promedio;
    }

    /**
     * existeResena()
     * Verifica si un usuario ya reseno un tour.
     * Evita que el mismo cliente publique dos resenas
     * del mismo tour.
     */
    public boolean existeResena(Integer usuarioId, Integer tourId) {

        Connection conexion = null;
        boolean existe      = false;

        String sql = "SELECT COUNT(*) AS total FROM resenas " +
                     "WHERE usuario_id = ? AND tour_id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, usuarioId);
            stmt.setInt(2, tourId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                existe = rs.getInt("total") > 0;
            }

        } catch (SQLException e) {
            System.err.println("Error al verificar resena: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return existe;
    }

    /**
     * mapearResena()
     * Metodo privado que convierte una fila del ResultSet
     * en un objeto Resena. Lo reutilizamos en listarPorTour
     * y listarPorPaquete para no repetir el mismo codigo.
     */
    private Resena mapearResena(ResultSet rs) throws SQLException {
        Resena r = new Resena();
        r.setId(rs.getInt("id"));
        r.setUsuarioId(rs.getInt("usuario_id"));

        int tourId = rs.getInt("tour_id");
        if (!rs.wasNull()) r.setTourId(tourId);

        int paqueteId = rs.getInt("paquete_id");
        if (!rs.wasNull()) r.setPaqueteId(paqueteId);

        r.setCalificacion(rs.getShort("calificacion"));
        r.setComentario(rs.getString("comentario"));
        r.setNombreUsuario(rs.getString("nombre_usuario"));

        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            r.setCreatedAt(ts.toLocalDateTime());
        }

        return r;
    }
}