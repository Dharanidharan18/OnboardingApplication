package com.onboardApplication.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.onboardingApplication.util.OnboardingApplicationDB;

@WebServlet("/UploadDocumentsServlet")
public class UploadDocumentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null || !"employee".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Connection conn = OnboardingApplicationDB.getConnection();
            uploadDocuments(conn, request, username);

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("EmployeeDashboardServlet");
    }

    private void uploadDocuments(Connection conn, HttpServletRequest request, String username) throws SQLException {
        String documentName = request.getParameter("documentName");
        // Assume file upload logic is handled separately, and file path is obtained
        String filePath = request.getParameter("filePath");

        String sql = "INSERT INTO employee_details (document_name, document_path, employee_id, is_approved) VALUES (?, ?, (SELECT employee_id FROM users WHERE username = ?), 0)";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setString(1, documentName);
        statement.setString(2, filePath);
        statement.setString(3, username);
        statement.executeUpdate();
    }
}
