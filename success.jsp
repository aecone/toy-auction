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
You are not logged in<br/>
<a href="login.jsp">Please Login</a>
<%} else {
%>
Welcome, <%=session.getAttribute("user")
//this will display the username that is stored in the session.
%>!
<br>
<%
    // Check if the username is not "admin"
    if (!"admin".equals(session.getAttribute("user"))) {
%>
<a href='createListing.jsp'>Create a Listing</a>
<br>
<a href='myListings.jsp'>My Listings</a>
<br>
<%
    } else {
        // when the username is "admin"
        out.println("admin tools");
    }
%><br>

<a href='logout.jsp'>Log Out</a>
<%
    }
%>

</body>
</html>
