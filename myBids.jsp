<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 5/2/24
  Time: 1:33 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>My Bids</title>
</head>
<body>
<%
        // Create a connection to the database
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();
        BidData bidData = new BidData(conn);
        ToyListingData tlDAO = new ToyListingData(conn);
        List<Bid> bids = bidData.getBidsByUser(session.getAttribute("user").toString());
        %>
<table>
<tr><th>Bid Time</th><th>Name</th><th>Bid Price</th> <th>Is Auto Bid</th></tr>
    <%
        for (Bid b : bids) {
            int id = b.getToyId();
            ToyListing toyListing = tlDAO.getToyListingDetails(id, true);
            String category = toyListing.getCategory();
            String name = toyListing.getName();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm a");
            String bidTime = b.getTime().format(formatter);
            String url = "listingDetails.jsp?id=" + id + "&category=" + category;
            out.println("<tr data-href=\"" + url + "\" class = \"listing-tr\">");
            out.println("<td>"+bidTime+"</td>");
            out.println("<td>"+name+"</td>");
            out.println("<td>"+b.getPrice()+"</td>");
            out.println("<td>"+b.isAutoBid()+ "</td>");
            out.println("</tr>");
        }
    %>
</table>
</body>
</html>


