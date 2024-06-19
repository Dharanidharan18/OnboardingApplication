<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.Blob, com.onboardApplication.java.Employee, com.onboardApplication.java.DocumentApproval"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>HR Dashboard</title>
    <link rel="stylesheet" href="hrDashboard.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Welcome, <%= session.getAttribute("username") %></h1>
        </header>

        <div class="flex-container">
            <section class="section register-section">
                <h3>Register New Employee</h3>
                <form action="HRDashboardServlet" method="post">
                    <input type="hidden" name="action" value="registerEmployee">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="employee_name" required>
                    
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                    
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required>
                    
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                    
                    <input type="submit" value="Register Employee">
                </form>
            </section>

            <section class="section assign-section">
                <h3>Assign Employee to Project and Manager</h3>
                <form action="HRDashboardServlet" method="post">
                    <input type="hidden" name="action" value="assignProject">
                    
                    <label for="employeeId">Employee:</label>
                    <select id="employeeId" name="employeeId" required>
                        <option value="">Select Employee</option>
                        <%
                            List<Employee> employees = (List<Employee>) request.getAttribute("employees");
                            if (employees != null) {
                                for (Employee employee : employees) {
                        %>
                        <option value="<%= employee.getId() %>"><%= employee.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                    
                    <label for="managerId">Manager:</label>
                    <select id="managerId" name="managerId" required>
                        <option value="">Select Manager</option>
                        <%
                            List<Employee> managers = (List<Employee>) request.getAttribute("managers");
                            if (managers != null) {
                                for (Employee manager : managers) {
                        %>
                        <option value="<%= manager.getId() %>"><%= manager.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                    
                    <label for="projectName">Project Name:</label>
                    <input type="text" id="projectName" name="projectName" required>
                    
                    <input type="submit" value="Assign Project">
                </form>
            </section>
        </div>

        <section class="section approval-section">
            <h3>Pending Document Approvals</h3>
            <table>
                <thead>
                    <tr>
                        <th>Employee ID</th>
                        <th>Employee Name</th>
                        <th>Phone Number</th>
                        <th>Aadhar Number</th>
                        <th>PAN Number</th>
                        <th>Aadhar Card</th>
                        <th>PAN Card</th>
                        <th>Marksheet</th>
                        <th>Resume</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<DocumentApproval> documentApprovals = (List<DocumentApproval>) request.getAttribute("pendingDocumentApprovals");
                        if (documentApprovals != null) {
                            for (DocumentApproval approval : documentApprovals) {
                    %>
                    <tr>
                        <td><%= approval.getEmployeeId() %></td>
                        <td><%= approval.getEmployeeName() %></td>
                        <td><%= approval.getPhoneNum() %></td>
                        <td><%= approval.getAadharNum() %></td>
                        <td><%= approval.getPanNum() %></td>
                        <td>
                            <img src="data:image/jpeg;base64,<%= convertBlobToBase64(approval.getAadharImg()) %>" alt="Aadhar Image" width="100" height="100"/>
                        </td>
                        <td>
                            <img src="data:image/jpeg;base64,<%= convertBlobToBase64(approval.getPanImg()) %>" alt="PAN Image" width="100" height="100"/>
                        </td>
                        <td>
                            <img src="data:image/jpeg;base64,<%= convertBlobToBase64(approval.getMarksheet()) %>" alt="Marksheet" width="100" height="100"/>
                        </td>
                        <td>
                            <a href="data:application/pdf;base64,<%= convertBlobToBase64(approval.getResume()) %>" target="_blank">View Resume</a>
                        </td>
                        <td>
                            <form action="HRDashboardServlet" method="post">
                                <input type="hidden" name="action" value="approveDocuments">
                                <input type="hidden" name="employeeId" value="<%= approval.getEmployeeId() %>">
                                <input type="submit" value="Approve">
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </section>

        <footer>
            <a class="logout" href="LogoutServlet">Logout</a>
        </footer>
    </div>
</body>
</html>

<%!
    private String convertBlobToBase64(Blob blob) {
        String base64Image = "";
        try {
            if (blob != null) {
                byte[] bytes = blob.getBytes(1, (int) blob.length());
                base64Image = Base64.getEncoder().encodeToString(bytes);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return base64Image;
    }
%>
