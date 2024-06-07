package com.onboardApplication.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection conn = getConnection();
            String sql = "SELECT role FROM users WHERE username = ? AND password = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String role = resultSet.getString("role");
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                switch (role) {
                    case "manager":
                        response.sendRedirect("ManagerDashboardServlet");
                        break;
                    case "hr":
                        response.sendRedirect("HRDashboardServlet");
                        break;
                    case "employee":
                        response.sendRedirect("EmployeeDashboardServlet");
                        break;
                    default:
                        response.sendRedirect("Login.jsp");
                        break;
                }
            } else {
                response.sendRedirect("Login.jsp?error=Invalid username or password");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private Connection getConnection() throws SQLException, ClassNotFoundException {
    	
    	Class.forName("com.mysql.cj.jdbc.Driver");
        String jdbcURL = "jdbc:mysql://localhost:3306/onboarding_application";
        String dbUser = "root";
        String dbPassword = "root";
        return DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
    }
}


