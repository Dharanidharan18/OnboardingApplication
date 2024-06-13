<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Blob" %>
<%@ page import="com.onboardApplication.java.Employee" %>
<%@ page import="com.onboardApplication.java.DocumentApproval" %>
<!DOCTYPE html>
<html>

<head>
    <title>HR Dashboard</title>
    <link rel="stylesheet" href="hrDashboard.css">
</head>
<body> 
    <h2>Welcome, <%= session.getAttribute("username") %></h2>

    <h3>Register New Employee</h3>
    <form action="HRDashboardServlet" method="post">
        <input type="hidden" name="action" value="registerEmployee">
        <label for="name">Name:</label>
        <input type="text" id="name" name="employee_name" required><br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br>
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        <input type="submit" value="Register Employee">
    </form>

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
        </select><br>

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
        </select><br>

        <label for="projectName">Project Name:</label>
        <input type="text" id="projectName" name="projectName" required><br>
        <input type="submit" value="Assign Project">
    </form>

    <h3>Pending Document Approvals</h3>
    <table>
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
                <a href="data:application/pdf;base64,<%= convertBlobToBase64(approval.getResume()) %>" target="_blank">View Resume</a>            </td>
            <td>
                <form action="HRDashboardServlet" method="post" style="display:inline;">
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
    </table>

    <a  class = "logout" href="LogoutServlet">Logout</a>

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
