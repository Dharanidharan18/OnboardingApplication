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
import com.onboardingApplication.util.OnboardingApplicationDB;

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
            Connection conn = OnboardingApplicationDB.getConnection();
            if ("registerEmployee".equals(action)) {
                registerEmployee(conn, request);
                updateTotalEmployeesCount(conn); // Update total employee count after registration
                request.setAttribute("message", "Employee registered successfully.");
            } else if ("assignProject".equals(action)) {
                if (assignProject(conn, request)) {
                    request.setAttribute("message", "Project assigned successfully.");
                } else {
                    request.setAttribute("error", "Employee is already assigned to a project.");
                }
            } else if ("approveDocuments".equals(action)) {
                approveDocuments(conn, request);
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null || !"hr".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Connection conn = OnboardingApplicationDB.getConnection();
            List<Employee> employees = getEmployees(conn);
            List<Employee> managers = getManagers(conn);
            List<DocumentApproval> approve =getApprovedDocuments(conn);
            List<DocumentApproval> pendingDocumentApprovals = getPendingDocumentApprovals(conn);
            int totalEmployees = getTotalEmployees(conn); // Fetch total employee count
            request.setAttribute("employees", employees);
            request.setAttribute("managers", managers);
            request.setAttribute("approve", approve);
            request.setAttribute("pendingDocumentApprovals", pendingDocumentApprovals);
            request.setAttribute("totalEmployees", totalEmployees); // Set total employees count in request
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
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

    private boolean assignProject(Connection conn, HttpServletRequest request) throws SQLException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        int managerId = Integer.parseInt(request.getParameter("managerId"));
        String projectName = request.getParameter("projectName");

        // Check if the employee is already assigned to a project
        String checkSql = "SELECT COUNT(*) FROM project_assignments WHERE employee_id = ?";
        PreparedStatement checkStatement = conn.prepareStatement(checkSql);
        checkStatement.setInt(1, employeeId);
        ResultSet resultSet = checkStatement.executeQuery();
        resultSet.next();
        int count = resultSet.getInt(1);

        if (count > 0) {
            return false; // Employee is already assigned to a project
        }

        // Proceed with the assignment if not already assigned
        String sql = "INSERT INTO project_assignments (employee_id, manager_id, project_name) VALUES (?, ?, ?)";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setInt(1, employeeId);
        statement.setInt(2, managerId);
        statement.setString(3, projectName);
        statement.executeUpdate();
        return true;
    }

    private void approveDocuments(Connection conn, HttpServletRequest request) throws SQLException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        String sql = "UPDATE employee_details SET is_approved = TRUE WHERE employee_id = ?";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setInt(1, employeeId);
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

    private List<DocumentApproval> getPendingDocumentApprovals(Connection conn) throws SQLException {
        String sql = "SELECT ed.employee_id, u.employee_name, ed.phone_num, ed.aadhar_num, ed.pan_num, ed.aadhar_img, ed.pan_img, ed.marksheet, ed.resume " +
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

    private int getTotalEmployees(Connection conn) throws SQLException {
        int totalEmployees = 0;
        String sql = "SELECT COUNT(*) AS total FROM users WHERE role = 'employee'";
        PreparedStatement statement = conn.prepareStatement(sql);
        ResultSet resultSet = statement.executeQuery();
        if (resultSet.next()) {
            totalEmployees = resultSet.getInt("total");
        }
        return totalEmployees;
    }

    private void updateTotalEmployeesCount(Connection conn) throws SQLException {
        String updateSql = "UPDATE employee_count SET total_employees = total_employees + 1";
        Statement statement = conn.createStatement();
        statement.executeUpdate(updateSql);
    }
    
    private List<Employee> getAllEmployees(Connection conn) throws SQLException {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT employee_id, employee_name, email, username, role, status, asset_id, date_asset_assigned FROM users WHERE role = 'employee'";
        PreparedStatement statement = conn.prepareStatement(sql);
        ResultSet resultSet = statement.executeQuery();

        while (resultSet.next()) {
            int employeeId = resultSet.getInt("employee_id");
            String employeeName = resultSet.getString("employee_name");
//            String email = resultSet.getString("email");
//            String username = resultSet.getString("username");
//            String role = resultSet.getString("role");
//            String status = resultSet.getString("status");
//            String assetId = resultSet.getString("asset_id");
//            Date dateAssetAssigned = resultSet.getDate("date_asset_assigned");

            // Create Employee object and add to the list
            Employee employee = new Employee(employeeId, employeeName);
            employees.add(employee);
        }

        return employees;
    }
    
    private List<DocumentApproval> getApprovedDocuments(Connection conn) throws SQLException {
        List<DocumentApproval> approvedDocuments = new ArrayList<>();
        String sql = "SELECT ed.employee_id, u.employee_name, ed.phone_num, ed.aadhar_num, ed.pan_num, ed.aadhar_img, ed.pan_img, ed.marksheet, ed.resume " +
                     "FROM employee_details ed " +
                     "JOIN users u ON ed.employee_id = u.employee_id " +
                     "WHERE ed.is_approved = TRUE";
        PreparedStatement statement = conn.prepareStatement(sql);
        ResultSet resultSet = statement.executeQuery();

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
            approvedDocuments.add(new DocumentApproval(employeeId, employeeName, phoneNum, aadharNum, panNum, aadharImg, panImg, marksheet, resume));
        }

        return approvedDocuments;
    }

}
