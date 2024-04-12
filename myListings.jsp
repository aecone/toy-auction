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
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>My Listings</title>
    <script>
        window.onload = function() {
            // Get all table rows
            var rows = document.querySelectorAll('table tr[data-href]');
            // Add click event listener to each row
            rows.forEach(function(row) {
                row.addEventListener('click', function() {
                    // Get the value of the data-href attribute
                    var href = row.getAttribute('data-href');
                    // Navigate to the specified URL
                    window.location.href = href;
                });
            });
        };
    </script>
</head>
<body>

<%
    // Get current user's username
    String username = (String) session.getAttribute("user");

// Create a connection to the database
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    try {

        // Prepare and execute SQL query to fetch toy listings for the current user
        String query = "SELECT * FROM toy_listing WHERE username = ?";
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        ResultSet rs = pstmt.executeQuery();

        // Display the data in a table
        out.println("<table>");
        out.println("<tr><th>Category</th><th>Name</th><th>Initial Price</th><th>Increment</th><th>Secret Min Price</th><th>Start Date Time</th><th>Closing Date Time</th></tr>");
        while (rs.next()) {
            String category = rs.getString("category");

            int id = rs.getInt("toy_id");
            String url = "myListingDetails.jsp?id=" + id + "&category=" + category;
            out.println("<tr data-href=\"" + url + "\">");
            category = category.replace("_"," ");
            out.println("<td>" + category + "</td>");
            out.println("<td>" + rs.getString("name") + "</td>");
            out.println("<td>" + rs.getDouble("initial_price") + "</td>");
            out.println("<td>" + rs.getDouble("increment") + "</td>");
//            out.println("<td>" + rs.getInt("start_age") + "</td>");
//            out.println("<td>" + rs.getInt("end_age") + "</td>");
            out.println("<td>" + rs.getDouble("secret_min_price") + "</td>");
            out.println("<td>" + rs.getTimestamp("start_datetime") + "</td>");
            out.println("<td>" + rs.getTimestamp("closing_datetime") + "</td>");
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
<br>
<a href="success.jsp">Home</a>

</body>
</html>
