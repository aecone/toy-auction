<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.net.URLEncoder" %>
<html>
<head>
  <title>Remove Bid/Auction</title>
</head>
<body>
<%
  ApplicationDB db = new ApplicationDB();
  Connection con = db.getConnection();

  // Retrieve parameters from form submission
  String tl_id = request.getParameter("tl_id");
  String deleteAuc = request.getParameter("deleteAuc");
  String deleteBid = request.getParameter("deleteBid");

  if ("true".equals(deleteAuc)) {
    // Delete auction based on toy_id
    PreparedStatement ps = con.prepareStatement("DELETE FROM toy_listing WHERE toy_id = ?");
    ps.setString(1, tl_id);
    ps.executeUpdate();
    response.sendRedirect("CustomerRepMain.jsp"); // Redirect to main page after deletion
  } else if (deleteBid != null) {
    // Delete bid based on bid_id
    PreparedStatement ps = con.prepareStatement("DELETE FROM bid WHERE b_id = ?");
    ps.setString(1, deleteBid);
    ps.executeUpdate();

    // Fetch the highest remaining bid price for the toy
    ps = con.prepareStatement("SELECT MAX(price) FROM bid WHERE toy_id = ?");
    ps.setString(1, tl_id);
    ResultSet rs = ps.executeQuery();
    String new_price = null;

    if (rs.next()) {
      new_price = rs.getString(1);
    }

    // Update the initial_price in toy_listing to the new highest bid or reset if no bids remain
    if (new_price != null) {
      ps = con.prepareStatement("UPDATE toy_listing SET initial_price = ? WHERE toy_id = ?");
      ps.setString(1, new_price);
      ps.setString(2, tl_id);
    } else {
      ps = con.prepareStatement("UPDATE toy_listing SET initial_price = 0.01 WHERE toy_id = ?");
      ps.setString(1, tl_id);
    }
    ps.executeUpdate();
    response.sendRedirect("EditBidAuc.jsp?toy_id=" + URLEncoder.encode(tl_id, "UTF-8")); // Redirect back to edit page
  } else {
    // Error handling: no valid action specified
    out.println("<script>alert('No valid action specified.');window.location='CustomerRepMain.jsp';</script>");
  }
%>
</body>
</html>
