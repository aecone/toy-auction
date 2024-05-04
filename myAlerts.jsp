<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>General Alerts</title>
   <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h1>Alerts</h1>
    <h2>Bids that closed when you entered them:</h2>
    <ul>
        <%-- Display bids that closed when the user entered them --%>
        <%
            // Get current user's username
            String username = (String) session.getAttribute("user");

            // Create a connection to the database
            ApplicationDB db = new ApplicationDB();
            Connection conn = db.getConnection();
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                String query = "SELECT * FROM bid WHERE username = ? AND time < (SELECT closing_datetime FROM toy_listing WHERE toy_id = bid.toy_id)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, username);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    // Display bid information
                    out.println("<li>Bid ID: " + rs.getInt("b_id") + ", Price: " + rs.getDouble("price") + "</li>");

                    // Insert into alert table
                    String alertMessage = "Bid ID " + rs.getInt("b_id") + " closed when you entered it.";
                    String sql = "INSERT INTO alert (name, max_price, category, min_price, age_range, username) VALUES (?, ?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, alertMessage);
                    pstmt.setDouble(2, 0.0);
                    pstmt.setString(3, "");
                    pstmt.setDouble(4, 0.0);
                    pstmt.setString(5, "");
                    pstmt.setString(6, username);
                    pstmt.executeUpdate();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </ul>

    <h2>Bids when someone else bid higher than you:</h2>
    <ul>
        <%-- Display bids when someone else bid higher than the user --%>
        <%
            username = (String) session.getAttribute("user");

            db = new ApplicationDB();
            conn = db.getConnection();
            pstmt = null;

            try {
                String query = "SELECT * FROM bid b1 WHERE username != ? AND price > (SELECT price FROM bid b2 WHERE b2.toy_id = b1.toy_id AND b2.username = ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, username);
                pstmt.setString(2, username);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    // Display bid information
                    out.println("<li>Bid ID: " + rs.getInt("b_id") + ", Price: " + rs.getDouble("price") + "</li>");

                    // Insert into alert table
                    String alertMessage = "Another user bid higher than you on Bid ID " + rs.getInt("b_id");
                    String insertQuery = "INSERT INTO alert (name, max_price, category, min_price, age_range, username) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                    insertStmt.setString(1, alertMessage);
                    insertStmt.setDouble(2, 0.0);
                    insertStmt.setString(3, "");
                    insertStmt.setDouble(4, 0.0);
                    insertStmt.setString(5, "");
                    insertStmt.setString(6, username);
                    insertStmt.executeUpdate();
                    insertStmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </ul>

    <h2>Bids that ended:</h2>
    <ul>
        <%-- Display bids for listings that have ended --%>
        <%
            // Get current user's username
            username = (String) session.getAttribute("user");

            db = new ApplicationDB();
            conn = db.getConnection();
            pstmt = null; // Reset pstmt

            try {
                String query = "SELECT * FROM bid WHERE time < (SELECT closing_datetime FROM toy_listing WHERE toy_id = bid.toy_id)";
                pstmt = conn.prepareStatement(query);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    // Display bid information
                    out.println("<li>Bid ID: " + rs.getInt("b_id") + ", Price: " + rs.getDouble("price") + "</li>");

                    // Insert into alert table
                    String alertMessage = "Bid ID " + rs.getInt("b_id") + " has ended.";
                    String insertQuery = "INSERT INTO alert (name, max_price, category, min_price, age_range, username) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                    insertStmt.setString(1, alertMessage);
                    insertStmt.setDouble(2, 0.0);
                    insertStmt.setString(3, "");
                    insertStmt.setDouble(4, 0.0);
                    insertStmt.setString(5, "");
                    insertStmt.setString(6, username);
                    insertStmt.executeUpdate();
                    insertStmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
        <br>
        <p>
        <a href="CustomerMain.jsp">Home</a>
        </p>
</body>
