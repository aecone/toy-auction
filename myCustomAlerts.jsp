<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*, com.cs336.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Alerts</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h1>My Custom Alerts</h1>
    <div class = "scrollable-container">
    <table>
        <thead>
            <tr>
                <th>Alert Name</th>
                <th>Category</th>
                <th>Max Price</th>
                <th>Min Price</th>
                <th>Age Range</th>
                <th>Custom Alert Status</th>
                <th>Satisfied Item</th>
            </tr>
        </thead>
        <tbody>
            <%
                String username = (String) session.getAttribute("user");
                ApplicationDB db = new ApplicationDB();
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    conn = db.getConnection();
                    String query = "SELECT a.alert_id, a.name, a.category, a.max_price, a.min_price, a.age_range, a.custom_alert_status, t.name AS satisfied_item, t.toy_id " +
                                    "FROM alert a " +
                                    "LEFT JOIN toy_listing t ON a.category = t.category AND a.max_price >= t.initial_price AND a.min_price <= t.initial_price " +
                                    "WHERE a.username = ?";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, username);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        String alertName = rs.getString("name");
                        String category = rs.getString("category");
                        double maxPrice = rs.getDouble("max_price");
                        double minPrice = rs.getDouble("min_price");
                        String ageRange = rs.getString("age_range");
                        boolean customAlertStatus = rs.getBoolean("custom_alert_status");
                        String satisfiedItem = rs.getString("satisfied_item");
                        int toyId = rs.getInt("toy_id");

                        out.println("<tr>");
                        out.println("<td>" + alertName + "</td>");
                        out.println("<td>" + category + "</td>");
                        out.println("<td>" + maxPrice + "</td>");
                        out.println("<td>" + minPrice + "</td>");
                        out.println("<td>" + ageRange + "</td>");
                        out.println("<td>" + (customAlertStatus ? "Found" : "Not Found") + "</td>");
                        out.println("<td>");
                        // Check if satisfied item exists
                        if (satisfiedItem != null) {
                            // Generate hyperlink to toy details page
                            out.println("<a href='listingDetails.jsp?id=" + toyId + "'>" + satisfiedItem + "</a>");
                        } else {
                            out.println("No item satisfies this alert");
                        }
                        out.println("</td>");
                        out.println("</tr>");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    // Close resources
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </tbody>
    </table>
    </div>
    <br>
    <a href="CustomerMain.jsp">Home</a>
</body>
</html>