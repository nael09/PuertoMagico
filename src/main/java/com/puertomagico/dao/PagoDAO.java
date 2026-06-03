package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.Pago;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * PagoDAO.java
 * Maneja los registros de pago en la tabla "pagos".
 * Cuando un cliente completa el flujo de pago simulado,
 * este DAO guarda el resultado y actualiza el estado
 * de la reserva correspondiente.
 */
public class PagoDAO {

    /**
     * registrarPago()
     * Guarda un nuevo pago en la BD.
     * Usa una transaccion para tambien actualizar
     * el estado de la reserva a PAGADA.
     */
    public boolean registrarPago(Pago pago) {

        Connection conexion = null;

        try {
            conexion = ConexionDB.getConexion();
            conexion.setAutoCommit(false);

            // Paso 1: Insertar el registro del pago
            String sqlPago = "INSERT INTO pagos " +
                "(reserva_id, monto, metodo, estado, " +
                "referencia, meses_sin_intereses, fecha_pago) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement stmtPago =
                conexion.prepareStatement(sqlPago);

            stmtPago.setInt(1, pago.getReservaId());
            stmtPago.setBigDecimal(2, pago.getMonto());
            stmtPago.setString(3, pago.getMetodo());
            stmtPago.setString(4, pago.getEstado());
            stmtPago.setString(5, pago.getReferencia());
            stmtPago.setInt(6,
                pago.getMesesSinIntereses() != null
                ? pago.getMesesSinIntereses() : 0);
            stmtPago.setTimestamp(7,
                Timestamp.valueOf(LocalDateTime.now()));

            stmtPago.executeUpdate();

            // Paso 2: Si el pago fue aprobado, actualizar la reserva
            if (pago.isAprobado()) {
                String sqlReserva = "UPDATE reservas " +
                    "SET estado = 'PAGADA' WHERE id = ?";

                PreparedStatement stmtReserva =
                    conexion.prepareStatement(sqlReserva);
                stmtReserva.setInt(1, pago.getReservaId());
                stmtReserva.executeUpdate();
            }

            conexion.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al registrar pago: "
                + e.getMessage());
            try {
                if (conexion != null) conexion.rollback();
            } catch (SQLException ex) {
                System.err.println("Error en rollback: "
                    + ex.getMessage());
            }
            return false;
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
     * buscarPorReserva()
     * Busca el pago asociado a una reserva.
     * Lo usamos para verificar si la reserva ya fue pagada
     * antes de generar el voucher.
     */
    public Pago buscarPorReserva(Integer reservaId) {

        Connection conexion = null;
        Pago pago           = null;

        String sql = "SELECT id, reserva_id, monto, metodo, " +
                     "estado, referencia, meses_sin_intereses, " +
                     "fecha_pago FROM pagos WHERE reserva_id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, reservaId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                pago = new Pago();
                pago.setId(rs.getInt("id"));
                pago.setReservaId(rs.getInt("reserva_id"));
                pago.setMonto(rs.getBigDecimal("monto"));
                pago.setMetodo(rs.getString("metodo"));
                pago.setEstado(rs.getString("estado"));
                pago.setReferencia(rs.getString("referencia"));
                pago.setMesesSinIntereses(
                    rs.getInt("meses_sin_intereses"));

                Timestamp ts = rs.getTimestamp("fecha_pago");
                if (ts != null) {
                    pago.setFechaPago(ts.toLocalDateTime());
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar pago: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return pago;
    }

    /**
     * listarPorEstado()
     * Trae todos los pagos con un estado especifico.
     * El admin lo usa para ver los pagos pendientes
     * de verificacion manual (transferencias, efectivo).
     */
    public List<Pago> listarPorEstado(String estado) {

        List<Pago> lista = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT id, reserva_id, monto, metodo, " +
                     "estado, referencia, meses_sin_intereses, " +
                     "fecha_pago FROM pagos WHERE estado = ? " +
                     "ORDER BY fecha_pago DESC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setString(1, estado);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Pago pago = new Pago();
                pago.setId(rs.getInt("id"));
                pago.setReservaId(rs.getInt("reserva_id"));
                pago.setMonto(rs.getBigDecimal("monto"));
                pago.setMetodo(rs.getString("metodo"));
                pago.setEstado(rs.getString("estado"));
                pago.setReferencia(rs.getString("referencia"));
                pago.setMesesSinIntereses(
                    rs.getInt("meses_sin_intereses"));

                Timestamp ts = rs.getTimestamp("fecha_pago");
                if (ts != null) {
                    pago.setFechaPago(ts.toLocalDateTime());
                }

                lista.add(pago);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar pagos: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return lista;
    }
}