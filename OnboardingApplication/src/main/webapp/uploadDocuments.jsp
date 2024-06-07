<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <title>Upload Documents</title>
</head>
<body>
    <h2>Upload Your Documents</h2>
    <form action="UploadDocumentsServlet" method="post" enctype="multipart/form-data">
        Aadhar Card: <input type="file" name="aadhar_img" required><br>
        PAN Card: <input type="file" name="pan_img" required><br>
        Marksheet: <input type="file" name="marksheet" required><br>
        Resume: <input type="file" name="resume" required><br>
        <input type="submit" value="Upload">
    </form>
</body>
</html>
