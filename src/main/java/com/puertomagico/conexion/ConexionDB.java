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

    try {
        /*
         * Class.forName() carga explícitamente el driver de PostgreSQL.
         * Con Tomcat externo no es necesario porque Tomcat lo registra
         * automáticamente, pero con el Tomcat embebido de Maven
         * hay que cargarlo manualmente o lanza:
         * "No suitable driver found"
         */
        Class.forName("org.postgresql.Driver");

    } catch (ClassNotFoundException e) {
        System.err.println("Driver PostgreSQL no encontrado: "
            + e.getMessage());
    }

    Connection conexion = DriverManager.getConnection(
        URL, USUARIO, PASSWORD);
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