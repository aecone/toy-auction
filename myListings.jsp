<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/8/24
  Time: 12:47 PM
  all of current user's listings
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<html>
<head>
    <title>My Listings</title>
</head>
<body>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

<%
    // Get current user's username
    String username = (String) session.getAttribute("user");

// Create a connection to the database
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    try {

        // Prepare and execute SQL query to fetch toy listings for the current user
        String query = "SELECT * FROM Toy_Listing WHERE username = ?";
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        ResultSet rs = pstmt.executeQuery();

        // Display the data in a table
        out.println("<table border='1'>");
        out.println("<tr><th>Name</th><th>Initial Price</th><th>Start Age</th><th>End Age</th><th>Secret Min Price</th><th>Closing Date Time</th><th>Increment</th><th>Start Date Time</th></tr>");
        while (rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getString("name") + "</td>");
            out.println("<td>" + rs.getDouble("initial_price") + "</td>");
            out.println("<td>" + rs.getInt("start_age") + "</td>");
            out.println("<td>" + rs.getInt("end_age") + "</td>");
            out.println("<td>" + rs.getDouble("secret_min_price") + "</td>");
            out.println("<td>" + rs.getTimestamp("closing_datetime") + "</td>");
            out.println("<td>" + rs.getDouble("increment") + "</td>");
            out.println("<td>" + rs.getTimestamp("start_datetime") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");

        // Close resources
        rs.close();
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle any exceptions
    } finally {
        // Ensure resources are closed even in case of exceptions
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

</body>
</html>
