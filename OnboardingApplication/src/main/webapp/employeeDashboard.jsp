<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="com.onboardApplication.java.Task" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Dashboard</title>
    <link rel="stylesheet" href="employeeDashboard.css">
    <script>
        function validateForm() {
            const phoneNum = document.forms["uploadForm"]["phone_num"].value;
            const aadharNum = document.forms["uploadForm"]["aadhar_num"].value;
            const panNum = document.forms["uploadForm"]["pan_num"].value;
            const phonePattern = /^[6-9]\d{9}$/;
            const aadharPattern = /^\d{12}$/;
            const panPattern = /^[A-Z]{5}\d{4}[A-Z]{1}$/;

            if (!phonePattern.test(phoneNum)) {
                alert("Please enter a valid phone number (10 digits, starting with 6-9).");
                return false;
            }
            if (!aadharPattern.test(aadharNum)) {
                alert("Please enter a valid Aadhar number (12 digits).");
                return false;
            }
            if (!panPattern.test(panNum)) {
                alert("Please enter a valid PAN number (e.g., ABCDE1234F).");
                return false;
            }
            return true;
        }
    </script>
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
    <div class="container">
        <header>
            <h2>Welcome, <%= name %></h2>
        </header>
        
        <section class="tasks-section">
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
        </section>
        
        <section class="upload-section">
            <%
                if (isApproved != null && !isApproved) {
            %>
            <form name="uploadForm" action="UploadDocumentsServlet" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                <h3>Upload Your Documents</h3>
                <input type="hidden" name="employee_id" value="<%= employeeId %>">
                
                <label for="employee_name">Employee Name:</label>
                <input type="text" name="employee_name" required><br>
                
                <label for="phone_num">Phone Number:</label>
                <input type="text" name="phone_num" required><br>
                
                <label for="aadhar_num">Aadhar Number:</label>
                <input type="text" name="aadhar_num" required><br>
                
                <label for="aadhar_img">Aadhar Card:</label>
                <input type="file" name="aadhar_img" required><br>
                
                <label for="pan_num">PAN Number:</label>
                <input type="text" name="pan_num" required><br>
                
                <label for="pan_img">PAN Card:</label>
                <input type="file" name="pan_img" required><br>
                
                <label for="marksheet">Marksheet:</label>
                <input type="file" name="marksheet" required><br>
                
                <label for="resume">Resume:</label>
                <input type="file" name="resume" required><br>
                
                <input type="submit" value="Upload Documents">
            </form>
            <%
                } else {
            %>
            <p>Your documents have been approved.</p>
            <%
                }
            %>
        </section>

        <footer>
            <a class="logout" href="LogoutServlet">Logout</a>
        </footer>
    </div>
</body>
</html>
