package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.Voucher;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * VoucherDAO.java
 * Genera y valida los vouchers digitales con codigo QR.
 * El voucher se crea cuando el pago es aprobado y se
 * invalida cuando el guia lo escanea al inicio del tour.
 */
public class VoucherDAO {

    /**
     * generarVoucher()
     * Crea un voucher nuevo para una reserva confirmada.
     * Genera un codigo unico que se codificara en el QR.
     * Solo se llama cuando el pago tiene estado APROBADO.
     *
     * Formato del codigo: PM-2026-A3F8B2
     */
    public Voucher generarVoucher(Integer reservaId) {

        Connection conexion = null;

        // Generamos el folio unico
        String codigo = "PM-" +
            java.time.Year.now().getValue() + "-" +
            UUID.randomUUID().toString()
                .substring(0, 6)
                .toUpperCase();

        String sql = "INSERT INTO vouchers " +
                     "(reserva_id, codigo_qr, estado, generado_at) " +
                     "VALUES (?, ?, 'GENERADO', ?) " +
                     "RETURNING id";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, reservaId);
            stmt.setString(2, codigo);
            stmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Voucher voucher = new Voucher();
                voucher.setId(rs.getInt("id"));
                voucher.setReservaId(reservaId);
                voucher.setCodigoQr(codigo);
                voucher.setEstado("GENERADO");
                voucher.setGeneradoAt(LocalDateTime.now());
                return voucher;
            }

        } catch (SQLException e) {
            System.err.println("Error al generar voucher: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return null;
    }

    /**
     * buscarPorCodigo()
     * Busca un voucher por su codigo QR.
     * El guia escanea el QR y el sistema llama
     * a este metodo para verificar su validez.
     */
    public Voucher buscarPorCodigo(String codigoQr) {

        Connection conexion = null;
        Voucher voucher     = null;

        String sql = "SELECT id, reserva_id, codigo_qr, estado, " +
                     "generado_at, escaneado_at " +
                     "FROM vouchers WHERE codigo_qr = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setString(1, codigoQr);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                voucher = new Voucher();
                voucher.setId(rs.getInt("id"));
                voucher.setReservaId(rs.getInt("reserva_id"));
                voucher.setCodigoQr(rs.getString("codigo_qr"));
                voucher.setEstado(rs.getString("estado"));

                Timestamp gen = rs.getTimestamp("generado_at");
                if (gen != null) {
                    voucher.setGeneradoAt(gen.toLocalDateTime());
                }

                Timestamp esc = rs.getTimestamp("escaneado_at");
                if (esc != null) {
                    voucher.setEscaneadoAt(esc.toLocalDateTime());
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar voucher: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return voucher;
    }

    /**
     * validarYUsar()
     * Valida un voucher y lo marca como USADO.
     * Se llama cuando el guia escanea el QR.
     * Devuelve false si el voucher no existe,
     * ya fue usado o esta vencido.
     */
    public boolean validarYUsar(String codigoQr) {

        Connection conexion = null;

        try {
            conexion = ConexionDB.getConexion();
            conexion.setAutoCommit(false);

            // Verificamos que el voucher exista y este GENERADO
            String sqlSelect = "SELECT id, estado FROM vouchers " +
                               "WHERE codigo_qr = ? FOR UPDATE";

            PreparedStatement stmtSelect =
                conexion.prepareStatement(sqlSelect);
            stmtSelect.setString(1, codigoQr);
            ResultSet rs = stmtSelect.executeQuery();

            if (!rs.next()) {
                conexion.rollback();
                return false;
            }

            String estado = rs.getString("estado");

            // Solo se puede usar si esta GENERADO
            if (!"GENERADO".equals(estado)) {
                conexion.rollback();
                return false;
            }

            // Marcamos como USADO y registramos la hora
            String sqlUpdate = "UPDATE vouchers SET " +
                "estado = 'USADO', escaneado_at = ? " +
                "WHERE codigo_qr = ?";

            PreparedStatement stmtUpdate =
                conexion.prepareStatement(sqlUpdate);
            stmtUpdate.setTimestamp(1,
                Timestamp.valueOf(LocalDateTime.now()));
            stmtUpdate.setString(2, codigoQr);
            stmtUpdate.executeUpdate();

            conexion.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al validar voucher: "
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
}