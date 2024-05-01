<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/14/24
  Time: 12:01 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Browse Listings</title>
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

// Create a connection to the database
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    try {

        // Prepare and execute SQL query to fetch toy listings
        String query = "SELECT * FROM toy_listing";
        PreparedStatement pstmt = conn.prepareStatement(query);
        ResultSet rs = pstmt.executeQuery();
        if(!rs.next()){
            out.println("There are no listings.");
        }
        else {
            // Display the data in a table
            out.println("<table>");
            out.println("<tr><th>Category</th><th>Name</th><th>Age Range</th><th>Initial Price</th><th>Increment</th><th>Start Date Time</th><th>Closing Date Time</th></tr>");
            while (rs.next()) {
                String category = rs.getString("category");

                int id = rs.getInt("toy_id");
                String url = "listingDetails.jsp?id=" + id + "&category=" + category;
                out.println("<tr data-href=\"" + url + "\">");
                category = category.replace("_", " ");
                out.println("<td>" + category + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getInt("start_age") +" - "+ rs.getInt("end_age")+"</td>");
                out.println("<td>" + rs.getDouble("initial_price") + "</td>");
                out.println("<td>" + rs.getDouble("increment") + "</td>");

                LocalDateTime startTime = rs.getTimestamp("start_datetime").toLocalDateTime();
                // Define the format with AM/PM and without seconds
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm a");
                // Format the datetime using the formatter
                String startDT = startTime.format(formatter);
                out.println("<td>" + startDT + "</td>");
                LocalDateTime endTime = rs.getTimestamp("closing_datetime").toLocalDateTime();
                String endDT = endTime.format(formatter);
                out.println("<td>" + endDT + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
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
<p>
<a href="CustomerMain.jsp">Home</a>
</p>
</body>
</html>

