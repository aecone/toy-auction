<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/7/24
  Time: 2:58 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Login Form</title>
</head>
<body>
<form action="checkLoginDetails.jsp" method="POST">
    Username: <input type="text" name="username"/> <br/>
    Password: <input type="password" name="password"/> <br/>
    <input type="submit" value="Log In"/>
</form>
<br>
<a href="createAccount.jsp">Create Account</a>
</body>
</html>
