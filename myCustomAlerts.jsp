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
                    <th>Status</th>
                    <th>Matching Listing</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = db.getConnection();

                    String category = "action_figure"; // Change this to the desired category
                    String username = session.getAttribute("user").toString();
                    String min_price = request.getParameter("min_price");
                    String max_price = request.getParameter("max_price");
                    String start_age = request.getParameter("start_age");
                    String end_age = request.getParameter("end_age");
                    String height = request.getParameter("height");
                    String can_move = request.getParameter("can_move");
                    String character_name = request.getParameter("character_name");

                    String sqlActionFigure = buildActionFigureSQL(category, username, min_price, max_price, start_age, end_age, height, can_move, character_name);

                    // Prepare the statement
                    try (PreparedStatement ps = conn.prepareStatement(sqlActionFigure)) {
                        // Set parameter values
                        List<Object> params = new ArrayList<>();
                        int index = 1;
                        ps.setString(index++, category);
                        if (username != null) {
                            ps.setString(index++, username);
                        }
                        if (min_price != null) {
                            ps.setDouble(index++, Double.parseDouble(min_price));
                        }
                        if (max_price != null) {
                            ps.setDouble(index++, Double.parseDouble(max_price));
                        }
                        if (start_age != null) {
                            ps.setInt(index++, Integer.parseInt(start_age));
                        }
                        if (end_age != null) {
                            ps.setInt(index++, Integer.parseInt(end_age));
                        }
                        if (height != null && !height.isEmpty()) {
                            ps.setInt(index++, Integer.parseInt(height));
                        }
                        if (can_move != null && !can_move.isEmpty()) {
                            ps.setBoolean(index++, Boolean.parseBoolean(can_move));
                        }
                        if (character_name != null && !character_name.isEmpty()) {
                            ps.setString(index++, character_name);
                        }

                        try (ResultSet rs = ps.executeQuery()) {
                            boolean found = false;
                            while (rs.next()) {
                                found = true;
                %>
                                <tr>
                                    <td><%= rs.getString("alert_name") %></td>
                                    <td><%= rs.getDouble("max_price") %></td>
                                    <td><%= rs.getDouble("min_price") %></td>
                                    <td><%= rs.getInt("start_age") %> - <%= rs.getInt("end_age") %></td>
                                    <td><%= rs.getInt("height") %> inches</td>
                                    <td><%= rs.getBoolean("can_move") ? "Yes" : "No" %></td>
                                    <td><%= rs.getString("character_name") %></td>
                                    <td>Yes</td>
                                    <td><a href="listingDetails.jsp?id=<%= rs.getInt("toy_id") %>">Check Listing</a></td>
                                </tr>
                <%
                            }
                            if (!found) {
                %>
                                <tr>
                                    <td colspan="9">No results found</td>
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
                    <th>Status</th>
                    <th>Matching Listing</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = db.getConnection();

                    String category = "board_game";
                    String username = session.getAttribute("user").toString();
                    String min_price = request.getParameter("min_price");
                    String max_price = request.getParameter("max_price");
                    String start_age = request.getParameter("start_age");
                    String end_age = request.getParameter("end_age");
                    String player_count = request.getParameter("player_count");
                    String game_brand = request.getParameter("game_brand");

                    String sqlBoardGame = buildBoardGameSQL(category, username, min_price, max_price, start_age, end_age, player_count, game_brand);

                    // Prepare the statement
                    try (PreparedStatement ps = conn.prepareStatement(sqlBoardGame)) {
                        // Set parameter values
                        List<Object> params = new ArrayList<>();
                        int index = 1;
                        ps.setString(index++, category);
                        if (username != null) {
                            ps.setString(index++, username);
                        }
                        if (min_price != null) {
                            ps.setDouble(index++, Double.parseDouble(min_price));
                        }
                        if (max_price != null) {
                            ps.setDouble(index++, Double.parseDouble(max_price));
                        }
                        if (start_age != null) {
                            ps.setInt(index++, Integer.parseInt(start_age));
                        }
                        if (end_age != null) {
                            ps.setInt(index++, Integer.parseInt(end_age));
                        }
                        if (player_count != null && !player_count.isEmpty()) {
                            ps.setInt(index++, Integer.parseInt(player_count));
                        }
                        if (game_brand != null && !game_brand.isEmpty()) {
                            ps.setString(index++, game_brand);
                        }

                        try (ResultSet rs = ps.executeQuery()) {
                            boolean found = false;
                            while (rs.next()) {
                                found = true;
                %>
                                <tr>
                                    <!-- Populate table rows here -->
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
                            if (!found) {
                %>
                                <tr>
                                    <td colspan="8">No results found</td>
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
                    <th>Status</th>
                    <th>Matching Listing</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = db.getConnection();

                    String category = "stuffed_animal"; // Change this to the desired category
                    String username = session.getAttribute("user").toString();
                    String min_price = request.getParameter("min_price");
                    String max_price = request.getParameter("max_price");
                    String start_age = request.getParameter("start_age");
                    String end_age = request.getParameter("end_age");
                    String color = request.getParameter("color");
                    String animal = request.getParameter("animal");
                    String brand = request.getParameter("brand");

                    String sqlStuffedAnimal = buildStuffedAnimalSQL(category, username, min_price, max_price, start_age, end_age, color, animal, brand);
                    // Prepare the statement
                    try (PreparedStatement ps = conn.prepareStatement(sqlStuffedAnimal)) {
                        // Set parameter values
                        List<Object> params = new ArrayList<>();
                        int index = 1;
                        ps.setString(index++, category);
                        if (username != null) {
                            ps.setString(index++, username);
                        }
                        if (min_price != null) {
                            ps.setDouble(index++, Double.parseDouble(min_price));
                        }
                        if (max_price != null) {
                            ps.setDouble(index++, Double.parseDouble(max_price));
                        }
                        if (start_age != null) {
                            ps.setInt(index++, Integer.parseInt(start_age));
                        }
                        if (end_age != null) {
                            ps.setInt(index++, Integer.parseInt(end_age));
                        }
                        if (color != null && !color.isEmpty()) {
                            ps.setString(index++, color);
                        }
                        if (animal != null && !animal.isEmpty()) {
                            ps.setString(index++, animal);
                        }
                        if (brand != null && !brand.isEmpty()) {
                            ps.setString(index++, brand);
                        }

                        try (ResultSet rs = ps.executeQuery()) {
                            boolean found = false;
                            while (rs.next()) {
                                found = true;
                %>
                                <tr>
                                    <!-- Populate table rows here -->
                                </tr>
                <%
                            }
                            if (!found) {
                %>
                                <tr>
                                    <td colspan="9">No results found</td>
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
 <%!

public String buildActionFigureSQL(String category, String username, String min_price, String max_price, String start_age, String end_age, String height, String can_move, String character_name) {
    StringBuilder sql = new StringBuilder("SELECT sa.*, tl.toy_id FROM stuffed_animal sa INNER JOIN custom_alerts ca ON sa.animal = ca.animal INNER JOIN toy_listing tl ON ca.username = tl.username WHERE ca.username = ?");
    List<Object> params = new ArrayList<>();
    params.add(username);

    if (min_price != null) {
        sql.append(" AND ca.min_price >= ?");
        params.add(Double.parseDouble(min_price));
    }
    if (max_price != null) {
        sql.append(" AND ca.max_price <= ?");
        params.add(Double.parseDouble(max_price));
    }
    if (start_age != null) {
        sql.append(" AND ca.start_age >= ?");
        params.add(Integer.parseInt(start_age));
    }
    if (end_age != null) {
        sql.append(" AND ca.end_age <= ?");
        params.add(Integer.parseInt(end_age));
    }
    if (height != null && !height.isEmpty()) {
        sql.append(" AND ca.height = ?");
        params.add(Integer.parseInt(height));
    }
    if (can_move != null && !can_move.isEmpty()) {
        sql.append(" AND ca.can_move = ?");
        params.add(Boolean.parseBoolean(can_move));
    }
    if (character_name != null && !character_name.isEmpty()) {
        sql.append(" AND ca.character_name = ?");
        params.add(character_name);
    }

    return sql.toString();
}

public String buildBoardGameSQL(String category, String username, String min_price, String max_price, String start_age, String end_age, String player_count, String game_brand) {
    StringBuilder sql = new StringBuilder("SELECT sa.*, tl.toy_id FROM stuffed_animal sa INNER JOIN custom_alerts ca ON sa.animal = ca.animal INNER JOIN toy_listing tl ON ca.username = tl.username WHERE ca.username = ?");
    List<Object> params = new ArrayList<>();
    params.add(category);
    params.add(username);

    if (min_price != null) {
        sql.append(" AND ca.min_price >= ?");
        params.add(Double.parseDouble(min_price));
    }
    if (max_price != null) {
        sql.append(" AND ca.max_price <= ?");
        params.add(Double.parseDouble(max_price));
    }
    if (start_age != null) {
        sql.append(" AND ca.start_age >= ?");
        params.add(Integer.parseInt(start_age));
    }
    if (end_age != null) {
        sql.append(" AND ca.end_age <= ?");
        params.add(Integer.parseInt(end_age));
    }
    if (player_count != null && !player_count.isEmpty()) {
        sql.append(" AND ca.player_count = ?");
        params.add(Integer.parseInt(player_count));
    }
    if (game_brand != null && !game_brand.isEmpty()) {
        sql.append(" AND ca.game_brand = ?");
        params.add(game_brand);
    }

    return sql.toString();
}

public String buildStuffedAnimalSQL(String category, String username, String min_price, String max_price, String start_age, String end_age, String color, String animal, String brand) {
    StringBuilder sql = new StringBuilder("SELECT sa.*, tl.toy_id FROM stuffed_animal sa INNER JOIN custom_alerts ca ON sa.animal = ca.animal INNER JOIN toy_listing tl ON ca.username = tl.username WHERE ca.username = ?");
    List<Object> params = new ArrayList<>();
    params.add(category);
    params.add(username);

    if (min_price != null) {
        sql.append(" AND ca.min_price >= ?");
        params.add(Double.parseDouble(min_price));
    }
    if (max_price != null) {
        sql.append(" AND ca.max_price <= ?");
        params.add(Double.parseDouble(max_price));
    }
    if (start_age != null) {
        sql.append(" AND ca.start_age >= ?");
        params.add(Integer.parseInt(start_age));
    }
    if (end_age != null) {
        sql.append(" AND ca.end_age <= ?");
        params.add(Integer.parseInt(end_age));
    }
    if (color != null && !color.isEmpty()) {
        sql.append(" AND ca.color = ?");
        params.add(color);
    }
    if (animal != null && !animal.isEmpty()) {
        sql.append(" AND ca.animal = ?");
        params.add(animal);
    }
    if (brand != null && !brand.isEmpty()) {
        sql.append(" AND ca.brand = ?");
        params.add(brand);
    }
    return sql.toString();
}
 %>
</body>
</html>