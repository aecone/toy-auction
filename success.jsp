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
    <title>Title</title>
</head>
<body>
<%
    if ((session.getAttribute("user") == null)) {
%>
You are not logged in<br/>
<a href="login.jsp">Please Login</a>
<%} else {
%>
Welcome <%=session.getAttribute("user")
//this will display the username that is stored in the session.
%>
<a href='logout.jsp'>Log out</a>
<%
    }
%>

</body>
</html>
