package com.onboardingApplication.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class OnboardingApplicationDB {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/onboarding_application";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Failed to load JDBC driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
    }
}
