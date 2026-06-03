package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.Paquete;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * PaqueteDAO.java
 *
 * Maneja todas las consultas SQL de la tabla "paquetes".
 * Los paquetes son tours de varios dias todo incluido.
 */
public class PaqueteDAO {

    /**
     * listarActivos()
     * Trae todos los paquetes disponibles para reservar.
     * Ordenados por precio para facilitar la comparacion.
     */
    public List<Paquete> listarActivos() {

        List<Paquete> lista = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT id, nombre, descripcion, duracion_dias, " +
                     "precio_base, cupo_maximo, categoria, activo " +
                     "FROM paquetes " +
                     "WHERE activo = true " +
                     "ORDER BY precio_base ASC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                lista.add(mapearPaquete(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar paquetes: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return lista;
    }

    /**
     * listarPorCategoria()
     * Filtra paquetes por categoria.
     * Categorias: PLAYA, CULTURAL, AVENTURA, ECO, CIUDAD
     */
    public List<Paquete> listarPorCategoria(String categoria) {

        List<Paquete> lista = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT id, nombre, descripcion, duracion_dias, " +
                     "precio_base, cupo_maximo, categoria, activo " +
                     "FROM paquetes " +
                     "WHERE categoria = ? AND activo = true " +
                     "ORDER BY precio_base ASC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setString(1, categoria.toUpperCase());
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                lista.add(mapearPaquete(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar por categoria: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return lista;
    }

    /**
     * buscarPorId()
     * Busca un paquete especifico por su ID.
     * Lo usamos para mostrar el detalle del paquete.
     */
    public Paquete buscarPorId(Integer id) {

        Connection conexion = null;
        Paquete paquete     = null;

        String sql = "SELECT id, nombre, descripcion, duracion_dias, " +
                     "precio_base, cupo_maximo, categoria, activo " +
                     "FROM paquetes WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                paquete = mapearPaquete(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar paquete: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return paquete;
    }

    /**
     * insertar()
     * Guarda un paquete nuevo en la BD.
     * Solo el admin puede llamar este metodo.
     */
    public boolean insertar(Paquete paquete) {

        Connection conexion = null;

        String sql = "INSERT INTO paquetes " +
                     "(nombre, descripcion, duracion_dias, precio_base, " +
                     "cupo_maximo, categoria, activo) " +
                     "VALUES (?, ?, ?, ?, ?, ?, true)";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setString(1, paquete.getNombre());
            stmt.setString(2, paquete.getDescripcion());
            stmt.setInt(3, paquete.getDuracionDias());
            stmt.setBigDecimal(4, paquete.getPrecioBase());
            stmt.setInt(5, paquete.getCupoMaximo());
            stmt.setString(6, paquete.getCategoria());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al insertar paquete: "
                + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /**
     * actualizar()
     * Modifica los datos de un paquete existente.
     */
    public boolean actualizar(Paquete paquete) {

        Connection conexion = null;

        String sql = "UPDATE paquetes SET " +
                     "nombre = ?, descripcion = ?, duracion_dias = ?, " +
                     "precio_base = ?, cupo_maximo = ?, categoria = ? " +
                     "WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setString(1, paquete.getNombre());
            stmt.setString(2, paquete.getDescripcion());
            stmt.setInt(3, paquete.getDuracionDias());
            stmt.setBigDecimal(4, paquete.getPrecioBase());
            stmt.setInt(5, paquete.getCupoMaximo());
            stmt.setString(6, paquete.getCategoria());
            stmt.setInt(7, paquete.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar paquete: "
                + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /**
     * desactivar()
     * Borrado logico — pone activo = false.
     * El paquete deja de aparecer en el catalogo
     * pero conserva su historial de reservas.
     */
    public boolean desactivar(Integer id) {

        Connection conexion = null;
        String sql = "UPDATE paquetes SET activo = false WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al desactivar paquete: "
                + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /**
     * mapearPaquete()
     * Metodo privado que convierte una fila del ResultSet
     * en un objeto Paquete. Lo reutilizamos en todos los
     * metodos para no repetir el mismo codigo de mapeo.
     * Principio DRY: Don't Repeat Yourself.
     */
    private Paquete mapearPaquete(ResultSet rs) throws SQLException {
        Paquete p = new Paquete();
        p.setId(rs.getInt("id"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setDuracionDias(rs.getInt("duracion_dias"));
        p.setPrecioBase(rs.getBigDecimal("precio_base"));
        p.setCupoMaximo(rs.getInt("cupo_maximo"));
        p.setCategoria(rs.getString("categoria"));
        p.setActivo(rs.getBoolean("activo"));
        return p;
    }
}