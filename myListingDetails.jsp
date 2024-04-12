<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/11/24
  Time: 11:56 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<html>
<head>
    <title>Details</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<%
    String id = request.getParameter("id");
    String category = request.getParameter("category");
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    try {

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // Query to retrieve details for listing
        String query = "SELECT * FROM toy_listing WHERE toy_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();

        int startAge = 0;
        int endAge = 0;
        out.println("<table>");
        out.println("<tr style=\"pointer-events: none\"><th>Category</th><th>Name</th><th>Initial Price</th><th>Increment</th><th>Secret Min Price</th><th>Start Date Time</th><th>Closing Date Time</th></tr>");
        if(rs.next()) {
            String categoryStr = category.replace("_"," ");
            startAge = rs.getInt("start_age");
            endAge = rs.getInt("end_age");

            out.println("<td>" + categoryStr + "</td>");
            out.println("<td>" + rs.getString("name") + "</td>");
            out.println("<td>" + rs.getDouble("initial_price") + "</td>");
            out.println("<td>" + rs.getDouble("increment") + "</td>");
            out.println("<td>" + rs.getDouble("secret_min_price") + "</td>");
            out.println("<td>" + rs.getTimestamp("start_datetime") + "</td>");
            out.println("<td>" + rs.getTimestamp("closing_datetime") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        //get category details
        query = "SELECT * FROM "+category+" WHERE toy_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();

        out.println("<br/><p>Age Range: " + startAge+" - "+endAge + "</p>");
        // Display details from category table
        if (rs.next()) {
            if (category.equals("action_figure")) {
                double height = rs.getDouble("height");
                boolean canMove = rs.getBoolean("can_move");
                String characterName = rs.getString("character_name");
                // Display action figure details
                out.println("<p>Height: " + height + "</p>");
                out.println("<p>Can Move: " + canMove + "</p>");
                out.println("<p>Character Name: " + characterName + "</p>");
            } else if (category.equals("board_game")) {
                int playerCount = rs.getInt("player_count");
                String brand = rs.getString("brand");
                boolean isCardsGame = rs.getBoolean("is_cards_game");
                // Display board game details
                out.println("<p>Player Count: " + playerCount + "</p>");
                out.println("<p>Brand: " + brand + "</p>");
                out.println("<p>Is Cards Game: " + isCardsGame + "</p>");
            } else if (category.equals("stuffed_animal")) {
                String color = rs.getString("color");
                String brand = rs.getString("brand");
                String animal = rs.getString("animal");
                // Display stuffed animal details
                out.println("<p>Color: " + color + "</p>");
                out.println("<p>Brand: " + brand + "</p>");
                out.println("<p>Animal: " + animal + "</p>");
            }
        } else {
            out.println("<p>Listing not found.</p>");
        }
        rs.close();
        pstmt.close();
        conn.close();
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }

%>
<a href="myListings.jsp">Back to My Listings</a>
</body>
</html>
