<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/14/24
  Time: 12:03 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.DecimalFormat" %>
<meta name="viewport" content="width=device-width, initial-scale=1">
<html>
<head>
    <title>Details</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script>
        function toggleAutoBidSection() {
            var autoBidCheckbox = document.getElementById("autoBidCheckbox");
            var autoBidSection = document.getElementById("autoBidSection");

            autoBidSection.style.display = autoBidCheckbox.checked ? "block" : "none";
        }
    </script>
</head>
<body>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String category = request.getParameter("category");
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    BidData bidData = new BidData(conn);
    try {

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        double lastBidPrice = bidData.highestBid(id);

        // Query to retrieve details for listing
        String query = "SELECT * FROM toy_listing WHERE toy_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, id);
        rs = pstmt.executeQuery();
        double increment;
        int startAge;
        int endAge;
       if(rs.next()) {
           String categoryStr = category.replace("_", " ");
           increment = rs.getDouble("increment");
           startAge = rs.getInt("start_age");
           endAge = rs.getInt("end_age");
           DecimalFormat df = new DecimalFormat("#.##");
            double price = lastBidPrice==-1? rs.getDouble("initial_price") : lastBidPrice;
            String priceStr = df.format(price);
            double minBidPrice = price + increment;
            String minBidPriceStr = df.format(minBidPrice);
           out.println(categoryStr);
           out.println("<h2>" + rs.getString("name") + "</h2>");%>
    <div class = "row">
        <div class = "column">
            <p> Current Price: $ <%=priceStr %> </p>
            <%
                LocalDateTime startTime = rs.getTimestamp("start_datetime").toLocalDateTime();
                // Define the format with AM/PM and without seconds
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm a");
                // Format the datetime using the formatter
                String startDT = startTime.format(formatter);
                LocalDateTime endTime = rs.getTimestamp("closing_datetime").toLocalDateTime();
                String endDT = endTime.format(formatter);
            %>
            <p>Start Time: <%=startDT%></p>
            <p>Closing Time: <%=endDT%></p>

           <%//get category details
           query = "SELECT * FROM " + category + " WHERE toy_id = ?";
           pstmt = conn.prepareStatement(query);
           pstmt.setInt(1, id);
           rs = pstmt.executeQuery();

           // Display details from category table
           if (rs.next()) {
               out.println("<b>Details </b>");
               out.println("<ul>");
               out.println("<li>" + "Age Range: " + startAge + " - " + endAge + "</li>");
               if (category.equals("action_figure")) {
                   double height = rs.getDouble("height");
                   boolean canMove = rs.getBoolean("can_move");
                   String characterName = rs.getString("character_name");
                   // Display action figure details
                   out.println("<li>Height: " + height + "</li>");
                   out.println("<li>Can Move: " + canMove + "</li>");
                   out.println("<li>Character Name: " + characterName + "</li>");
               } else if (category.equals("board_game")) {
                   int playerCount = rs.getInt("player_count");
                   String brand = rs.getString("brand");
                   boolean isCardsGame = rs.getBoolean("is_cards_game");
                   // Display board game details
                   out.println("<li>Player Count: " + playerCount + "</li>");
                   out.println("<li>Brand: " + brand + "</li>");
                   out.println("<li>Is Cards Game: " + isCardsGame + "</li>");
               } else if (category.equals("stuffed_animal")) {
                   String color = rs.getString("color");
                   String brand = rs.getString("brand");
                   String animal = rs.getString("animal");
                   // Display stuffed animal details

                   out.println("<li>Color: " + color + "</li>");
                   out.println("<li>Brand: " + brand + "</li>");
                   out.println("<li>Animal: " + animal + "</li>");
               }
               out.println("</ul></div>");

           } else {
               out.println("<p>Listing not found.</p>");
           }

%>

               <div class="column">
                   <form id="bidForm" action="/placeBid" method="POST">
                       <input type="hidden" name="id" value=<%=id%>>
                       <p>Bid: <input type="number" name="bidAmt" step="0.01" placeholder="<%= minBidPriceStr %>" min="<%= minBidPriceStr %>"/></p>
                       <p>Automatic Bid: <input type="checkbox" id="autoBidCheckbox" name="isAutoBid" onchange="toggleAutoBidSection()"/></p>
                       <div id="autoBidSection" style="display: none;">
                           <p>Max Bid: <input type="number" name="maxBid"/></p>
                           <p>Bid Increment: <input type="number" name="autoBidIncrement" step="0.01"/></p>
                       </div>
                       <input type="submit" value="Place Bid"/>
                   </form>

               </div>
           </div>
        <div class="row">
            <h3>Bidding history</h3>
        </div>
        <%
           query = "SELECT * FROM  bid WHERE toy_id = ?";
           pstmt = conn.prepareStatement(query);
           pstmt.setInt(1, id);
           rs = pstmt.executeQuery();
           while (rs.next()) {
               Bid bid  = bidData.extractBidFromResultSet(rs);

    %>
            <div class="row">
                <p class="column">id: <%= bid.getBidId() %></p>
                <p class="column">price: $<%= bid.getPrice() %></p>
                <p class="column">bidder: <%= bid.getUsername() %></p>
            </div>
<%
}

       }
        rs.close();
        pstmt.close();
        conn.close();
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }

%>

<a href="browseListings.jsp">Back to All Listings</a>
</body>
</html>

