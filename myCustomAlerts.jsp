<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*, com.cs336.pkg.*, java.util.ArrayList, java.util.List" %>
<%@ page import="java.util.stream.Stream" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
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
                    try (PreparedStatement ps = setPstmt(conn, sqlActionFigure, a)) {
                        try (ResultSet rs = ps.executeQuery()) {
                            List<Integer> toyIds = new ArrayList<>();
                            while (rs.next()) {
                                toyIds.add(rs.getInt("toy_id"));
                            }
                            if(toyIds.isEmpty()){
                                out.println("<td >No match</>");
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
                    try (PreparedStatement ps = setPstmt(conn,sqlBoardGame,a)) {
                        try (ResultSet rs = ps.executeQuery()) {
                            List<Integer> toyIds = new ArrayList<>();
                            while (rs.next()) {
                                toyIds.add(rs.getInt("toy_id"));
                            }
                            if(toyIds.isEmpty()){
                                out.println("<td >No match</>");
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
                    List<CustomAlert> alerts = CustomAlert.getCustomAlerts(username, conn);
                    List<CustomAlert> saAlerts = CustomAlert.byCategory(category, alerts);
                    for(CustomAlert a : saAlerts) {
            %>
            <tr>
                <td><%= a.getAlertName() %></td>
                <td><%= a.getMaxPrice() %></td>
                <td><%= a.getMinPrice() %></td>
                <td><%= a.getStartAge() %> - <%= a.getEndAge() %></td>
                <td><%= a.getColor() %></td>
                <td><%= a.getAnimal() %></td>
                <td><%= a.getBrand() %></td>
                <%
                    String sqlStuffedAnimal = buildStuffedAnimalSQL(a.getColor(), a.getAnimal(), a.getBrand());
                    try (PreparedStatement ps = setPstmt(conn,sqlStuffedAnimal,a)) {
                        try (ResultSet rs = ps.executeQuery()) {
                            Set<Integer> toyIds = new HashSet<>();
                            while (rs.next()) {
                                toyIds.add(rs.getInt("toy_id"));
                            }
                            if(toyIds.isEmpty()){
                                out.println("<td >No match</>");
                            }
                            else{
                                out.println("<td>Yes</><td>");
                                for(Integer toyId : toyIds) {%>
                <a href="listingDetails.jsp?id=<%= toyId %>">Check Listing</a>
                <%}
                    out.println("</td>");
                }
                }
                }
                %>
            </tr>
            <%}
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
    String sql= "SELECT ca.*, tl.toy_id FROM "+category+" sa INNER JOIN toy_listing tl ON sa.toy_id=tl.toy_id INNER JOIN custom_alerts ca using(category) WHERE category = ? and ca.username = ? and tl.openStatus=1";
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
public PreparedStatement setPstmt(Connection conn, String sql, CustomAlert a) throws SQLException {
    PreparedStatement ps = conn.prepareStatement(sql);
    int index = 1;
    ps.setString(index++, a.getCategory());
    ps.setString(index++, a.getUsername());
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
    if(a.getCategory().equals("board_game")){
    if (a.getPlayerCount() != 1) {
        ps.setInt(index++, a.getPlayerCount());
    }
    if (a.getGameBrand() != null && !a.getGameBrand().isEmpty()) {
        ps.setString(index++, a.getGameBrand());
    }}
    else if(a.getCategory().equals("stuffed_animal")){
    if (a.getColor() != null && !a.getColor().isEmpty()) {
        ps.setString(index++, a.getColor());
    }
    if (a.getAnimal() != null && !a.getAnimal().isEmpty()) {
        ps.setString(index++, a.getAnimal());
    }
    if (a.getBrand() != null && !a.getBrand().isEmpty()) {
        ps.setString(index++, a.getBrand());
    }}
    else if(a.getCategory().equals("action_figure")){
        if (a.getHeight()!=-1) {
            ps.setDouble(index++, a.getHeight());
        }
        ps.setBoolean(index++,(a.getCanMove()));
        if (a.getCharacterName() != null) {
            ps.setString(index++, a.getCharacterName());
        }
    }
    return ps;
}
 %>
</body>
</html>