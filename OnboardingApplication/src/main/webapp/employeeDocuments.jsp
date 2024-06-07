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
    Boolean isApproved = (Boolean) request.getAttribute("isApproved");
    if (name == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
    <h2>Welcome, <%= name %></h2>
    
    <%
        if (isApproved != null && !isApproved) {
    %>
        <form action="UploadDocumentsServlet" method="post" enctype="multipart/form-data">
            <h3>Upload Your Documents</h3>
            Aadhar Card: <input type="file" name="aadhar_img" required><br>
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
</body>
</html>
