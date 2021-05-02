package dk.dtu.f21_02327;

import com.mysql.cj.util.StringUtils;
import sun.nio.ch.IOUtil;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

class Connector {


    private static final String HOST     = "localhost";
    private static final int    PORT     = 3306;
    private static final String DATABASE = "Vaccine";
    private static final String USERNAME = "user";
    private static final String PASSWORD = "password";


   // private Connection connection;

    Connector() {
       /* try {
            String url = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE;
            connection = DriverManager.getConnection(url, USERNAME, PASSWORD);


        } catch (SQLException e) {
            e.printStackTrace();
        }*/
    }

    public Connection getConnection(){
        Connection connection = null;

        try {
            String url = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE;
            connection = DriverManager.getConnection(url, USERNAME, PASSWORD);


        } catch (SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }

}
