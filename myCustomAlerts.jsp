<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*, com.cs336.pkg.*, java.util.ArrayList, java.util.List" %>
<%@ page import="java.util.stream.Stream" %>
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
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = db.getConnection();

                    String category = "action_figure"; // Change this to the desired category
                    String username = session.getAttribute("user").toString();
                    try{
                    List<CustomAlert> alerts = CustomAlert.getCustomAlerts(username, conn);
                    List<CustomAlert> afAlerts = CustomAlert.byCategory("action_figure", alerts);
                    for(CustomAlert a : afAlerts) {
                        String alertName = a.getAlertName();
                        double min_price = a.getMinPrice();
                        double max_price = a.getMaxPrice();
                        int start_age = a.getStartAge();
                        int end_age = a.getEndAge();
                        double height = a.getHeight();
                        boolean can_move = a.getCanMove();
                        String character_name = a.getCharacterName();
                        %>
                <tr>
                    <td><%= alertName %></td>
                    <td><%= max_price %></td>
                    <td><%= min_price %></td>
                    <td><%= start_age %> - <%= end_age %></td>
                    <td><%= height %> inches</td>
                    <td><%=can_move ? "Yes" : "No" %></td>
                    <td><%= character_name %></td>
                <%
                    // Prepare the statement
                    String sqlActionFigure = buildActionFigureSQL(height, can_move, character_name);
                    try (PreparedStatement ps = conn.prepareStatement(sqlActionFigure)) {
                        // Set parameter values
                        int index = 1;
                        ps.setString(index++, category);
                        ps.setString(index++, username);

                        if (min_price != -1) {
                            ps.setDouble(index++, min_price);
                        }
                        if (max_price != -1) {
                            ps.setDouble(index++, max_price);
                        }
                        if (start_age != -1) {
                            ps.setInt(index++, start_age);
                        }
                        if (end_age != -1) {
                            ps.setInt(index++, end_age);
                        }
                        if (height!=-1) {
                            ps.setDouble(index++, height);
                        }
                        ps.setBoolean(index++,(can_move));

                        if (character_name != null && !character_name.isEmpty()) {
                            ps.setString(index++, character_name);
                        }
                        try (ResultSet rs = ps.executeQuery()) {
                            List<Integer> toyIds = new ArrayList<>();
                            while (rs.next()) {
                                toyIds.add(rs.getInt("toy_id"));
                            }
                            if(toyIds.isEmpty()){
                                out.println("<td colspan=\"9\">No match</>");
                            }
                            else{
                                out.println("<td>Yes</><td>");
                                for(Integer toyId : toyIds) {%>
                    <a href="listingDetails.jsp?id=<%= toyId %>">Check Listing</a>
                    <%}
                                out.println("</td>");
                            }  %>
                </tr>
                <%}
                        catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    }
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
                    category = "board_game";
                    List<CustomAlert> alerts = CustomAlert.getCustomAlerts(username, conn);
                    List<CustomAlert> bgAlerts = CustomAlert.byCategory(category, alerts);
                    for(CustomAlert a : bgAlerts) {
                    %>
                <tr>
                    <td><%= a.getAlertName() %></td>
                    <td><%= a.getMaxPrice() %></td>
                    <td><%= a.getMinPrice() %></td>
                    <td><%= a.getStartAge() %> - <%= a.getEndAge() %></td>
                    <td><%= a.getPlayerCount() %></td>
                    <td><%= a.getGameBrand() %></td>

                    <%
                    String sqlBoardGame = buildBoardGameSQL(a.getPlayerCount(), a.getGameBrand());
                    try (PreparedStatement ps = conn.prepareStatement(sqlBoardGame)) {
                        // Set parameter values
                        int index = 1;
                        ps.setString(index++, category);
                        if (username != null) {
                            ps.setString(index++, username);
                        }
                        if (a.getMinPrice() != -1) {
                            ps.setDouble(index++, a.getMinPrice());
                        }
                        if (a.getMaxPrice() != -1) {
                            ps.setDouble(index++, a.getMaxPrice());
                        }
                        if (a.getStartAge() != -1) {
                            ps.setInt(index++, a.getStartAge());
                        }
                        if (a.getEndAge() != -1) {
                            ps.setInt(index++, a.getEndAge());
                        }
                        if (a.getPlayerCount() != 1) {
                            ps.setInt(index++, a.getPlayerCount());
                        }
                        if (a.getGameBrand() != null && !a.getGameBrand().isEmpty()) {
                            ps.setString(index++, a.getGameBrand());
                        }

                        try (ResultSet rs = ps.executeQuery()) {
                            List<Integer> toyIds = new ArrayList<>();
                            while (rs.next()) {
                                toyIds.add(rs.getInt("toy_id"));
                            }
                            if(toyIds.isEmpty()){
                                out.println("<td colspan=\"9\">No match</>");
                            }
                            else{
                                out.println("<td>Yes</><td>");
                                for(Integer toyId : toyIds) {%>
                    <a href="listingDetails.jsp?id=<%= toyId %>">Check Listing</a>
                    <%
                        out.println("</td>");
                    }  %>
                </tr>
                <%}}
                        }
                    }
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
                    category = "stuffed_animal"; // Change this to the desired category
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
    StringBuilder sql = new StringBuilder("SELECT ca.*, tl.toy_id FROM action_figure sa INNER JOIN toy_listing tl ON sa.toy_id=tl.toy_id INNER JOIN custom_alerts ca using(category) WHERE category = ? and ca.username = ?");
    List<Object> params = new ArrayList<>();
    params.add(username);

    if (min_price != null) {
        sql.append(" AND tl.initial_price >= ?");
        params.add(Double.parseDouble(min_price));
    }
    if (max_price != null) {
        sql.append(" AND tl.initial_price <= ?");
        params.add(Double.parseDouble(max_price));
    }
    if (start_age != null) {
        sql.append(" AND tl.start_age >= ?");
        params.add(Integer.parseInt(start_age));
    }
    if (end_age != null) {
        sql.append(" AND tl.end_age <= ?");
        params.add(Integer.parseInt(end_age));
    }
    if (height != null && !height.isEmpty()) {
        sql.append(" AND sa.height = ?");
        params.add(Integer.parseInt(height));
    }
    if (can_move != null && !can_move.isEmpty()) {
        sql.append(" AND sa.can_move = ?");
        params.add(Boolean.parseBoolean(can_move));
    }
    if (character_name != null && !character_name.isEmpty()) {
        sql.append(" AND sa.character_name = ?");
        params.add(character_name);
    }

    return sql.toString();
}

public String buildBoardGameSQL(String category, String username, String min_price, String max_price, String start_age, String end_age, String player_count, String game_brand) {
    StringBuilder sql = new StringBuilder("SELECT ca.*, tl.toy_id FROM board_game sa INNER JOIN toy_listing tl ON sa.toy_id=tl.toy_id INNER JOIN custom_alerts ca using(category) WHERE category = ? and ca.username = ?");
    List<Object> params = new ArrayList<>();
    params.add(category);
    params.add(username);

    if (min_price != null) {
        sql.append(" AND tl.initial_price >= ?");
        params.add(Double.parseDouble(min_price));
    }
    if (max_price != null) {
        sql.append(" AND tl.initial_price <= ?");
        params.add(Double.parseDouble(max_price));
    }
    if (start_age != null) {
        sql.append(" AND tl.start_age >= ?");
        params.add(Integer.parseInt(start_age));
    }
    if (end_age != null) {
        sql.append(" AND tl.end_age <= ?");
        params.add(Integer.parseInt(end_age));
    }
    if (player_count != null && !player_count.isEmpty()) {
        sql.append(" AND sa.player_count = ?");
        params.add(Integer.parseInt(player_count));
    }
    if (game_brand != null && !game_brand.isEmpty()) {
        sql.append(" AND sa.game_brand = ?");
        params.add(game_brand);
    }

    return sql.toString();
}
     public String buildBoardGameSQL(int player_count, String game_brand){
         String sql = buildSQL("board_game");
         if (player_count != -1) {
             sql += " AND sa.player_count = ?";
         }
         if (game_brand != null && !game_brand.isEmpty()) {
             sql += " AND sa.brand = ?";
         }
         return sql;
     }
public String buildSQL(String category){
    String sql= "SELECT ca.*, tl.toy_id FROM "+category+" sa INNER JOIN toy_listing tl ON sa.toy_id=tl.toy_id INNER JOIN custom_alerts ca using(category) WHERE category = ? and ca.username = ?";
    sql+=" AND tl.initial_price >= ?";
    sql+=" AND tl.initial_price <= ?";
    sql+=" AND tl.start_age >= ?";
    sql+=" AND tl.end_age <= ?";
    return sql;
}
public String buildActionFigureSQL(double height, boolean can_move, String character_name){
    String sql = buildSQL("action_figure");
    if (height != -1) {
        sql+= " AND sa.height = ?";
    }
    sql+= " AND sa.can_move = ?";

    if (character_name != null && !character_name.isEmpty()) {
        sql+= " AND sa.character_name = ?";
    }
    return sql;
}
     public String buildStuffedAnimalSQL(String color, String animal, String brand){
         String sql = buildSQL("stuffed_animal");
         if (color != null && !color.isEmpty()) {
             sql+= " AND sa.color = ?";
         }
         if (animal != null && !animal.isEmpty()) {
             sql+= " AND sa.animal = ?";
         }
         if (brand != null && !brand.isEmpty()) {
             sql += " AND sa.brand = ?";
         }
         return sql;
     }
public String buildStuffedAnimalSQL(String category, String username, String min_price, String max_price, String start_age, String end_age, String color, String animal, String brand) {
    StringBuilder sql = new StringBuilder("SELECT ca.*, tl.toy_id FROM stuffed_animal sa INNER JOIN toy_listing tl ON sa.toy_id=tl.toy_id INNER JOIN custom_alerts ca using(category) WHERE category = ? and ca.username = ?");
    List<Object> params = new ArrayList<>();
    params.add(category);
    params.add(username);

    if (min_price != null) {
        sql.append(" AND tl.initial_price >= ?");
        params.add(Double.parseDouble(min_price));
    }
    if (max_price != null) {
        sql.append(" AND tl.initial_price <= ?");
        params.add(Double.parseDouble(max_price));
    }
    if (start_age != null) {
        sql.append(" AND tl.start_age >= ?");
        params.add(Integer.parseInt(start_age));
    }
    if (end_age != null) {
        sql.append(" AND tl.end_age <= ?");
        params.add(Integer.parseInt(end_age));
    }
    if (color != null && !color.isEmpty()) {
        sql.append(" AND sa.color = ?");
        params.add(color);
    }
    if (animal != null && !animal.isEmpty()) {
        sql.append(" AND sa.animal = ?");
        params.add(animal);
    }
    if (brand != null && !brand.isEmpty()) {
        sql.append(" AND sa.brand = ?");
        params.add(brand);
    }
    return sql.toString();
}
 %>
</body>
</html>