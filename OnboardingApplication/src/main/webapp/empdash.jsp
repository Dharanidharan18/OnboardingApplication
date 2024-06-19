<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                <!-- Add content for approved documents section here -->
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
                <!-- Add content for new employee section here -->
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
