package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.Usuario;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    /*
      Convierte una contraseña en texto plano a su hash 
      MD5 es una función de hash — toma cualquier texto y
      produce siempre el mismo código de 32 caracteres.
      Es irreversible: del hash NO puedes obtener la contraseña.
     */
    private String encriptarMD5(String texto) {
        try {
            // MessageDigest es la clase de Java para calcular hashes
            MessageDigest md = MessageDigest.getInstance("MD5");

            // Convertimos el texto a bytes y calculamos el hash
            byte[] hash = md.digest(texto.getBytes());

            // Convertimos el array de bytes a texto hexadecimal
            // Ejemplo: byte 10 → "0a", byte 255 → "ff"
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                // String.format("%02x", b) convierte cada byte a 2 caracteres hex
                sb.append(String.format("%02x", b));
            }

            return sb.toString();

        } catch (NoSuchAlgorithmException e) {
            // MD5 siempre está disponible en Java, esto nunca debería pasar
            System.err.println("Error al encriptar: " + e.getMessage());
            return null;
        }
    }

    /**
     * registrar()
     * 
     * Guarda un usuario nuevo en la base de datos.
     * Antes de insertar verifica que el email no exista ya.
     * 
     * @param usuario — objeto Usuario con los datos del nuevo usuario
     * @return true si se registró correctamente, false si hubo error
     *         o si el email ya está registrado
     */
    public boolean registrar(Usuario usuario) {

        // Primero verificamos que el email no esté ya registrado
        if (existeEmail(usuario.getEmail())) {
            System.err.println("El email ya está registrado: " 
                + usuario.getEmail());
            return false;
        }

        Connection conexion = null;

        String sql = "INSERT INTO usuarios (nombre, apellido, email, " +
                     "password_hash, telefono, rol, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);

            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getApellido());
            stmt.setString(3, usuario.getEmail());

            // Encriptamos la contraseña ANTES de guardarla
            // Nunca guardamos la contraseña original
            stmt.setString(4, encriptarMD5(usuario.getPasswordHash()));

            stmt.setString(5, usuario.getTelefono());

            // Si no se especificó rol, asignamos CLIENTE por defecto
            String rol = usuario.getRol() != null ? usuario.getRol() : "CLIENTE";
            stmt.setString(6, rol);

            // Timestamp.valueOf convierte LocalDateTime al formato que
            // entiende PostgreSQL para la columna TIMESTAMP
            stmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));

            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al registrar usuario: " 
                + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /**
     * login()
     * 
     * Verifica las credenciales del usuario para iniciar sesión.
     * 
     * Proceso:
     *   1. Encriptamos la contraseña que escribió el usuario
     *   2. Buscamos en la BD un usuario con ese email Y ese hash
     *   3. Si existe → devolvemos el objeto Usuario (login exitoso)
     *   4. Si no existe → devolvemos null (credenciales incorrectas)
     * 
     * @param email      — correo del usuario
     * @param password   — contraseña en texto plano (sin encriptar)
     * @return Usuario si las credenciales son correctas, null si no
     */
    public Usuario login(String email, String password) {

        Connection conexion = null;
        Usuario usuario = null;

        // Encriptamos la contraseña para compararla con la BD
        String passwordHash = encriptarMD5(password);

        // Buscamos un usuario que tenga ESE email Y ESE hash
        // Si ambos coinciden, el login es correcto
        String sql = "SELECT id, nombre, apellido, email, " +
                     "password_hash, telefono, rol, created_at " +
                     "FROM usuarios " +
                     "WHERE email = ? AND password_hash = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);

            stmt.setString(1, email);
            stmt.setString(2, passwordHash);

            ResultSet rs = stmt.executeQuery();

            // Si hay resultado → credenciales correctas
            if (rs.next()) {
                usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setEmail(rs.getString("email"));
                usuario.setPasswordHash(rs.getString("password_hash"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setRol(rs.getString("rol"));

                // Timestamp.toLocalDateTime convierte el TIMESTAMP de
                // PostgreSQL al LocalDateTime que usa nuestro modelo
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    usuario.setCreatedAt(ts.toLocalDateTime());
                }
            }

        } catch (SQLException e) {
            System.err.println("Error en login: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return usuario;
    }

    /**
     * buscarPorId()
     * 
     * Busca un usuario por su ID.
     * Lo usamos cuando necesitamos los datos del usuario
     * que está en sesión, por ejemplo para mostrar su nombre.
     * 
     * @param id — ID del usuario a buscar
     * @return Usuario si existe, null si no se encontró
     */
    public Usuario buscarPorId(Integer id) {

        Connection conexion = null;
        Usuario usuario = null;

        String sql = "SELECT id, nombre, apellido, email, " +
                     "password_hash, telefono, rol, created_at " +
                     "FROM usuarios WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setEmail(rs.getString("email"));
                usuario.setPasswordHash(rs.getString("password_hash"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setRol(rs.getString("rol"));

                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    usuario.setCreatedAt(ts.toLocalDateTime());
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar usuario: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return usuario;
    }

    /**
     * buscarPorEmail()
     * 
     * Busca un usuario por su email.
     * Lo usamos en el registro para verificar si el email
     * ya existe antes de insertar uno nuevo.
     * 
     * @param email — correo a buscar
     * @return Usuario si existe, null si no se encontró
     */
    public Usuario buscarPorEmail(String email) {

        Connection conexion = null;
        Usuario usuario = null;

        String sql = "SELECT id, nombre, apellido, email, " +
                     "password_hash, telefono, rol, created_at " +
                     "FROM usuarios WHERE email = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setEmail(rs.getString("email"));
                usuario.setPasswordHash(rs.getString("password_hash"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setRol(rs.getString("rol"));

                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    usuario.setCreatedAt(ts.toLocalDateTime());
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar por email: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return usuario;
    }

    /**
     * existeEmail()
     * 
     * Verifica rápidamente si un email ya está registrado.
     * Más eficiente que buscarPorEmail() porque solo cuenta
     * registros en lugar de traer todos los datos.
     * 
     * @param email — correo a verificar
     * @return true si ya existe, false si está disponible
     */
    public boolean existeEmail(String email) {

        Connection conexion = null;
        boolean existe = false;

        // COUNT(*) es más rápido que SELECT * porque no trae datos
        String sql = "SELECT COUNT(*) AS total FROM usuarios " +
                     "WHERE email = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Si el conteo es mayor a 0, el email ya existe
                existe = rs.getInt("total") > 0;
            }

        } catch (SQLException e) {
            System.err.println("Error al verificar email: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return existe;
    }

    /**
     * listarTodos()
     * 
     * Trae todos los usuarios registrados.
     * Solo el ADMIN puede usar este método desde el panel
     * de administración.
     * 
     * @return Lista de todos los usuarios
     */
    public List<Usuario> listarTodos() {

        List<Usuario> usuarios = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT id, nombre, apellido, email, " +
                     "telefono, rol, created_at " +
                     "FROM usuarios " +
                     "ORDER BY created_at DESC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setEmail(rs.getString("email"));
                // No traemos password_hash por seguridad
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setRol(rs.getString("rol"));

                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    usuario.setCreatedAt(ts.toLocalDateTime());
                }

                usuarios.add(usuario);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar usuarios: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return usuarios;
    }
}