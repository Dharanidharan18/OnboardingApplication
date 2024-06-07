package com.onboardApplication.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/HRApprovalServlet")
public class HRApprovalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null || !"hr".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int employeeId = Integer.parseInt(request.getParameter("employeeId"));

        try {
            Connection conn = getConnection();
            approveDocuments(conn, employeeId);
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("HRDashboardServlet");  // Redirect to the HR dashboard
    }

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String jdbcURL = "jdbc:mysql://localhost:3306/onboarding_application";
        String dbUser = "root";
        String dbPassword = "root";
        return DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
    }

    private void approveDocuments(Connection conn, int employeeId) throws SQLException {
        String sql = "UPDATE employee_details SET is_approved = TRUE WHERE employee_id = ?";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setInt(1, employeeId);
        statement.executeUpdate();
    }
}
