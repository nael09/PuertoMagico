package com.puertomagico.dao;

import com.puertomagico.conexion.ConexionDB;
import com.puertomagico.modelo.Tour;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * TourDAO.java
 * 
 * DAO = Data Access Object (Objeto de Acceso a Datos)
 * 
 * Esta clase es la ÚNICA que se comunica con la tabla "tours"
 * de PostgreSQL. Ninguna otra clase del proyecto debe escribir
 * SQL relacionado con tours — toda esa lógica vive aquí.
 * 
 * Ventaja: si mañana cambias PostgreSQL por MySQL, solo
 * modificas esta clase. El resto del proyecto no cambia.
 * 
 * Cada método sigue este patrón:
 *   1. Abrir conexión
 *   2. Preparar el SQL
 *   3. Ejecutar
 *   4. Procesar resultado
 *   5. Cerrar conexión (SIEMPRE, aunque haya error)
 */
public class TourDAO {

    /**
     * listarTodos()
     * 
     * Trae todos los tours activos de la base de datos.
     * Los ordena por nombre para mostrarlos en el catálogo.
     * 
     * Usamos JOIN con destinos y vehiculos para traer los nombres
     * en una sola consulta y no hacer múltiples llamadas a la BD.
     * 
     * @return Lista de objetos Tour. Lista vacía si no hay tours.
     */
    public List<Tour> listarTodos() {

        // Lista donde guardaremos los tours que traigamos de la BD
        List<Tour> tours = new ArrayList<>();

        // Conexión que abriremos para ejecutar el SQL
        Connection conexion = null;

        // SQL con JOIN para traer nombre de destino y vehículo
        // en lugar de solo sus IDs
        String sql = "SELECT t.id, t.destino_id, t.vehiculo_id, " +
                     "t.nombre, t.descripcion, t.duracion_horas, " +
                     "t.precio_base, t.cupo_maximo, t.dificultad, t.activo, " +
                     "t.fecha_salida, t.puntos_salida, " +
                     "d.nombre AS nombre_destino, " +
                     "v.descripcion AS nombre_vehiculo " +
                     "FROM tours t " +
                     "JOIN destinos d ON t.destino_id = d.id " +
                     "JOIN vehiculos v ON t.vehiculo_id = v.id " +
                     "WHERE t.activo = true " +
                     "ORDER BY t.nombre ASC";

        try {
            // 1. Abrir la conexión a PostgreSQL
            conexion = ConexionDB.getConexion();

            // PreparedStatement prepara el SQL para ejecutarlo
            // Es más seguro que Statement porque previene SQL Injection
            PreparedStatement stmt = conexion.prepareStatement(sql);

            // ResultSet es como una tabla temporal con los resultados
            // Tiene un "cursor" que empieza antes de la primera fila
            ResultSet rs = stmt.executeQuery();

            // rs.next() mueve el cursor a la siguiente fila
            // Devuelve false cuando no hay más filas
            while (rs.next()) {

                // Creamos un objeto Tour y llenamos sus datos
                // con los valores de cada columna del ResultSet
                Tour tour = new Tour();

                // rs.getInt("columna") lee un entero de esa columna
                tour.setId(rs.getInt("id"));
                tour.setDestinoId(rs.getInt("destino_id"));
                tour.setVehiculoId(rs.getInt("vehiculo_id"));

                // rs.getString("columna") lee texto
                tour.setNombre(rs.getString("nombre"));
                tour.setDescripcion(rs.getString("descripcion"));

                tour.setDuracionHoras(rs.getInt("duracion_horas"));

                // rs.getBigDecimal lee valores decimales (dinero)
                tour.setPrecioBase(rs.getBigDecimal("precio_base"));

                tour.setCupoMaximo(rs.getInt("cupo_maximo"));
                tour.setDificultad(rs.getString("dificultad"));

                // rs.getBoolean lee valores true/false
                tour.setActivo(rs.getBoolean("activo"));

                // Datos del JOIN — nombre del destino y vehículo
                tour.setNombreDestino(rs.getString("nombre_destino"));
                tour.setNombreVehiculo(rs.getString("nombre_vehiculo"));

                // Agregamos el tour a la lista
                tours.add(tour);
            }

        } catch (SQLException e) {
            // Si algo falla, mostramos el error en consola
            System.err.println("Error al listar tours: " + e.getMessage());
        } finally {
            // finally se ejecuta SIEMPRE — haya error o no
            // Es donde cerramos la conexión para no dejarla abierta
            ConexionDB.cerrarConexion(conexion);
        }

        return tours;
    }

    /**
     * buscarPorId()
     * 
     * Busca un tour específico por su ID.
     * Lo usamos cuando el cliente hace clic en "Ver detalle"
     * de un tour en el catálogo.
     * 
     * @param id — ID del tour a buscar
     * @return El objeto Tour si existe, null si no se encontró
     */
    public Tour buscarPorId(Integer id) {

        Tour tour = null;
        Connection conexion = null;

        // El símbolo ? es un parámetro que llenaremos después
        // NUNCA concatenes el ID directamente en el SQL así:
        // "WHERE id = " + id  ← PELIGROSO (SQL Injection)
        // Siempre usa ? y PreparedStatement
        String sql = "SELECT t.id, t.destino_id, t.vehiculo_id, " +
                     "t.nombre, t.descripcion, t.duracion_horas, " +
                     "t.precio_base, t.cupo_maximo, t.dificultad, t.activo, " +
                     "t.fecha_salida, t.puntos_salida, " +
                     "d.nombre AS nombre_destino, " +
                     "v.descripcion AS nombre_vehiculo " +
                     "FROM tours t " +
                     "JOIN destinos d ON t.destino_id = d.id " +
                     "JOIN vehiculos v ON t.vehiculo_id = v.id " +
                     "WHERE t.id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);

            // setInt(1, id) llena el primer ? con el valor del id
            // El número 1 indica la posición del ? en el SQL
            stmt.setInt(1, id);

            ResultSet rs = stmt.executeQuery();

            // Como buscamos por ID solo puede haber una fila
            // Por eso usamos if en lugar de while
            if (rs.next()) {
                tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setDestinoId(rs.getInt("destino_id"));
                tour.setVehiculoId(rs.getInt("vehiculo_id"));
                tour.setNombre(rs.getString("nombre"));
                tour.setDescripcion(rs.getString("descripcion"));
                tour.setDuracionHoras(rs.getInt("duracion_horas"));
                tour.setPrecioBase(rs.getBigDecimal("precio_base"));
                tour.setCupoMaximo(rs.getInt("cupo_maximo"));
                tour.setDificultad(rs.getString("dificultad"));
                tour.setActivo(rs.getBoolean("activo"));
                tour.setNombreDestino(rs.getString("nombre_destino"));
                tour.setNombreVehiculo(rs.getString("nombre_vehiculo"));
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar tour por ID: " 
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return tour;
    }

    /**
     * listarPorDestino()
     * 
     * Filtra los tours de un destino específico.
     * Lo usamos cuando el cliente selecciona un destino
     * en la página principal y quiere ver sus tours.
     * 
     * @param destinoId — ID del destino a filtrar
     * @return Lista de tours de ese destino
     */
    public List<Tour> listarPorDestino(Integer destinoId) {

        List<Tour> tours = new ArrayList<>();
        Connection conexion = null;

        String sql = "SELECT t.id, t.destino_id, t.vehiculo_id, " +
                     "t.nombre, t.descripcion, t.duracion_horas, " +
                     "t.precio_base, t.cupo_maximo, t.dificultad, t.activo, " +
                     "t.fecha_salida, t.puntos_salida, " +
                     "d.nombre AS nombre_destino, " +
                     "v.descripcion AS nombre_vehiculo " +
                     "FROM tours t " +
                     "JOIN destinos d ON t.destino_id = d.id " +
                     "JOIN vehiculos v ON t.vehiculo_id = v.id " +
                     "WHERE t.destino_id = ? AND t.activo = true " +
                     "ORDER BY t.nombre ASC";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, destinoId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setDestinoId(rs.getInt("destino_id"));
                tour.setVehiculoId(rs.getInt("vehiculo_id"));
                tour.setNombre(rs.getString("nombre"));
                tour.setDescripcion(rs.getString("descripcion"));
                tour.setDuracionHoras(rs.getInt("duracion_horas"));
                tour.setPrecioBase(rs.getBigDecimal("precio_base"));
                tour.setCupoMaximo(rs.getInt("cupo_maximo"));
                tour.setDificultad(rs.getString("dificultad"));
                tour.setActivo(rs.getBoolean("activo"));
                tour.setNombreDestino(rs.getString("nombre_destino"));
                tour.setNombreVehiculo(rs.getString("nombre_vehiculo"));
                tours.add(tour);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar tours por destino: "
                + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return tours;
    }

    /**
     * insertar()
     * 
     * Guarda un tour nuevo en la base de datos.
     * Solo el ADMIN puede llamar este método.
     * 
     * @param tour — objeto Tour con los datos a guardar
     * @return true si se insertó correctamente, false si hubo error
     */
    public boolean insertar(Tour tour) {

        Connection conexion = null;

        // INSERT con ? para cada valor — nunca concatenes datos del usuario
        String sql = "INSERT INTO tours (destino_id, vehiculo_id, nombre, " +
                     "descripcion, duracion_horas, precio_base, " +
                     "cupo_maximo, dificultad, activo) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);

            // Llenamos los ? en orden según aparecen en el SQL
            stmt.setInt(1, tour.getDestinoId());      // primer ?
            stmt.setInt(2, tour.getVehiculoId());      // segundo ?
            stmt.setString(3, tour.getNombre());       // tercer ?
            stmt.setString(4, tour.getDescripcion());  // cuarto ?
            stmt.setInt(5, tour.getDuracionHoras());   // quinto ?
            stmt.setBigDecimal(6, tour.getPrecioBase()); // sexto ?
            stmt.setInt(7, tour.getCupoMaximo());      // séptimo ?
            stmt.setString(8, tour.getDificultad());   // octavo ?
            stmt.setBoolean(9, true);                  // noveno ? (activo)

            // executeUpdate() ejecuta INSERT, UPDATE o DELETE
            // Devuelve el número de filas afectadas
            int filasAfectadas = stmt.executeUpdate();

            // Si insertó al menos 1 fila, fue exitoso
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al insertar tour: " + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /**
     * actualizar()
     * 
     * Modifica los datos de un tour existente.
     * Solo el ADMIN puede llamar este método.
     * 
     * @param tour — objeto Tour con los datos actualizados
     * @return true si se actualizó correctamente, false si hubo error
     */
    public boolean actualizar(Tour tour) {

        Connection conexion = null;

        String sql = "UPDATE tours SET destino_id = ?, vehiculo_id = ?, " +
                     "nombre = ?, descripcion = ?, duracion_horas = ?, " +
                     "precio_base = ?, cupo_maximo = ?, dificultad = ? " +
                     "WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);

            stmt.setInt(1, tour.getDestinoId());
            stmt.setInt(2, tour.getVehiculoId());
            stmt.setString(3, tour.getNombre());
            stmt.setString(4, tour.getDescripcion());
            stmt.setInt(5, tour.getDuracionHoras());
            stmt.setBigDecimal(6, tour.getPrecioBase());
            stmt.setInt(7, tour.getCupoMaximo());
            stmt.setString(8, tour.getDificultad());
            // El ID va al final porque es el WHERE — el último ?
            stmt.setInt(9, tour.getId());

            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar tour: " + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /**
     * desactivar()
     * 
     * Pone activo = false en lugar de borrar el tour.
     * 
     * ¿Por qué no borramos directamente con DELETE?
     * Porque si hay reservas históricas de ese tour,
     * perderíamos la referencia. Al desactivar, el tour
     * ya no aparece en el catálogo pero sus datos se conservan
     * para el historial de reservas.
     * 
     * Esto se llama "borrado lógico" vs "borrado físico".
     * 
     * @param id — ID del tour a desactivar
     * @return true si se desactivó correctamente
     */
    public boolean desactivar(Integer id) {

        Connection conexion = null;
        String sql = "UPDATE tours SET activo = false WHERE id = ?";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, id);
            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al desactivar tour: " + e.getMessage());
            return false;
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }
    }

    /**
     * contarLugaresDisponibles()
     * 
     * Cuenta cuántos asientos DISPONIBLES tiene un tour.
     * Lo usamos para mostrar "8 lugares disponibles" en las
     * tarjetas del catálogo sin traer todos los asientos.
     * 
     * @param tourId — ID del tour a consultar
     * @return Número de asientos disponibles
     */
    public int contarLugaresDisponibles(Integer tourId) {

        Connection conexion = null;
        int disponibles = 0;

        // COUNT(*) cuenta las filas que cumplen la condición
        String sql = "SELECT COUNT(*) AS disponibles " +
                     "FROM asientos " +
                     "WHERE tour_id = ? AND estado = 'DISPONIBLE'";

        try {
            conexion = ConexionDB.getConexion();
            PreparedStatement stmt = conexion.prepareStatement(sql);
            stmt.setInt(1, tourId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                disponibles = rs.getInt("disponibles");
            }

        } catch (SQLException e) {
            System.err.println("Error al contar lugares: " + e.getMessage());
        } finally {
            ConexionDB.cerrarConexion(conexion);
        }

        return disponibles;
    }
}