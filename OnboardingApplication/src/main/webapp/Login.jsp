<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Form</title>
    <link rel="stylesheet" href="Login.css">
</head>

<body>
    <div class="container">
        <div class="login-box">
            <h2>Login</h2>
            <form action="LoginServlet" method="post">
                <div class="input-box">
                    <input type="text" id="username" name="username" required>
                    <label>User Name</label>
                </div>
                <div class="input-box">
                    <input type="password" id="password" name="password" required>
                    <label>Password</label>
                </div>
                
                <button type="submit" class="btn">Login</button>
                
            </form>
            
             <%
            String error = request.getParameter("error");
            if ("1".equals(error)) {
                out.println("<div class='error'>Invalid User ID or Password. Please try again.</div>");
            }
        %>
        </div>

       
       
    </div>
</body>

</html>
