package util;

import java.sql.*;

public class connectionDB {
    public static Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection("jdbc:postgresql://localhost:5432/restaurant", "postgres", "myrhl");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
