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
        BidDAO bidDAO = new BidDAO(conn);
        ToyListingDAO tlDAO = new ToyListingDAO(conn);
        List<Bid> bids = bidDAO.getBidsByUser(session.getAttribute("user").toString());
        %>
<table>
<tr><th>Bid Time</th><th>Name</th><th>Bid Price</th> <th>Is Auto Bid</th></tr>
    <%
        for (Bid b : bids) {
            int id = b.getToyId();
            ToyListing toyListing = tlDAO.getToyListingDetails(id, true);
            String category = toyListing.getCategory();
            String url = "listingDetails.jsp?id=" + id + "&category=" + category;
            out.println("<tr data-href=\"" + url + "\" class = \"listing-tr\">");
            out.println("<td>"+b.getTime()+"</td>");
            out.println("<td>"+b.getPrice()+"</td>");
            out.println("<td>");
        }
    %>
</table>
</body>
</html>


