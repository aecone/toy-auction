<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*, com.cs336.pkg.*, java.util.ArrayList, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Custom Alerts</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h1>My Custom Alerts</h1>
    <div class="scrollable-container">
        <h2 class="center-texts">Action Figure Alerts</h2>
        <table class="center-texts">
            <thead>
                <tr>
                    <th>Alert Name</th>
                    <th>Max Price</th>
                    <th>Min Price</th>
                    <th>Age Range</th>
                    <th>Height</th>
                    <th>Can Move</th>
                    <th>Character Name</th>
                    <th>Matching Listing</th>
                </tr>
            </thead>
            <tbody>
                <%
                class CustomAlertData {
                    private Connection connection;

                    public CustomAlertData(Connection connection) {
                        this.connection = connection;
                    }
                }
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = db.getConnection();

                    CustomAlertData customAlertData = new CustomAlertData(conn);
                    String min_price = request.getParameter("min_price");
                    String max_price = request.getParameter("max_price");
                    String start_age = request.getParameter("start_age");
                    String end_age = request.getParameter("end_age");
                    String height = request.getParameter("height");
                    String can_move = request.getParameter("can_move");
                    String character_name = request.getParameter("character_name");
                    String toyId = request.getParameter("toy_id");

                    // List to store parameter values
                    List<Object> params = new ArrayList<>();

                    // StringBuilder to construct the SQL query
                    StringBuilder sql = new StringBuilder("SELECT ca.*, tl.toy_id FROM custom_alerts ca INNER JOIN toy_listing tl using(category) WHERE ca.category = 'action_figure' and ca.username= ?");
                    params.add(session.getAttribute("user").toString());
                    if(min_price != null){
                        sql.append(" AND min_price >= ?");
                        params.add(Double.parseDouble(min_price));
                    }
                    if(max_price != null){
                        sql.append(" AND max_price <= ?");
                        params.add(Double.parseDouble(max_price));
                    }

                    if(start_age != null){
                        sql.append(" AND start_age >= ?");
                        params.add(Integer.parseInt(start_age));
                    }
                    if(end_age != null){
                        sql.append(" AND end_age <= ?");
                        params.add(Integer.parseInt(end_age));
                    }

                    if(height != null){
                        sql.append(" AND height = ?");
                        params.add(Integer.parseInt(height));
                    }

                    if(can_move != null){
                        sql.append(" AND can_move = ?");
                        params.add(Boolean.parseBoolean(can_move));
                    }

                    if(character_name != null){
                        sql.append(" AND character_name = ?");
                        params.add(character_name);
                    }

                    // Prepare the statement
                    try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                        // Set parameter values
                        for (int i = 0; i < params.size(); i++) {
                            ps.setObject(i + 1, params.get(i));
                        }

                        try (ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {

                                %>
                                <tr>
                                    <td><%= rs.getString("alert_name") %></td>
                                    <td><%= rs.getDouble("max_price") %></td>
                                    <td><%= rs.getDouble("min_price") %></td>
                                    <td><%= rs.getInt("start_age") %> - <%= rs.getInt("end_age") %></td>
                                    <td> <%= rs.getInt("height") %> inches </td>
                                    <td><%= rs.getBoolean("can_move") ? "Yes" : "No" %></td>
                                    <td><%= rs.getString("character_name") %></td>
                                    <td>
                                    <a href="listingDetails.jsp?id=<%= rs.getInt("toy_id") %>">Check Listing</a>
                                    </td>
                                </tr>
                                <%
                            }
                        }
                    }
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
            </tbody>
        </table>

        <h2 class="center-texts">Board Game Alerts</h2>
        <table class="center-texts">
            <thead>
                <tr>
                    <th>Alert Name</th>
                    <th>Max Price</th>
                    <th>Min Price</th>
                    <th>Age Range</th>
                    <th>Players</th>
                    <th>Game Brand</th>
                    <th>Matching Listing</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    // Create a connection to the database
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = db.getConnection();
                    List<Object> params = new ArrayList<>();
                    StringBuilder sql = new StringBuilder("SELECT ca.*, tl.toy_id FROM custom_alerts ca INNER JOIN toy_listing tl using(category) WHERE ca.category = 'board_game' and ca.username= ?");
                    params.add(session.getAttribute("user").toString());
                    // Prepare the statement
                    try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                        for (int i = 0; i < params.size(); i++) {
                            ps.setObject(i + 1, params.get(i));
                        }
                        try (ResultSet rs = ps.executeQuery()) {
                            // Iterate over the result set and process the data
                            while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getString("alert_name") %></td>
                                    <td><%= rs.getDouble("max_price") %></td>
                                    <td><%= rs.getDouble("min_price") %></td>
                                    <td><%= rs.getInt("start_age") %> - <%= rs.getInt("end_age") %></td>
                                    <td> <%= rs.getInt("player_count") %></td>
                                    <td> <%= rs.getString("game_brand") %></td>
                                    <td>
                                    <a href="listingDetails.jsp?id=<%= rs.getInt("toy_id") %>">Check Listing</a>
                                    </td>
                                </tr>
                                <%
                            }
                        }
                    }
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
            </tbody>
        </table>

        <h2 class="center-texts">Stuffed Animal Alerts</h2>
        <table class="center-texts">
            <thead>
                <tr>
                    <th>Alert Name</th>
                    <th>Max Price</th>
                    <th>Min Price</th>
                    <th>Age Range</th>
                    <th>Color</th>
                    <th>Animal</th>
                    <th>Brand</th>
                    <th>Matching Listing</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    // Create a connection to the database
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = db.getConnection();

                    // Prepare the statement
                    try (PreparedStatement ps = conn.prepareStatement("SELECT ca.*, tl.toy_id FROM custom_alerts ca INNER JOIN toy_listing tl using(category) WHERE ca.category = 'stuffed_animal'"))
                    {
                        try (ResultSet rs = ps.executeQuery()) {
                            // Iterate over the result set and process the data
                            while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getString("alert_name") %></td>
                                    <td><%= rs.getDouble("max_price") %></td>
                                    <td><%= rs.getDouble("min_price") %></td>
                                    <td><%= rs.getInt("start_age") %> - <%= rs.getInt("end_age") %></td>
                                    <td><%= rs.getString("color") %></td>
                                    <td> <%= rs.getString("animal")%></td>
                                    <td> <%= rs.getString("brand")%></td>
                                    <td>
                                    <a href="listingDetails.jsp?id=<%= rs.getInt("toy_id") %>">Check Listing</a>
                                    </td>
                                </tr>
                                <%
                            }
                        }
                    }
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
            </tbody>
        </table>
    </div>
    <br>
    <a href="CustomerMain.jsp">Home</a>
</body>
</html>