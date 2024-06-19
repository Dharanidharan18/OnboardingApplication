<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.Blob, com.onboardApplication.java.Employee, com.onboardApplication.java.DocumentApproval"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

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
