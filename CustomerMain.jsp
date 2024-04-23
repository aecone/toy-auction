<%--
  Created by IntelliJ IDEA.
  User: adam
  Date: 4/7/24
  Time: 3:58 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<%
    if ((session.getAttribute("user") == null)) {
%>
<div class="center-texts">
    You are not logged in <br>
    <a href="login.jsp">Please Login</a>
</div>
<%
} else {
%>
<div class="center-texts">
    Welcome, <%=session.getAttribute("user") %>!<br><br>
<%
    // Check if the username is not "admin"
    if (!"admin".equals(session.getAttribute("user"))) {
%>
    <a href="browseListings.jsp">Browse Listings</a><br>
    <a href='createListing.jsp'>Create a Listing</a><br>
    <a href='myListings.jsp'>My Listings</a><br>
</div>
<%
} else {
    // when the username is "admin"
%>
<div class="center-texts">
    admin tools<br>
</div>
<%
    }
%>
<div class="center-texts">
    <a href='logout.jsp'>Log Out</a>
</div>
<%
    }
%>
</body>
</html>

