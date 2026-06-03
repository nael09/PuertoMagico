package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.Destino;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DestinoDAO.java
 *
 * Maneja las consultas SQL de la tabla "destinos".
 * Lo usamos para cargar los destinos en la página principal
 * y en el panel de administración.
 */
public class DestinoDAO {

    /**
     * listarActivos()
     *
     * Trae todos los destinos activos de la BD.
     * Para cada destino también contamos cuántos tours tiene
     * para mostrarlo en las tarjetas de la página principal.
     */
    public List<Destino> listarActivos() {

        List<Destino> destinos = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT id, nombre, estado, descripcion, activo " +
                     "FROM destinos " +
                     "WHERE activo = true " +
                     "ORDER BY nombre ASC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Destino destino = new Destino();
                destino.setId(rs.getInt("id"));
                destino.setNombre(rs.getString("nombre"));
                destino.setEstado(rs.getString("estado"));
                destino.setDescripcion(rs.getString("descripcion"));
                destino.setActivo(rs.getBoolean("activo"));
                destinos.add(destino);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar destinos: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return destinos;
    }

    /**
     * contarToursPorDestino()
     *
     * Cuenta cuántos tours activos tiene un destino.
     * Lo mostramos en las tarjetas: "12 tours disponibles"
     *
     * @param destinoId — ID del destino
     * @return número de tours activos
     */
    public int contarToursPorDestino(Integer destinoId) {

        Connection conexion = null;
        int total = 0;

        String sql = "SELECT COUNT(*) AS total FROM tours " +
                     "WHERE destino_id = ? AND activo = true";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, destinoId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total");
            }

        } catch (SQLException e) {
            System.err.println("Error al contar tours: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return total;
    }

    /**
     * buscarPorId()
     *
     * Busca un destino específico por ID.
     *
     * @param id — ID del destino
     * @return Destino si existe, null si no
     */
    public Destino buscarPorId(Integer id) {

        Connection conexion = null;
        Destino destino = null;

        String sql = "SELECT id, nombre, estado, descripcion, activo " +
                     "FROM destinos WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                destino = new Destino();
                destino.setId(rs.getInt("id"));
                destino.setNombre(rs.getString("nombre"));
                destino.setEstado(rs.getString("estado"));
                destino.setDescripcion(rs.getString("descripcion"));
                destino.setActivo(rs.getBoolean("activo"));
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar destino: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return destino;
    }
}