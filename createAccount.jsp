<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/12/24
  Time: 1:55 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import ="java.sql.*" %>
<!DOCTYPE html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Create Account</title>
</head>
<body>
<div class="center-texts">
<form action="insertAcc.jsp" id = "accInfo" method="POST" onsubmit="return validateForm()">
    Username: <input type="text" name="username"/>  <br>
    Password: <input type="password" name="password"/>  <br>
    <br>
    <input type="submit" value="Create Account"/>
</form> <br>
<a href="login.jsp">Cancel</a>
<script>
    function validateForm() {
        var form = document.getElementById("accInfo");
        var inputs = form.getElementsByTagName("input");
        for (var i = 0; i < inputs.length; i++) {
            if (inputs[i].value.trim() === "") {
                alert("Please fill in all fields: "+inputs[i].name+" is missing.");
                return false; // Prevent form submission
            }
        }

        return true; // Allow form submission
    }
</script>
</div>
</body>

</html>
