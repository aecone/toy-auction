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
        // Total Earnings Report
        PreparedStatement totalEarningsPS = con.prepareStatement(
                "SELECT SUM(initial_price) " +
                        "FROM toy_listing tl " +
                        "WHERE " +
                        "closing_datetime >= ? AND closing_datetime <= ? AND openStatus = 0 " +
                        "AND tl.toy_id IN (SELECT s.toy_id FROM sale s)"
        );
        totalEarningsPS.setTimestamp(1, date1);
        totalEarningsPS.setTimestamp(2, date2);
        ResultSet totalEarningsRS = totalEarningsPS.executeQuery();
        String totalEarnings = "0.00";
        if (totalEarningsRS.next()) {
            totalEarnings = totalEarningsRS.getString(1);
        }

        // Earnings Per Item Report
        PreparedStatement earningsPerItemPS = con.prepareStatement(
                "SELECT name, SUM(initial_price) " +
                        "FROM toy_listing tl " +
                        "JOIN sale s ON tl.toy_id = s.toy_id " +
                        "WHERE closing_datetime >= ? AND closing_datetime <= ? AND openStatus = 0 " +
                        "GROUP BY name"
        );
        earningsPerItemPS.setTimestamp(1, date1);
        earningsPerItemPS.setTimestamp(2, date2);
        ResultSet earningsPerItemRS = earningsPerItemPS.executeQuery();
        Map<String, Double> earningsPerItem = new HashMap<>();
        while (earningsPerItemRS.next()) {
            earningsPerItem.put(earningsPerItemRS.getString(1), earningsPerItemRS.getDouble(2));
        }

        // Earnings Per Item Type Report
        PreparedStatement earningsPerItemTypePS = con.prepareStatement(
                "SELECT category, SUM(initial_price) " +
                        "FROM toy_listing tl " +
                        "JOIN sale s ON tl.toy_id = s.toy_id " +
                        "WHERE closing_datetime >= ? AND closing_datetime <= ? AND openStatus = 0 " +
                        "GROUP BY category"
        );
        earningsPerItemTypePS.setTimestamp(1, date1);
        earningsPerItemTypePS.setTimestamp(2, date2);
        ResultSet earningsPerItemTypeRS = earningsPerItemTypePS.executeQuery();
        Map<String, Double> earningsPerItemType = new HashMap<>();
        while (earningsPerItemTypeRS.next()) {
            earningsPerItemType.put(earningsPerItemTypeRS.getString(1), earningsPerItemTypeRS.getDouble(2));
        }

        // Earnings Per End-User Report
        PreparedStatement earningsPerEndUserPS = con.prepareStatement(
                "SELECT u.username, SUM(initial_price) " +
                        "FROM toy_listing tl " +
                        "JOIN sale s ON tl.toy_id = s.toy_id " +
                        "JOIN user u ON s.username = u.username " +
                        "WHERE closing_datetime >= ? AND closing_datetime <= ? AND openStatus = 0 " +
                        "GROUP BY u.username"
        );
        earningsPerEndUserPS.setTimestamp(1, date1);
        earningsPerEndUserPS.setTimestamp(2, date2);
        ResultSet earningsPerEndUserRS = earningsPerEndUserPS.executeQuery();
        Map<String, Double> earningsPerEndUser = new HashMap<>();
        while (earningsPerEndUserRS.next()) {
            earningsPerEndUser.put(earningsPerEndUserRS.getString(1), earningsPerEndUserRS.getDouble(2));
        }

        // Best-Selling Items Report
        PreparedStatement bestSellingItemsPS = con.prepareStatement(
                "SELECT name, COUNT(*) " +
                        "FROM sale s " +
                        "JOIN toy_listing tl ON s.toy_id = tl.toy_id " +
                        "WHERE closing_datetime >= ? AND closing_datetime <= ? AND openStatus = 0 " +
                        "GROUP BY name " +
                        "ORDER BY COUNT(*) DESC"
        );
        bestSellingItemsPS.setTimestamp(1, date1);
        bestSellingItemsPS.setTimestamp(2, date2);
        ResultSet bestSellingItemsRS = bestSellingItemsPS.executeQuery();
        Map<String, Integer> bestSellingItems = new LinkedHashMap<>();
        while (bestSellingItemsRS.next()) {
            bestSellingItems.put(bestSellingItemsRS.getString(1), bestSellingItemsRS.getInt(2));
        }

        // Best Buyers Report
        PreparedStatement bestBuyersPS = con.prepareStatement(
                "SELECT u.username, COUNT(*) " +
                        "FROM sale s " +
                        "JOIN user u ON s.username = u.username " +
                        "WHERE s.closing_datetime >= ? AND s.closing_datetime <= ? " +
                        "GROUP BY u.username " +
                        "ORDER BY COUNT(*) DESC"
        );
        bestBuyersPS.setTimestamp(1, date1);
        bestBuyersPS.setTimestamp(2, date2);
        ResultSet bestBuyersRS = bestBuyersPS.executeQuery();
        Map<String, Integer> bestBuyers = new LinkedHashMap<>();
        while (bestBuyersRS.next()) {
            bestBuyers.put(bestBuyersRS.getString(1), bestBuyersRS.getInt(2));
        }
%>
<div style="text-align:center">
    <h1>Sales Report</h1>
    <h3>DATE: <%= printer.format(fmt.parse(start)) %> --- <%= printer.format(fmt.parse(end)) %></h3>
    <h3>Total Earnings: $<%= totalEarnings %></h3>

    <h3>Earnings Per Item:</h3>
    <% if (earningsPerItem.isEmpty()) { %>
        <h3>No data available for the selected period.</h3>
    <% } else { %>
        <table border="1">
            <tr>
                <th>Item Name</th>
                <th>Total Earnings</th>
            </tr>
            <% for (Map.Entry<String, Double> entry : earningsPerItem.entrySet()) { %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td>$<%= entry.getValue() %></td>
            </tr>
            <% } %>
        </table>
    <% } %>

    <h3>Earnings Per Item Type:</h3>
    <% if (earningsPerItemType.isEmpty()) { %>
        <h3>No data available for the selected period.</h3>
    <% } else { %>
        <table border="1">
            <tr>
                <th>Item Type</th>
                <th>Total Earnings</th>
            </tr>
            <% for (Map.Entry<String, Double> entry : earningsPerItemType.entrySet()) { %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td>$<%= entry.getValue() %></td>
            </tr>
            <% } %>
        </table>
    <% } %>

    <h3>Earnings Per End-User:</h3>
    <% if (earningsPerEndUser.isEmpty()) { %>
        <h3>No data available for the selected period.</h3>
    <% } else { %>
        <table border="1">
            <tr>
                <th>End-User</th>
                <th>Total Earnings</th>
            </tr>
            <% for (Map.Entry<String, Double> entry : earningsPerEndUser.entrySet()) { %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td>$<%= entry.getValue() %></td>
            </tr>
            <% } %>
        </table>
    <% } %>

    <h3>Best-Selling Items:</h3>
    <% if (bestSellingItems.isEmpty()) { %>
        <h3>No data available for the selected period.</h3>
    <% } else { %>
        <table border="1">
            <tr>
                <th>Item Name</th>
                <th>Sales Count</th>
            </tr>
            <% for (Map.Entry<String, Integer> entry : bestSellingItems.entrySet()) { %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td><%= entry.getValue() %></td>
            </tr>
            <% } %>
        </table>
    <% } %>

    <h3>Best Buyers:</h3>
    <% if (bestBuyers.isEmpty()) { %>
        <h3>No data available for the selected period.</h3>
    <% } else { %>
        <table border="1">
            <tr>
                <th>End-User</th>
                <th>Sales Count</th>
            </tr>
            <% for (Map.Entry<String, Integer> entry : bestBuyers.entrySet()) { %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td><%= entry.getValue() %></td>
            </tr>
            <% } %>
        </table>
    <% } %>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<a style="margin-top: 30px;" href="AdminMain.jsp">Admin Home</a>
</body>
</html>