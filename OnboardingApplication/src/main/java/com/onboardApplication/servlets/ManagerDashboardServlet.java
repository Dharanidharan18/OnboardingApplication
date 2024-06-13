package com.onboardApplication.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.onboardApplication.java.Employee;

@WebServlet("/ManagerDashboardServlet")
public class ManagerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
       
        if (username == null || !"manager".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Connection conn = getConnection();
            int managerId = getManagerId(conn, username);
            List<Employee> assignedEmployees = getAssignedEmployees(conn, managerId);
            request.setAttribute("assignedEmployees", assignedEmployees);
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("managerDashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null || !"manager".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            Connection conn = getConnection();
            if ("assignTask".equals(action)) {
                assignTask(conn, request);
            } else if ("approveTask".equals(action)) {
                approveTask(conn, request);
            } else if ("evaluateEmployee".equals(action)) {
                evaluateEmployee(conn, request);
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        doGet(request, response);
    }

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String jdbcURL = "jdbc:mysql://localhost:3306/onboarding_application";
        String dbUser = "root";
        String dbPassword = "root";
        return DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
    }

    private int getManagerId(Connection conn, String username) throws SQLException {
        String sql = "SELECT employee_id FROM users WHERE username = ?";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setString(1, username);
        ResultSet resultSet = statement.executeQuery();
        if (resultSet.next()) {
            return resultSet.getInt("employee_id");
        }
        return -1;
    }

    private List<Employee> getAssignedEmployees(Connection conn, int managerId) throws SQLException {
        String sql = "SELECT u.employee_id, u.employee_name FROM users u JOIN project_assignments pa ON u.employee_id = pa.employee_id WHERE pa.manager_id = ?";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setInt(1, managerId);
        ResultSet resultSet = statement.executeQuery();

        List<Employee> employees = new ArrayList<>();
        while (resultSet.next()) {
            int employeeId = resultSet.getInt("employee_id");
            String employeeName = resultSet.getString("employee_name");
            employees.add(new Employee(employeeId, employeeName));
        }
        return employees;
    }

    private void assignTask(Connection conn, HttpServletRequest request) throws SQLException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        String task = request.getParameter("task");
        String dueDate = request.getParameter("dueDate");
        String sql = "INSERT INTO tasks (employee_id, task, due_date) VALUES (?, ?, ?)";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setInt(1, employeeId);
        statement.setString(2, task);
        statement.setString(3, dueDate);
        statement.executeUpdate();
    }

    private void approveTask(Connection conn, HttpServletRequest request) throws SQLException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        String sql = "UPDATE tasks SET status = 'approved' WHERE task_id = ?";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setInt(1, taskId);
        statement.executeUpdate();
    }

    private void evaluateEmployee(Connection conn, HttpServletRequest request) throws SQLException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        int technicalSkill = Integer.parseInt(request.getParameter("technicalSkill"));
        int communicationSkill = Integer.parseInt(request.getParameter("communicationSkill"));
        String sql = "INSERT INTO performance (employee_id, technical_skill, communication_skill) VALUES (?, ?, ?)";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setInt(1, employeeId);
        statement.setInt(2, technicalSkill);
        statement.setInt(3, communicationSkill);
        statement.executeUpdate();

    
    }

    
}

