package com.onboardApplication.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.onboardApplication.java.Task;

@WebServlet("/EmployeeDashboardServlet")
public class EmployeeDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Connection conn = getConnection();

            // Get employee tasks
            String sql = "SELECT t.task_id, t.task, t.status, t.due_date FROM tasks t JOIN users u ON t.employee_id = u.employee_id WHERE u.username = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();

            List<Task> tasks = new ArrayList<>();
            while (resultSet.next()) {
                Task task = new Task();
                task.setId(resultSet.getInt("task_id"));
                task.setTask(resultSet.getString("task"));
                task.setStatus(resultSet.getString("status"));
                task.setDueDate(resultSet.getTimestamp("due_date"));
                tasks.add(task);
            }

            // Check if the documents are approved
            String checkApprovalSql = "SELECT is_approved FROM employee_details ed JOIN users u ON ed.employee_id = u.employee_id WHERE u.username = ?";
            PreparedStatement checkApprovalStatement = conn.prepareStatement(checkApprovalSql);
            checkApprovalStatement.setString(1, username);
            ResultSet approvalResultSet = checkApprovalStatement.executeQuery();
            boolean isApproved = false;
            if (approvalResultSet.next()) {
                isApproved = approvalResultSet.getBoolean("is_approved");
            }

            request.setAttribute("tasks", tasks);
            request.setAttribute("username", username);
            request.setAttribute("isApproved", isApproved);
            request.getRequestDispatcher("employeeDashboard.jsp").forward(request, response);

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
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
