<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="com.onboardApplication.java.Task" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" href="index.css">
    <link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.0/css/line.css">
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

    <title>Employee Dashboard</title>
    <style>
        .content-section {
            display: none;
            opacity: 0;
            transition: opacity 0.5s ease, max-height 0.5s ease;
            max-height: 0;
            overflow: hidden;
        }
        .content-section.active {
            display: block;
            opacity: 1;
            max-height: 1000px; /* Adjust as necessary */
        }
        .dropdown {
            position: relative;
            display: inline-block;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 200px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            white-space: nowrap;
        }
        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: inline-block;
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
            const targetSection = document.getElementById(sectionId);
            targetSection.classList.add('active');
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
                        <i class="uil uil-chart"></i>
                        <span class="link-name">View Task</span>
                    </a>
                    <div class="dropdown-content">
                        <a href="#" onclick="showSection('approved-documents-section')">Approved Task</a>
                        <a href="#" onclick="showSection('pending-documents-section')">Pending Task</a>
                    </div>
                </li>
                <li><a href="#" onclick="showSection('new-employee-section')">
                    <i class="uil uil-files-landscapes"></i>
                    <span class="link-name">Upload Documents</span>
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

                <li class="mode">
                    <a href="#">
                        <i class="uil uil-moon"></i>
                    <span class="link-name">Dark Mode</span>
                </a>
                <div class="mode-toggle">
                    <span class="switch"></span>
                </div>
            </li>
            </ul>
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
                            <i class="uil uil-thumbs-up"></i>
                            <span class="text">Total Likes</span>
                            <span class="number">50,120</span>
                        </div>
                        <div class="box box2">
                            <i class="uil uil-comments"></i>
                            <span class="text">Comments</span>
                            <span class="number">20,120</span>
                        </div>
                        <div class="box box3">
                            <i class="uil uil-share"></i>
                            <span class="text">Total Share</span>
                            <span class="number">10,120</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Documents Sections -->
            <div id="approved-documents-section" class="content-section">
                <div class="title">
                    <i class="uil uil-check-circle"></i>
                    <span class="text">Approved Tasks</span>
                </div>
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
            </div>

            <div id="pending-documents-section" class="content-section">
                <div class="title">
                    <i class="uil uil-clock"></i>
                    <span class="text">Pending Tasks</span>
                </div>
                <!-- Add content for pending documents section here -->
            </div>

            <!-- Add New Employee Section -->
            <div id="new-employee-section" class="content-section">
                <div class="title">
                    <i class="uil uil-chart"></i>
                    <span class="text">Upload Documents</span>
                </div>
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
            </div>

            <!-- Assign To Projects Section -->
            <div id="projects-section" class="content-section">
                <div class="title">
                    <i class="uil uil-thumbs-up"></i>
                    <span class="text">Assign To Projects</span>
                </div>
                <!-- Add content for projects section here -->
            </div>

            <!-- List Of Employees Section -->
            <div id="employees-section" class="content-section">
                <div class="title">
                    <i class="uil uil-comments"></i>
                    <span class="text">List Of Employees</span>
                </div>
                <!-- Add content for list of employees section here -->
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
