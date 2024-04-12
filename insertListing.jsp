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
String sql = "INSERT INTO toy_listing (initial_price,category, name, start_age, end_age, secret_min_price, closing_datetime, increment, start_datetime, username) VALUES (?,?, ?, ?, ?, ?, ?, ?, ?, ?)";
PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
pstmt.setDouble(1, price);
pstmt.setString(2, category);
pstmt.setString(3, name);
pstmt.setInt(4, startAge);
pstmt.setInt(5, endAge);
pstmt.setDouble(6, minPrice);
pstmt.setTimestamp(7, Timestamp.valueOf(endDT));
pstmt.setDouble(8, increment);
pstmt.setTimestamp(9, Timestamp.valueOf(startDT));
pstmt.setString(10,session.getAttribute("user").toString());

pstmt.executeUpdate();
    ResultSet generatedKeys = pstmt.getGeneratedKeys();
    String toyId = null;
    if (generatedKeys.next()) {
      toyId = generatedKeys.getString(1);
    }

    // Close the resources
    pstmt.close();

    // Insert into the corresponding subcategory table
    switch (category) {
      case "action_figure":
        sql = "INSERT INTO action_figure (toy_id, height, can_move, character_name) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, toyId);
        pstmt.setDouble(2, Double.parseDouble(request.getParameter("height")));
        pstmt.setBoolean(3, Boolean.parseBoolean(request.getParameter("can_move")));
        pstmt.setString(4, request.getParameter("character"));
        break;
      case "stuffed_animal":
        sql = "INSERT INTO stuffed_animal (toy_id, color, brand, animal) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, toyId);
        pstmt.setString(2, request.getParameter("color"));
        pstmt.setString(3, request.getParameter("brand"));
        pstmt.setString(4, request.getParameter("animal"));
        break;
      case "board_game":
        sql = "INSERT INTO board_game (toy_id, player_count, brand, is_cards_game) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, toyId);
        pstmt.setInt(2, Integer.parseInt(request.getParameter("player_count")));
        pstmt.setString(3, request.getParameter("game_brand"));
        pstmt.setBoolean(4, Boolean.parseBoolean(request.getParameter("is_cards_game")));
        break;
      default:
        throw new IllegalArgumentException("Invalid category: " + category);
    }

    // Execute the prepared statement
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
