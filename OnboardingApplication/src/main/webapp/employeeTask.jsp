<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="com.onboardApplication.java.Task" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Dashboard</title>
</head>
<body>
<%
    String name = (String) request.getAttribute("username");
    if (name == null) {
        // handle null username case
    }
%>
    <h2>Welcome, <%= name %></h2>
    <h3>Your Tasks</h3>
    <table border="1">
        <tr>
            <th>Task ID</th>
            <th>Task Description</th>
            <th>Status</th>
            <th>Due Date</th> 
        </tr>
        <%
            List<Task> tasks = (ArrayList<Task>) request.getAttribute("tasks");
            if (tasks != null) {
                for (Task task : tasks) {
        %>
            <tr>
                <td><%= task.getId() %></td>
                <td><%= task.getTask() %></td>
                <td><%= task.getStatus() %></td>
                <td><%= task.getDueDate() %></td> 
            </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="4">No tasks available</td>
            </tr>
        <%
            }
        %>
    </table>
    
    <a href="LogoutServlet">Logout</a>
</body>
</html>
