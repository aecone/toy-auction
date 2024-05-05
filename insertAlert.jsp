<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<html>
<head>
    <title>Insert Custom Alert</title>
</head>
<%
    // Get parameters from the HTML form at createCustomAlert.jsp
    String alertName = request.getParameter("alertName");
    String category = request.getParameter("category");
    double maxPrice = Double.parseDouble(request.getParameter("maxPrice"));
    double minPrice = Double.parseDouble(request.getParameter("minPrice"));
    int startAge = Integer.parseInt(request.getParameter("startAge"));
    int endAge = Integer.parseInt(request.getParameter("endAge"));
    String customAlert = request.getParameter("customAlert");

    try {
        // Get the database connection
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();

        // Create and execute the SQL INSERT statement
        String sql = "INSERT INTO alert (name, category, max_price, min_price,age_range, username, is_custom_alert) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, alertName);
        pstmt.setString(2, category);
        pstmt.setDouble(3, maxPrice);
        pstmt.setDouble(4, minPrice);
        pstmt.setString(5, startAge + "-" + endAge);
        pstmt.setString(6, session.getAttribute("user").toString());
        pstmt.setString(7, customAlert);

        pstmt.executeUpdate();

        // Close the resources
        pstmt.close();
        conn.close();

    out.println("<h2>Custom alert successfully created!</h2>");

        // Redirect to myAlerts.jsp
        response.sendRedirect("myCustomAlerts.jsp");

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<body>
</body>
</html>