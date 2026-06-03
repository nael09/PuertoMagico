package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.Reserva;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * ReservaDAO.java
 * 
 * Maneja todas las operaciones de base de datos relacionadas
 * con la tabla "reservas".
 * 
 * Este DAO tiene un método especial: crearReservaCompleta()
 * que usa una TRANSACCIÓN para hacer dos cosas al mismo tiempo:
 *   1. Insertar la reserva en la tabla "reservas"
 *   2. Confirmar los asientos en la tabla "asientos"
 * 
 * Si cualquiera de los dos falla, se deshace TODO.
 * Así nunca tendremos una reserva sin asientos confirmados
 * ni asientos confirmados sin reserva.
 * 
 * Esto se llama ATOMICIDAD — una de las propiedades ACID
 * que garantizan la integridad de los datos en una BD relacional.
 * 
 * ACID significa:
 *   A — Atomicidad: todo o nada
 *   C — Consistencia: los datos siempre son válidos
 *   I — Aislamiento: las transacciones no se interfieren
 *   D — Durabilidad: los cambios confirmados son permanentes
 */
public class ReservaDAO {

    /**
     * crearReservaCompleta()
     * 
     * Crea una reserva Y confirma sus asientos en una sola
     * transacción atómica.
     * 
     * Este es el método más importante del DAO porque
     * garantiza que la BD nunca quede en estado inconsistente.
     * 
     * Flujo:
     *   1. BEGIN (inicio de transacción)
     *   2. INSERT en reservas → obtenemos el ID generado
     *   3. UPDATE en asientos → los marcamos RESERVADO
     *   4. COMMIT si todo salió bien
     *   5. ROLLBACK si algo falló
     * 
     * @param reserva    — datos de la reserva a crear
     * @param asientosIds — lista de IDs de asientos a confirmar
     * @return ID de la reserva creada, -1 si hubo error
     */
    public Integer crearReservaCompleta(Reserva reserva, 
                                        List<Integer> asientosIds) {

        Connection conexion = null;
        Integer reservaId = -1;

        try {
            conexion = ConexionDB.getConexion();

            // Desactivamos autocommit para controlar la transacción
            conexion.setAutoCommit(false);

            // ── PASO 1: Insertar la reserva ────────────────────
            // RETURNING id le pide a PostgreSQL que nos devuelva
            // el ID que generó automáticamente para la nueva fila
            String sqlReserva = "INSERT INTO reservas " +
                "(usuario_id, tipo_servicio, tour_id, paquete_id, " +
                "fecha_viaje, personas, total, estado, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDIENTE', ?) " +
                "RETURNING id";

            PreparedStatement stmtReserva = 
                conexion.prepareStatement(sqlReserva);

            stmtReserva.setInt(1, reserva.getUsuarioId());
            stmtReserva.setString(2, reserva.getTipoServicio());

            // tour_id puede ser null si es un paquete
            if (reserva.getTourId() != null) {
                stmtReserva.setInt(3, reserva.getTourId());
            } else {
                // setNull indica que la columna tendrá valor NULL en la BD
                stmtReserva.setNull(3, java.sql.Types.INTEGER);
            }

            // paquete_id puede ser null si es un tour
            if (reserva.getPaqueteId() != null) {
                stmtReserva.setInt(4, reserva.getPaqueteId());
            } else {
                stmtReserva.setNull(4, java.sql.Types.INTEGER);
            }

            // Convertimos LocalDate a java.sql.Date para PostgreSQL
            stmtReserva.setDate(5, java.sql.Date.valueOf(
                reserva.getFechaViaje()));

            stmtReserva.setInt(6, reserva.getPersonas());
            stmtReserva.setBigDecimal(7, reserva.getTotal());
            stmtReserva.setTimestamp(8, 
                Timestamp.valueOf(LocalDateTime.now()));

            // executeQuery porque usamos RETURNING — nos devuelve el ID
            ResultSet rsReserva = stmtReserva.executeQuery();

            if (!rsReserva.next()) {
                // No se pudo insertar la reserva
                conexion.rollback();
                return -1;
            }

            // Guardamos el ID generado por PostgreSQL
            reservaId = rsReserva.getInt("id");

            // ── PASO 2: Confirmar los asientos ─────────────────
            // Actualizamos cada asiento de la lista
            String sqlAsiento = "UPDATE asientos SET " +
                "estado = 'RESERVADO', " +
                "reserva_id = ?, " +
                "bloqueado_hasta = NULL " +
                "WHERE id = ? AND estado = 'EN_PROCESO'";

            PreparedStatement stmtAsiento = 
                conexion.prepareStatement(sqlAsiento);

            for (Integer asientoId : asientosIds) {
                stmtAsiento.setInt(1, reservaId);
                stmtAsiento.setInt(2, asientoId);

                int filasAfectadas = stmtAsiento.executeUpdate();

                if (filasAfectadas == 0) {
                    // Este asiento ya no estaba EN_PROCESO
                    // (alguien lo liberó mientras pagábamos)
                    // Deshacemos TODO — la reserva y los asientos anteriores
                    System.err.println("Asiento " + asientoId + 
                        " ya no disponible. Cancelando reserva.");
                    conexion.rollback();
                    return -1;
                }
            }

            // ── PASO 3: Confirmar toda la transacción ──────────
            // Solo llegamos aquí si TODO salió bien
            conexion.commit();
            return reservaId;

        } catch (SQLException e) {
            System.err.println("Error al crear reserva: " + e.getMessage());
            try {
                if (conexion != null) conexion.rollback();
            } catch (SQLException ex) {
                System.err.println("Error en rollback: " + ex.getMessage());
            }
            return -1;
        } finally {
            try {
                if (conexion != null) conexion.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("Error al restaurar autocommit: " 
                    + e.getMessage());
            }
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /**
     * buscarPorId()
     * 
     * Busca una reserva específica por su ID.
     * Usamos JOIN para traer el nombre del cliente y del
     * servicio en la misma consulta.
     * 
     * @param id — ID de la reserva
     * @return Reserva si existe, null si no se encontró
     */
    public Reserva buscarPorId(Integer id) {

        Connection conexion = null;
        Reserva reserva = null;

        // JOIN con usuarios para traer el nombre del cliente
        // LEFT JOIN con tours y paquetes porque solo uno tendrá valor
        String sql = "SELECT r.id, r.usuario_id, r.tipo_servicio, " +
                     "r.tour_id, r.paquete_id, r.fecha_viaje, " +
                     "r.personas, r.total, r.estado, r.created_at, " +
                     "u.nombre || ' ' || u.apellido AS nombre_usuario, " +
                     "COALESCE(t.nombre, p.nombre) AS nombre_servicio " +
                     "FROM reservas r " +
                     "JOIN usuarios u ON r.usuario_id = u.id " +
                     "LEFT JOIN tours t ON r.tour_id = t.id " +
                     "LEFT JOIN paquetes p ON r.paquete_id = p.id " +
                     "WHERE r.id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                reserva = mapearReserva(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar reserva: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return reserva;
    }

    /**
     * listarPorUsuario()
     * 
     * Trae todas las reservas de un cliente específico.
     * Lo usamos en la sección "Mis reservas" del cliente.
     * 
     * @param usuarioId — ID del usuario
     * @return Lista de reservas del usuario
     */
    public List<Reserva> listarPorUsuario(Integer usuarioId) {

        List<Reserva> reservas = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT r.id, r.usuario_id, r.tipo_servicio, " +
                     "r.tour_id, r.paquete_id, r.fecha_viaje, " +
                     "r.personas, r.total, r.estado, r.created_at, " +
                     "u.nombre || ' ' || u.apellido AS nombre_usuario, " +
                     "COALESCE(t.nombre, p.nombre) AS nombre_servicio " +
                     "FROM reservas r " +
                     "JOIN usuarios u ON r.usuario_id = u.id " +
                     "LEFT JOIN tours t ON r.tour_id = t.id " +
                     "LEFT JOIN paquetes p ON r.paquete_id = p.id " +
                     "WHERE r.usuario_id = ? " +
                     "ORDER BY r.created_at DESC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, usuarioId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                reservas.add(mapearReserva(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar reservas: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return reservas;
    }

    /**
     * listarTodas()
     * 
     * Trae todas las reservas del sistema.
     * Solo el ADMIN puede usar este método desde el panel.
     * 
     * @return Lista de todas las reservas
     */
    public List<Reserva> listarTodas() {

        List<Reserva> reservas = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT r.id, r.usuario_id, r.tipo_servicio, " +
                     "r.tour_id, r.paquete_id, r.fecha_viaje, " +
                     "r.personas, r.total, r.estado, r.created_at, " +
                     "u.nombre || ' ' || u.apellido AS nombre_usuario, " +
                     "COALESCE(t.nombre, p.nombre) AS nombre_servicio " +
                     "FROM reservas r " +
                     "JOIN usuarios u ON r.usuario_id = u.id " +
                     "LEFT JOIN tours t ON r.tour_id = t.id " +
                     "LEFT JOIN paquetes p ON r.paquete_id = p.id " +
                     "ORDER BY r.created_at DESC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                reservas.add(mapearReserva(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar todas: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return reservas;
    }

    /**
     * cambiarEstado()
     * 
     * Actualiza el estado de una reserva.
     * Usado por el admin para confirmar o cancelar reservas.
     * 
     * Estados válidos: PENDIENTE, PAGADA, CONFIRMADA, CANCELADA
     * 
     * @param reservaId — ID de la reserva
     * @param nuevoEstado — nuevo estado a asignar
     * @return true si se actualizó correctamente
     */
    public boolean cambiarEstado(Integer reservaId, String nuevoEstado) {

        Connection conexion = null;

        String sql = "UPDATE reservas SET estado = ? WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, reservaId);

            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al cambiar estado: " + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /**
     * mapearReserva()
     * 
     * Método privado de utilidad que convierte una fila
     * del ResultSet en un objeto Reserva.
     * 
     * ¿Por qué lo separamos en su propio método?
     * Porque listarTodas(), listarPorUsuario() y buscarPorId()
     * hacen exactamente lo mismo para llenar el objeto.
     * En lugar de repetir ese código 3 veces, lo ponemos aquí
     * y los 3 métodos lo llaman.
     * 
     * Esto se llama principio DRY: Don't Repeat Yourself.
     * 
     * @param rs — fila actual del ResultSet
     * @return objeto Reserva lleno con los datos de la fila
     */
    private Reserva mapearReserva(ResultSet rs) throws SQLException {

        Reserva reserva = new Reserva();

        reserva.setId(rs.getInt("id"));
        reserva.setUsuarioId(rs.getInt("usuario_id"));
        reserva.setTipoServicio(rs.getString("tipo_servicio"));

        // tour_id y paquete_id pueden ser null
        int tourId = rs.getInt("tour_id");
        if (!rs.wasNull()) reserva.setTourId(tourId);

        int paqueteId = rs.getInt("paquete_id");
        if (!rs.wasNull()) reserva.setPaqueteId(paqueteId);

        // Convertimos java.sql.Date a LocalDate
        java.sql.Date fechaViaje = rs.getDate("fecha_viaje");
        if (fechaViaje != null) {
            reserva.setFechaViaje(fechaViaje.toLocalDate());
        }

        reserva.setPersonas(rs.getInt("personas"));
        reserva.setTotal(rs.getBigDecimal("total"));
        reserva.setEstado(rs.getString("estado"));

        // Convertimos Timestamp a LocalDateTime
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            reserva.setCreatedAt(ts.toLocalDateTime());
        }

        // Datos del JOIN
        reserva.setNombreUsuario(rs.getString("nombre_usuario"));
        reserva.setNombreServicio(rs.getString("nombre_servicio"));

        return reserva;
    }
}