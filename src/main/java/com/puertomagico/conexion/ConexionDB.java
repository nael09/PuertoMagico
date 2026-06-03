package com.puertomagico.conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    private static final String URL = "jdbc:postgresql://localhost:5432/PuertoMagico";
    private static final String USUARIO = "postgres";
    private static final String PASSWORD = "1234567890";
    /*
      getConexion()Abre y devuelve una conexión activa a la base de datos.
      Cada vez que un DAO necesita ejecutar SQL, llama a este método para obtener la conexión. Cuando termina de usarla,
      la cierra con cerrarConexion().
     
     */
    public static Connection getConexion() throws SQLException {
        // DriverManager es la clase de Java que maneja los drivers de BD
        // Le pasamos la URL, usuario y contraseña
        Connection conexion = DriverManager.getConnection(URL, USUARIO, PASSWORD);
        return conexion;
    }

    public static void cerrarConexion(Connection conexion) {
        if (conexion != null) {
            try {
                conexion.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar la conexión: " 
                    + e.getMessage());
            }
        }
    }
}