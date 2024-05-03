<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 4/21/24
  Time: 6:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Timestamp, java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Sales Report</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    String start = request.getParameter("date1");
    String end = request.getParameter("date2");
    SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    SimpleDateFormat printer = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss");

    Timestamp date1 = new Timestamp(fmt.parse(start).getTime());
    Timestamp date2 = new Timestamp(fmt.parse(end).getTime());
    try {
        PreparedStatement ps = con.prepareStatement(
                "SELECT SUM(initial_price) " +
                        "FROM toy_listing tl " +
                        "WHERE " +
                        "closing_datetime >= (?) AND closing_datetime <= (?) and openStatus = 0" +
                        "AND tl.toy_id IN (SELECT s.toy_id FROM sale s)"
        );
        ps.setTimestamp(1, date1);
        ps.setTimestamp(2, date2);
        ResultSet rs = ps.executeQuery();
        String total_earnings = "0.00";
        if (rs.next()) {
            total_earnings = rs.getString(1);
        }
%>
<div style="text-align:center">
    <h1> Sales Report</h1>
    <h3> DATE: <%= printer.format(fmt.parse(start)) %> --- <%= printer.format(fmt.parse(end)) %> </h3>
    <h3>Total Earnings: $<%= total_earnings %></h3>
    <%
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>
</div>
<a style="margin-top: 30px;" href="AdminMain.jsp">Admin Home</a>
</body>
</html>