<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/8/24
  Time: 1:56 PM
  insert the listing into toy_listing under the user
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<html>
<head>
    <title>Title</title>
</head>
<%
//Get parameters from the HTML form at createListing.jsp
  String name = request.getParameter("name");
  String category = request.getParameter("category");
  int startAge = Integer.parseInt(request.getParameter("start_age"));
  int endAge = Integer.parseInt(request.getParameter("end_age"));
  double price = Double.parseDouble(request.getParameter("price"));
  double increment = Double.parseDouble(request.getParameter("increment"));
  double minPrice = Double.parseDouble(request.getParameter("min_price"));
  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
  // Parse the string to a LocalDateTime object
  LocalDateTime endDT = LocalDateTime.parse(request.getParameter("endDT"), formatter);
  LocalDateTime startDT = LocalDateTime.now();
  try {

    //Get the database connection
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();

// Create and execute the SQL INSERT statement
String sql = "INSERT INTO toy_listing (initial_price, name, start_age, end_age, secret_min_price, closing_datetime, increment, start_datetime, username) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setDouble(1, price);
pstmt.setString(2, name);
pstmt.setInt(3, startAge);
pstmt.setInt(4, endAge);
pstmt.setDouble(5, minPrice);
pstmt.setTimestamp(6, Timestamp.valueOf(endDT));
pstmt.setDouble(7, increment);
pstmt.setTimestamp(8, Timestamp.valueOf(startDT));
pstmt.setString(9,session.getAttribute("user").toString());

pstmt.executeUpdate();

// Close the resources
pstmt.close();
conn.close();

response.sendRedirect("myListings.jsp");
} catch (Exception e) {
out.println("Error: " + e.getMessage());
}
%>
<body>

</body>
</html>
