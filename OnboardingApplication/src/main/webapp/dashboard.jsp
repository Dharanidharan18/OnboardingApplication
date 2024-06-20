<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Blob" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.util.*, java.sql.Blob, com.onboardApplication.java.Employee, com.onboardApplication.java.DocumentApproval"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" href="index.css">
    <link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.0/css/line.css">

    <title>HR Dashboard</title>
    <style>
        .content-section {
            display: none;
        }
        .active {
            display: block;
        }
        .dropdown {
            position: relative;
            display: inline-block;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
        }
        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }
        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }
        .dropdown:hover .dropdown-content {
            display: block;
        }
    </style>
    <script>
        function showSection(sectionId) {
            const sections = document.querySelectorAll('.content-section');
            sections.forEach(section => {
                section.classList.remove('active');
            });
            document.getElementById(sectionId).classList.add('active');
        }
    </script>
</head>
<body>
    <nav>
        <div class="logo-name">
            <div class="">
                <img src="" alt="">
            </div>
        </div>
        <div class="menu-items">
            <ul class="nav-links">
                <li><a href="#" onclick="showSection('dashboard-section')">
                    <i class="uil uil-estate"></i>
                    <span class="link-name">Dashboard</span>
                </a></li>
                <li class="dropdown">
                    <a href="#" onclick="event.preventDefault()">
                        <i class="uil uil-files-landscapes"></i>
                        <span class="link-name">Documents</span>
                    </a>
                    <div class="dropdown-content">
                        <a href="#" onclick="showSection('approved-documents-section')">Approved Documents</a>
                        <a href="#" onclick="showSection('pending-documents-section')">Pending Documents</a>
                    </div>
                </li>
                <li><a href="#" onclick="showSection('new-employee-section')">
                    <i class="uil uil-chart"></i>
                    <span class="link-name">Add New Employee</span>
                </a></li>
                <li><a href="#" onclick="showSection('projects-section')">
                    <i class="uil uil-thumbs-up"></i>
                    <span class="link-name">Assign To Projects</span>
                </a></li>
                <li><a href="#" onclick="showSection('employees-section')">
                    <i class="uil uil-comments"></i>
                    <span class="link-name">List Of Employees</span>
                </a></li>
                <li><a href="#" onclick="showSection('share-section')">
                    <i class="uil uil-share"></i>
                    <span class="link-name">Share</span>
                </a></li>
            </ul>
            
            <ul class="logout-mode">
                <li><a href="LogoutServlet">
                    <i class="uil uil-signout"></i>
                    <span class="link-name">Logout</span>
                </a></li>

                <!-- <li class="mode">
                    <a href="#">
                        <i class="uil uil-moon"></i>
                    <span class="link-name">Dark Mode</span>
                </a>
                <div class="mode-toggle">
                    <span class="switch"></span>
                </div>
            </li>
 -->            </ul>
        </div>
    </nav>

    <section class="dashboard">
        <div class="top">
            <i class="uil uil-bars sidebar-toggle"></i>
            <div class="search-box">
                <i class="uil uil-search"></i>
                <input type="text" placeholder="Search here...">
            </div>
        </div>

        <div class="dash-content">
            <!-- Dashboard Section -->
            <div id="dashboard-section" class="content-section active">
                <div class="overview">
                    <div class="title">
                        <i class="uil uil-tachometer-fast-alt"></i>
                        <span class="text">Dashboard</span>
                    </div>
                    <div class="boxes">
                        <div class="box box1">
                           <!-- <i class="uil uil-thumbs-up"></i>  --> 
                            <span class="text">Total Employees</span>
                            <span class="number">120</span>
                        </div>
                        <div class="box box2">
                            <i class="uil uil-comments"></i>
                            <span class="text">Comments</span>
                            <span class="number">20</span>
                        </div>
                       <!--  <div class="box box3">
                            <i class="uil uil-share"></i>
                            <span class="text">Total Share</span>
                            <span class="number">10,120</span>
                        </div> -->
                    </div>
                </div>
            </div>

            <!-- Documents Sections -->
            <div id="approved-documents-section" class="content-section">
                <div class="title">
                    <i class="uil uil-check-circle"></i>
                    <span class="text">Approved Documents</span>
                </div>
                <!-- Add content for approved documents section here -->
                 <thead>
            <tr>
                <th>Employee ID</th>
                <th>Employee Name</th>
                <th>Phone Number</th>
                <th>Aadhar Number</th>
                <th>PAN Number</th>
                <th>Aadhar Image</th>
                <th>PAN Image</th>
                <th>Marksheet</th>
                <th>Resume</th>
            </tr>
        </thead>
        <tbody>
            <% 
                // Get the list of approved documents from request attribute
                List<DocumentApproval> approvedDocuments = (List<DocumentApproval>) request.getAttribute("approve");
                if (approvedDocuments != null && !approvedDocuments.isEmpty()) {
                    for (DocumentApproval document : approvedDocuments) {
            %>
                        <tr>
                            <td><%= document.getEmployeeId() %></td>
                            <td><%= document.getEmployeeName() %></td>
                            <td><%= document.getPhoneNum() %></td>
                            <td><%= document.getAadharNum() %></td>
                            <td><%= document.getPanNum() %></td>
                            <td><%= displayBlobData(document.getAadharImg(),"image") %></td>
                            <td><%= displayBlobData(document.getPanImg(),"image") %></td>
                            <td><%= displayBlobData(document.getMarksheet(),"image") %></td>
                            <td><%= displayBlobData(document.getResume(),"image") %></td>
                        </tr>
            <% 
                    }
                } else {
            %>
                    <tr>
                        <td colspan="9">No approved documents found.</td>
                    </tr>
            <% 
                }
            %>
        </tbody>
            </div>

            <div id="pending-documents-section" class="content-section">
                <div class="title">
                    <i class="uil uil-clock"></i>
                    <span class="text">Pending Documents</span>
                </div>
                <!-- Add content for pending documents section here -->
               
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
            </div>

            <!-- Add New Employee Section -->
            <div id="new-employee-section" class="content-section">
                <div class="title">
                    <i class="uil uil-chart"></i>
                    <span class="text">Add New Employee</span>
                </div>
                <!-- Add content for new employee section here -->
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
            </div>

            <!-- Assign To Projects Section -->
            <div id="projects-section" class="content-section">
                <div class="title">
                    <i class="uil uil-thumbs-up"></i>
                    <span class="text">Assign To Projects</span>
                </div>
                <!-- Add content for projects section here -->
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

            <!-- List Of Employees Section -->
            <div id="employees-section" class="content-section">
                <div class="title">
                    <i class="uil uil-comments"></i>
                    <span class="text">List Of Employees</span>
                </div>
                <!-- Add content for list of employees section here -->
                <tr>
                <th>Employee ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Username</th>
                <th>Status</th>
                <th>Asset ID</th>
                <th>Date Asset Assigned</th>
            </tr>
        </thead>
        <tbody>
            <% 
                 employees = (List<Employee>) request.getAttribute("employees");
                if (employees != null && !employees.isEmpty()) {
                    for (Employee employee : employees) {
            %>
            <tr>
                <td><%= employee.getId() %></td>
                <td><%= employee.getName() %></td>
                
            </tr>
            <% 
                    }
                } else {
            %>
            <tr>
                <td colspan="7">No employees found.</td>
            </tr>
            <% } %>
        </tbody>
            </div>

            <!-- Share Section -->
            <div id="share-section" class="content-section">
                <div class="title">
                    <i class="uil uil-share"></i>
                    <span class="text">Share</span>
                </div>
                <!-- Add content for share section here -->
            </div>
        </div>
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
<%! 
    private String displayBlobData(Blob blob, String type) {
        if (blob == null) {
            return "No " + type + " available";
        }

        try {
            byte[] bytes = blob.getBytes(1, (int) blob.length());
            String base64Data = Base64.getEncoder().encodeToString(bytes);

            if ("image".equalsIgnoreCase(type)) {
                // Display image
                return "<img src='data:image/jpeg;base64," + base64Data + "' alt='Image' style='max-width: 200px; max-height: 200px;' />";
            } else {
                // For other types (e.g., documents), provide a download link
                return "<a href='data:application/octet-stream;base64," + base64Data + "' download='" + type + ".dat'>Download " + type + "</a>";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error retrieving " + type;
        }
    }
%>

