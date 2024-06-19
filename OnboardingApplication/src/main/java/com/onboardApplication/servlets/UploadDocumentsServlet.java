package com.onboardApplication.servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UploadDocumentsServlet")
@MultipartConfig(maxFileSize = 16177215)   
public class UploadDocumentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        InputStream aadharImg = null;
        InputStream panImg = null;
        InputStream marksheet = null;
        InputStream resume = null;

        // Obtaining the uploaded files
        Part aadharPart = request.getPart("aadhar_img");
        Part panPart = request.getPart("pan_img");
        Part marksheetPart = request.getPart("marksheet");
        Part resumePart = request.getPart("resume");

        if (aadharPart != null) aadharImg = aadharPart.getInputStream();
        if (panPart != null) panImg = panPart.getInputStream();
        if (marksheetPart != null) marksheet = marksheetPart.getInputStream();
        if (resumePart != null) resume = resumePart.getInputStream();

        try {
            Connection conn = getConnection();

            // Get employee ID
            String sql = "SELECT employee_id FROM users WHERE username = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();

            int employeeId = -1;
            if (resultSet.next()) {
                employeeId = resultSet.getInt("employee_id");
            }

            if (employeeId != -1) {
                // Update or Insert the employee details
                String insertOrUpdateSql = "INSERT INTO employee_details (employee_id, employee_name, phone_num, aadhar_num, aadhar_img, pan_num, pan_img, marksheet, resume) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) "
                        + "ON DUPLICATE KEY UPDATE "
                        + "employee_name = VALUES(employee_name), phone_num = VALUES(phone_num), aadhar_num = VALUES(aadhar_num), aadhar_img = VALUES(aadhar_img), pan_num = VALUES(pan_num), pan_img = VALUES(pan_img), marksheet = VALUES(marksheet), resume = VALUES(resume)";
                
                PreparedStatement insertOrUpdateStatement = conn.prepareStatement(insertOrUpdateSql);
                insertOrUpdateStatement.setInt(1, employeeId);
                insertOrUpdateStatement.setString(2, request.getParameter("employee_name"));
                insertOrUpdateStatement.setString(3, request.getParameter("phone_num"));
                insertOrUpdateStatement.setString(4, request.getParameter("aadhar_num"));
                insertOrUpdateStatement.setBlob(5, aadharImg);
                insertOrUpdateStatement.setString(6, request.getParameter("pan_num"));
                insertOrUpdateStatement.setBlob(7, panImg);
                insertOrUpdateStatement.setBlob(8, marksheet);
                insertOrUpdateStatement.setBlob(9, resume);

                insertOrUpdateStatement.executeUpdate();
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        }

        request.getRequestDispatcher("EmployeeDashboardServlet");
     //   for("EmployeeDashboardServlet");
    }

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String jdbcURL = "jdbc:mysql://localhost:3306/onboarding_application";
        String dbUser = "root";
        String dbPassword = "root";
        return DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
    }
}
