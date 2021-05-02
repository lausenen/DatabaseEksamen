package dk.dtu.f21_02327;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


class Connector {

    private static final String HOST = "localhost";
    private static final int PORT = 3306;
    private static final String DATABASE = "Vaccine";
    private static final String USERNAME = "user";
    private static final String PASSWORD = "password";
    private static final String CP = "utf8";


    private Connection connection;

    Connector() {
        try {
            String url = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE + "?characterEncoding=" + CP;
            connection = DriverManager.getConnection(url, USERNAME, PASSWORD);
        } catch (SQLException e) {
            System.out.println("Fejl i Database navn, username eller password");
            e.printStackTrace();
        }
    }


    public Connection getConnection() {
        return connection;
    }

}
