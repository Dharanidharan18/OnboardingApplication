<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="com.onboardApplication.java.Employee" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manager Dashboard</title>
    <link rel="stylesheet" href="managerDashboard.css">
</head>
<body>
    <h2>Welcome, <%= session.getAttribute("username") %></h2>

    <h3>Employees Assigned to You</h3>
    <table border="1">
        <tr>
            <th>Employee ID</th>
            <th>Employee Name</th>
        </tr>
        <%
            List<Employee> assignedEmployees = (List<Employee>) request.getAttribute("assignedEmployees");
            if (assignedEmployees != null) {
                for (Employee employee : assignedEmployees) {
        %>
        <tr>
            <td><%= employee.getId() %></td>
            <td><%= employee.getName() %></td>
        </tr>
        <%
                }
            }
        %>
    </table>

    <h3>Assign Task to Employee</h3>
    <form action="ManagerDashboardServlet" method="post">
        <input type="hidden" name="action" value="assignTask">
        <label for="employeeId">Employee ID:</label>
        <input type="text" id="employeeId" name="employeeId" required><br>
        <label for="task">Task:</label>
        <textarea id="task" name="task" required></textarea><br>
        <label for="dueDate">Due Date:</label>
        <input type="datetime-local" id="dueDate" name="dueDate" required><br>
        <input type="submit" value="Assign Task">
    </form>

    <h3>Approve Task Completion</h3>
    <form action="ManagerDashboardServlet" method="post">
        <input type="hidden" name="action" value="approveTask">
        <label for="taskId">Task ID:</label>
        <input type="text" id="taskId" name="taskId" required><br>
        <input type="submit" value="Approve Task">
    </form>

    <h3>Evaluate Employee</h3>
    <form action="ManagerDashboardServlet" method="post">
        <input type="hidden" name="action" value="evaluateEmployee">
        <label for="employeeIdEval">Employee ID:</label>
        <input type="text" id="employeeIdEval" name="employeeId" required><br>
        <label for="technicalSkill">Technical Skill (0-10):</label>
        <input type="number" id="technicalSkill" name="technicalSkill" min="0" max="10" required><br>
        <label for="communicationSkill">Communication Skill (0-10):</label>
        <input type="number" id="communicationSkill" name="communicationSkill" min="0" max="10" required><br>
        <input type="submit" value="Evaluate Employee">
    </form>

   <a href="LogoutServlet">Logout</a>
</body>
</html>
