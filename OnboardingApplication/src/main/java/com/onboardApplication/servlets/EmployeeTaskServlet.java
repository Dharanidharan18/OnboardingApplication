package com.onboardApplication.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.onboardApplication.java.Task;

@WebServlet("/EmployeeTaskServlet")
public class EmployeeTaskServlet extends HttpServlet {
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
            String sql = "SELECT t.task_id, t.task, t.status, t.due_date FROM tasks t JOIN users u ON t.employee_id = u.employee_id WHERE u.username = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();

            ArrayList<Task> tasks = new ArrayList<>();
            while (resultSet.next()) {
                Task task = new Task();
                task.setId(resultSet.getInt("task_id"));
                task.setTask(resultSet.getString("task"));
                task.setStatus(resultSet.getString("status"));
                task.setDueDate(resultSet.getTimestamp("due_date"));
                tasks.add(task);
            }

            request.setAttribute("tasks", tasks);
            request.setAttribute("username", username);
            request.getRequestDispatcher("employeeTask.jsp").forward(request, response);

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
