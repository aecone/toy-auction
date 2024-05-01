<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/14/24
  Time: 12:40 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<html>
<head>
    <title>Details</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<%
    String id = request.getParameter("id");
    String category = request.getParameter("category");

    String url = "listingDetails.jsp?id=" + id + "&category=" + category;
    out.println("Error in placing bid.");
    out.println("<a href=\"" + url + "\">Back to Listing Details</a> <br>");

%>
<a href="browseListings.jsp">Back to All Listings</a>
</body>
</html>


