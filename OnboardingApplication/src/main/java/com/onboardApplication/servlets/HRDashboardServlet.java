package com.onboardApplication.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.onboardApplication.java.DocumentApproval;
import com.onboardApplication.java.Employee;

@WebServlet("/HRDashboardServlet")
public class HRDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null || !"hr".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            Connection conn = getConnection();
            if ("registerEmployee".equals(action)) {
                registerEmployee(conn, request);
            } else if ("assignProject".equals(action)) {
                assignProject(conn, request);
            } else if ("approveDocuments".equals(action)) {
                approveDocuments(conn, request);
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        doGet(request, response);  // Refresh the page to reflect changes
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null || !"hr".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Connection conn = getConnection();
            List<Employee> employees = getEmployees(conn);
            List<Employee> managers = getManagers(conn);
            List<DocumentApproval> pendingDocumentApprovals = getPendingDocumentApprovals(conn);
            System.out.println(pendingDocumentApprovals.toString());
            System.out.println(employees.toString());
            request.setAttribute("employees", employees);
            request.setAttribute("managers", managers);
            request.setAttribute("pendingDocumentApprovals", pendingDocumentApprovals);
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("hrDashboard.jsp").forward(request, response);
    }

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String jdbcURL = "jdbc:mysql://localhost:3306/onboarding_application";
        String dbUser = "root";
        String dbPassword = "root";
        return DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
    }

    private void registerEmployee(Connection conn, HttpServletRequest request) throws SQLException {
        String name = request.getParameter("employee_name");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String sql = "INSERT INTO users (employee_name, email, username, password, role) VALUES (?, ?, ?, ?, 'employee')";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setString(1, name);
        statement.setString(2, email);
        statement.setString(3, username);
        statement.setString(4, password);
        statement.executeUpdate();
    }

    private void assignProject(Connection conn, HttpServletRequest request) throws SQLException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        int managerId = Integer.parseInt(request.getParameter("managerId"));
        String projectName = request.getParameter("projectName");
        String sql = "INSERT INTO project_assignments (employee_id, manager_id, project_name) VALUES (?, ?, ?)";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setInt(1, employeeId);
        statement.setInt(2, managerId);
        statement.setString(3, projectName);
        statement.executeUpdate();
    }

    private List<Employee> getEmployees(Connection conn) throws SQLException {
        String sql = "SELECT employee_id, employee_name FROM users WHERE role = 'employee'";
        PreparedStatement statement = conn.prepareStatement(sql);
        ResultSet resultSet = statement.executeQuery();
        
        List<Employee> employees = new ArrayList<>();
        while (resultSet.next()) {
            int employeeId = resultSet.getInt("employee_id");
            String employeeName = resultSet.getString("employee_name");
            employees.add(new Employee(employeeId, employeeName));
        }
        return employees;
    }

    private List<Employee> getManagers(Connection conn) throws SQLException {
        String sql = "SELECT employee_id, employee_name FROM users WHERE role = 'manager'";
        PreparedStatement statement = conn.prepareStatement(sql);
        ResultSet resultSet = statement.executeQuery();
        
        List<Employee> managers = new ArrayList<>();
        while (resultSet.next()) {
            int employeeId = resultSet.getInt("employee_id");
            String employeeName = resultSet.getString("employee_name");
            managers.add(new Employee(employeeId, employeeName));
        }
        return managers;
    }
    
    private void approveDocuments(Connection conn, HttpServletRequest request) throws SQLException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        String sql = "UPDATE employee_details SET is_approved = TRUE WHERE employee_id = ?";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setInt(1, employeeId);
        statement.executeUpdate();
    }

    private List<DocumentApproval> getPendingDocumentApprovals(Connection conn) throws SQLException {
        String sql = "SELECT ed.employee_id, u.employee_name, ed.phone_num, ed.aadhar_num, ed.pan_num,ed.aadhar_img,ed.pan_img,ed.marksheet,ed.resume " +
                     "FROM employee_details ed " +
                     "JOIN users u ON ed.employee_id = u.employee_id " +
                     "WHERE ed.is_approved = FALSE";
        PreparedStatement statement = conn.prepareStatement(sql);
        ResultSet resultSet = statement.executeQuery();
        
        List<DocumentApproval> documentApprovals = new ArrayList<>();
        while (resultSet.next()) {
            int employeeId = resultSet.getInt("employee_id");
            String employeeName = resultSet.getString("employee_name");
            String phoneNum = resultSet.getString("phone_num");
            String aadharNum = resultSet.getString("aadhar_num");
            String panNum = resultSet.getString("pan_num");
            Blob aadharImg = resultSet.getBlob("aadhar_img");
            Blob panImg = resultSet.getBlob("pan_img");
            Blob marksheet = resultSet.getBlob("marksheet");
            Blob resume = resultSet.getBlob("resume");
            documentApprovals.add(new DocumentApproval(employeeId, employeeName, phoneNum, aadharNum, panNum, aadharImg, panImg, marksheet, resume));
        }
        return documentApprovals;
    }
}
