<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="com.onboardApplication.java.Employee" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" href="index.css">
    <link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.0/css/line.css">
     

    <title>Manager Dashboard</title>
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
                <li><a href="#" onclick="showSection('new-employee-section')">
                    <i class="uil uil-files-landscapes"></i>
                    <span class="link-name">Assign Tasks</span>
                </a></li>
                <li><a href="#" onclick="showSection('projects-section')">
                    <i class="uil uil-thumbs-up"></i>
                    <span class="link-name">Approve Tasks</span>
                </a></li>
                <li><a href="#" onclick="showSection('employees-section')">
                    <i class="uil uil-comments"></i>
                    <span class="link-name">List Of Employees</span>
                </a></li>
                <li><a href="#" onclick="showSection('evaluate-section')">
                    <i class="uil uil-share"></i>
                    <span class="link-name">Evaluate Employees</span>
                </a></li>
                <li><a href="#" onclick="showSection('bench-section')">
                    <i class="uil uil-share"></i>
                    <span class="link-name">Employees On Bench</span>
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

            <!-- Approved Tasks Section -->
            <div id="approved-documents-section" class="content-section">
                <div class="title">
                    <i class="uil uil-check-circle"></i>
                    <span class="text">Approved Tasks</span>
                </div>
            </div>

            <!-- Pending Tasks Section -->
            <div id="pending-documents-section" class="content-section">
                <div class="title">
                    <i class="uil uil-clock"></i>
                    <span class="text">Pending Tasks</span>
                </div>
            </div>

            <!-- Assign Task to Employee Section -->
            <div id="new-employee-section" class="content-section">
                <div class="title">
                    <i class="uil uil-chart"></i>
                    <span class="text">Assign Task to Employee</span>
                </div>
                <form action="ManagerDashboardServlet" method="post" onsubmit="return validateTaskForm()">
                    <input type="hidden" name="action" value="assignTask">
                    <label for="employeeId">Employee ID:</label>
                    <input type="text" id="employeeId" name="employeeId" required><br>
                    <label for="task">Task:</label>
                    <textarea id="task" name="task" required></textarea><br>
                    <label for="dueDate">Due Date:</label>
                    <input type="datetime-local" id="dueDate" name="dueDate" required><br>
                    <input type="submit" value="Assign Task">
                </form>
            </div>

            <!-- Approve Tasks Section -->
            <div id="projects-section" class="content-section">
                <div class="title">
                    <i class="uil uil-thumbs-up"></i>
                    <span class="text">Approve Tasks</span>
                </div>
                <form action="ManagerDashboardServlet" method="post">
                    <input type="hidden" name="action" value="approveTask">
                    <label for="taskId">Task ID:</label>
                    <input type="text" id="taskId" name="taskId" required><br>
                    <input type="submit" value="Approve Task">
                </form>
            </div>

            <!-- List of Employees Section -->
            <div id="employees-section" class="content-section">
                <div class="title">
                    <i class="uil uil-comments"></i>
                    <span class="text">List Of Employees</span>
                </div>
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
            </div>

            <!-- Evaluate Employees Section -->
            <div id="evaluate-section" class="content-section">
                <div class="title">
                    <i class="uil uil-share"></i>
                    <span class="text">Evaluate Employees</span>
                </div>
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
            </div>
            
            <!-- Employees On Bench Section -->
            <div id="bench-section" class="content-section">
                <div class="title">
                    <i class="uil uil-share"></i>
                    <span class="text">Employees On Bench</span>
                </div>
                <table border="1">
                    <tr>
                        <th>Employee ID</th>
                        <th>Employee Name</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Certification Type</th>
                        <th>Completion of Certification</th>
                    </tr>
                    <%
                        List<Employee> employeesOnBench = (List<Employee>) request.getAttribute("employeesOnBench");
                        if (employeesOnBench != null) {
                            for (Employee employee : employeesOnBench) {
                    %>
                    <tr>
                        <td><%= employee.getId() %></td>
                        <td><%= employee.getName() %></td>
                        <td><%= employee.getStartDate() != null ? employee.getStartDate() : "" %></td>
                        <td><%= employee.getEndDate() != null ? employee.getEndDate() : "" %></td>
                        <td><%= employee.getCertificationType() != null ? employee.getCertificationType() : "" %></td>
                        <td><%= employee.getCompletionOfCertification() %></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </table>
            </div>
        </div>
    </section>
</body>
</html>
