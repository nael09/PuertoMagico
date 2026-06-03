package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.Asiento;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


public class AsientoDAO {

    /* Trae todos los asientos de un tour específico.
      Lo usamos para renderizar el mapa visual de asientos
      en la pantalla de selección.
     */
    public List<Asiento> listarPorTour(Integer tourId) {

        List<Asiento> asientos = new ArrayList<>();
        Connection conexion = null;

        // Ordenamos por número para que el mapa se dibuje en orden
        String sql = "SELECT id, tour_id, vehiculo_id, reserva_id, " +
                     "numero, tipo, precio_extra, estado, bloqueado_hasta " +
                     "FROM asientos " +
                     "WHERE tour_id = ? " +
                     "ORDER BY numero ASC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, tourId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Asiento asiento = new Asiento();
                asiento.setId(rs.getInt("id"));
                asiento.setTourId(rs.getInt("tour_id"));
                asiento.setVehiculoId(rs.getInt("vehiculo_id"));

                // reserva_id puede ser null si el asiento está disponible
                // getObject devuelve null si la columna es NULL en la BD
                // en lugar de lanzar una excepción como getInt
                int reservaId = rs.getInt("reserva_id");
                if (!rs.wasNull()) {
                    asiento.setReservaId(reservaId);
                }

                asiento.setNumero(rs.getString("numero"));
                asiento.setTipo(rs.getString("tipo"));
                asiento.setPrecioExtra(rs.getBigDecimal("precio_extra"));
                asiento.setEstado(rs.getString("estado"));

                // bloqueado_hasta puede ser null si está disponible
                Timestamp ts = rs.getTimestamp("bloqueado_hasta");
                if (ts != null) {
                    asiento.setBloqueadoHasta(ts.toLocalDateTime());
                }

                asientos.add(asiento);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar asientos: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return asientos;
    }
    
    /*
      Intenta bloquear un asiento para un usuario que está
      iniciando el proceso de pago.
  
      Usamos una TRANSACCIÓN con estos pasos:
      
        1. BEGIN  iniciamos la transacción
        2. SELECT FOR UPDATE bloqueamos la fila del asiento
           (ningún otro usuario puede tocarla hasta que terminemos)
        3. Verificamos que el asiento siga DISPONIBLE
        4. Si está disponible  lo marcamos EN_PROCESO
        5. COMMIT confirmamos la transacción y liberamos el bloqueo
        6. Si algo falla  ROLLBACK  deshacemos todo
      
      ¿Por qué esto funciona?
      SELECT FOR UPDATE le dice a PostgreSQL: "nadie más puede
      modificar esta fila mientras yo la estoy usando".
      Si dos usuarios intentan bloquear el mismo asiento al mismo
      tiempo, PostgreSQL los pone en cola uno espera al otro.
      El primero lo bloquea, el segundo llega y ve que ya no está
      DISPONIBLE, entonces falla limpiamente.
      
     */
    public boolean bloquearAsiento(Integer asientoId) {

        Connection conexion = null;

        try {
            conexion = ConexionDB.getConexion();

            // PASO 1: Desactivar el autocommit para manejar la transacción
            // Por defecto Java hace COMMIT después de cada operación
            // Con false, nosotros controlamos cuándo hacer COMMIT o ROLLBACK
            conexion.setAutoCommit(false);

            // PASO 2: SELECT FOR UPDATE  lee el asiento Y lo bloquea
            // Ningún otro hilo puede modificar esta fila hasta que
            // hagamos COMMIT o ROLLBACK
            String sqlSelect = "SELECT estado FROM asientos " +
                               "WHERE id = ? FOR UPDATE";

            PreparedStatement stmtSelect = conexion.prepareStatement(sqlSelect);
            stmtSelect.setInt(1, asientoId);
            ResultSet rs = stmtSelect.executeQuery();

            if (!rs.next()) {
                // El asiento no existe
                conexion.rollback();
                return false;
            }

            String estadoActual = rs.getString("estado");

            // PASO 3: Verificar que siga disponible
            if (!"DISPONIBLE".equals(estadoActual)) {
                // Ya no está disponible — otro usuario lo tomó primero
                // ROLLBACK libera el bloqueo FOR UPDATE
                conexion.rollback();
                return false;
            }

            // PASO 4: Cambiar estado a EN_PROCESO con tiempo de expiración
            // LocalDateTime.now().plusMinutes(10) = 10 minutos desde ahora
            String sqlUpdate = "UPDATE asientos SET " +
                               "estado = 'EN_PROCESO', " +
                               "bloqueado_hasta = ? " +
                               "WHERE id = ?";

            PreparedStatement stmtUpdate = conexion.prepareStatement(sqlUpdate);

            // Calculamos el tiempo de expiración: ahora + 10 minutos
            LocalDateTime expiracion = LocalDateTime.now().plusMinutes(10);
            stmtUpdate.setTimestamp(1, Timestamp.valueOf(expiracion));
            stmtUpdate.setInt(2, asientoId);
            stmtUpdate.executeUpdate();

            // PASO 5: COMMIT  confirmamos los cambios y liberamos el bloqueo
            conexion.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al bloquear asiento: " + e.getMessage());
            try {
                // Si algo falló, deshacemos todos los cambios de la transacción
                if (conexion != null) conexion.rollback();
            } catch (SQLException ex) {
                System.err.println("Error en rollback: " + ex.getMessage());
            }
            return false;
        } finally {
            try {
                // Restauramos el autocommit antes de devolver la conexión
                if (conexion != null) conexion.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("Error al restaurar autocommit: " 
                    + e.getMessage());
            }
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /*
      Cambia el estado de EN_PROCESO a RESERVADO cuando
      el pago fue exitoso.
     */
    public boolean confirmarAsiento(Integer asientoId, Integer reservaId) {

        Connection conexion = null;

        String sql = "UPDATE asientos SET " +
                     "estado = 'RESERVADO', " +
                     "reserva_id = ?, " +
                     "bloqueado_hasta = NULL " +
                     "WHERE id = ? AND estado = 'EN_PROCESO'";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, reservaId);
            stmt.setInt(2, asientoId);

            int filasAfectadas = stmt.executeUpdate();

            // Si filasAfectadas = 0, el asiento ya no estaba EN_PROCESO
            // (expiró o alguien lo liberó) — la confirmación falló
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al confirmar asiento: " + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /*
      Regresa un asiento a DISPONIBLE.
      Se llama cuando:
        - El pago falló
        - El cliente canceló
        - El scheduler detectó que el bloqueo expiró
     */
    public boolean liberarAsiento(Integer asientoId) {

        Connection conexion = null;

        String sql = "UPDATE asientos SET " +
                     "estado = 'DISPONIBLE', " +
                     "reserva_id = NULL, " +
                     "bloqueado_hasta = NULL " +
                     "WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, asientoId);
            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al liberar asiento: " + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /* Libera TODOS los asientos EN_PROCESO cuyo tiempo
      de bloqueo ya venció.
      
      Este método lo llamará el Servlet de mantenimiento
      periódicamente para limpiar asientos bloqueados
      que nadie completó el pago. 
      Ejemplo: si alguien bloqueó el asiento 5 a las 14:00
      y son las 14:11 sin que pagara → este método lo libera.
     */
    public int liberarAsientosExpirados() {

        Connection conexion = null;
        int asientosLiberados = 0;

        // NOW() en PostgreSQL = fecha y hora actual del servidor
        // Libera todos los asientos EN_PROCESO cuyo bloqueado_hasta
        // ya es menor que la hora actual
        String sql = "UPDATE asientos SET " +
                     "estado = 'DISPONIBLE', " +
                     "reserva_id = NULL, " +
                     "bloqueado_hasta = NULL " +
                     "WHERE estado = 'EN_PROCESO' " +
                     "AND bloqueado_hasta < NOW()";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);

            // executeUpdate devuelve cuántas filas fueron modificadas
            asientosLiberados = stmt.executeUpdate();

            if (asientosLiberados > 0) {
                System.out.println("[Mantenimiento] Se liberaron " 
                    + asientosLiberados + " asiento(s) expirados.");
            }

        } catch (SQLException e) {
            System.err.println("Error al liberar expirados: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return asientosLiberados;
    }

    /*
      Cuenta cuántos asientos disponibles tiene un tour.
      Lo usamos para mostrar el badge "X lugares disponibles"
      en las tarjetas del catálogo.
     */
    public int contarDisponibles(Integer tourId) {

        Connection conexion = null;
        int total = 0;

        String sql = "SELECT COUNT(*) AS total FROM asientos " +
                     "WHERE tour_id = ? AND estado = 'DISPONIBLE'";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, tourId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total");
            }

        } catch (SQLException e) {
            System.err.println("Error al contar disponibles: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return total;
    }
}