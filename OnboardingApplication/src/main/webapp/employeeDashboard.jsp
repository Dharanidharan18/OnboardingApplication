<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="com.onboardApplication.java.Task" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Dashboard</title>
    <link rel="stylesheet" href="employeeDashboard.css">
</head>
<body>
<%
    String name = (String) request.getAttribute("username");
    Boolean isApproved = (Boolean) request.getAttribute("isApproved");
    
    Integer employeeId = (Integer) session.getAttribute("employee_id");
    String employeeName = (String) session.getAttribute("employee_name");
    
    if (name == null) {
        response.sendRedirect("Login.jsp");
        return;
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
    
    <%
        if (isApproved != null && !isApproved) {
    %>
         <form action="UploadDocumentsServlet" method="post" enctype="multipart/form-data">
            <h3>Upload Your Documents</h3>
            <input type="hidden" name="employee_id" value="<%= employeeId %>">
     
             Employee Name : <input type="text" name="employee_name" required><br>
            Phone Number: <input type="text" name="phone_num" required><br>
            Aadhar Number: <input type="text" name="aadhar_num" required><br>
            Aadhar Card: <input type="file" name="aadhar_img" required><br>
            PAN Number: <input type="text" name="pan_num" required><br>
            PAN Card: <input type="file" name="pan_img" required><br>
            Marksheet: <input type="file" name="marksheet" required><br>
            Resume: <input type="file" name="resume" required><br>
            <input type="submit" value="Upload Documents">
        </form>
    <%
        } else {
    %>
        <p>Your documents have been approved.</p>
    <%
        }
    %>
    
    <a href="LogoutServlet">Logout</a>
</body>
</html>
