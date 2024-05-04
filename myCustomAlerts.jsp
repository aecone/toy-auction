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
                    String query = "SELECT * FROM alert WHERE username = ?";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, username);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        String alertName = rs.getString("name");
                        String category = rs.getString("category");
                        double maxPrice = rs.getDouble("max_price");
                        double minPrice = rs.getDouble("min_price");
                        String ageRange = rs.getString("age_range");

                        out.println("<tr>");
                        out.println("<td>" + alertName + "</td>");
                        out.println("<td>" + category + "</td>");
                        out.println("<td>" + maxPrice + "</td>");
                        out.println("<td>" + minPrice + "</td>");
                        out.println("<td>" + ageRange + "</td>");
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
