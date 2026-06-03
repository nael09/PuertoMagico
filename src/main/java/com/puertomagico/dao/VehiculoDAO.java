package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.Vehiculo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/*
  Consultas SQL para la tabla "vehiculos".
  Los vehiculos definen el tipo de transporte
  y el layout del mapa de asientos de cada tour.
 */
public class VehiculoDAO {

    /*
      Trae todos los vehiculos registrados.
      Lo usa el admin para asignar vehiculo al crear un tour.
     */
    public List<Vehiculo> listarTodos() {

        List<Vehiculo> lista = new ArrayList<>();
        Connection conexion  = null;

        String sql = "SELECT id, tipo, capacidad, " +
                     "layout_mapa::text AS layout_mapa, descripcion " +
                     "FROM vehiculos ORDER BY tipo ASC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Vehiculo v = new Vehiculo();
                v.setId(rs.getInt("id"));
                v.setTipo(rs.getString("tipo"));
                v.setCapacidad(rs.getInt("capacidad"));
                // El layout es JSONB en la BD, lo leemos como texto
                v.setLayoutMapa(rs.getString("layout_mapa"));
                v.setDescripcion(rs.getString("descripcion"));
                lista.add(v);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar vehiculos: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return lista;
    }

    /*
      Busca un vehiculo por su ID.
      Lo usamos para cargar el layout del mapa de asientos
      cuando el cliente esta seleccionando su lugar.
     */
    public Vehiculo buscarPorId(Integer id) {

        Connection conexion = null;
        Vehiculo vehiculo   = null;

        String sql = "SELECT id, tipo, capacidad, " +
                     "layout_mapa::text AS layout_mapa, descripcion " +
                     "FROM vehiculos WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                vehiculo = new Vehiculo();
                vehiculo.setId(rs.getInt("id"));
                vehiculo.setTipo(rs.getString("tipo"));
                vehiculo.setCapacidad(rs.getInt("capacidad"));
                vehiculo.setLayoutMapa(rs.getString("layout_mapa"));
                vehiculo.setDescripcion(rs.getString("descripcion"));
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar vehiculo: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return vehiculo;
    }

    /*
      Filtra vehiculos por tipo: VAN, MINIBUS o AUTOBUS.
      Util para el admin cuando quiere ver solo las vans.
     */
    public List<Vehiculo> buscarPorTipo(String tipo) {

        List<Vehiculo> lista = new ArrayList<>();
        Connection conexion  = null;

        String sql = "SELECT id, tipo, capacidad, " +
                     "layout_mapa::text AS layout_mapa, descripcion " +
                     "FROM vehiculos WHERE tipo = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setString(1, tipo);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Vehiculo v = new Vehiculo();
                v.setId(rs.getInt("id"));
                v.setTipo(rs.getString("tipo"));
                v.setCapacidad(rs.getInt("capacidad"));
                v.setLayoutMapa(rs.getString("layout_mapa"));
                v.setDescripcion(rs.getString("descripcion"));
                lista.add(v);
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar por tipo: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return lista;
    }
}