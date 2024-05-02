package com.cs336.pkg;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class ToyListingData {
    private Connection conn;

    public ToyListingData(Connection conn) {
        this.conn = conn;
    }

    public ToyListing getToyListingDetails(int toyId, boolean getDetails) throws SQLException {
        String query = "SELECT * FROM toy_listing WHERE toy_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, toyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ToyListing tl = extractToyListing(rs);
                    if(getDetails) {
                        CategoryDetails cd = getCategoryDetails(tl.getCategory(), tl.getToyId());
                        tl.setCategoryDetails(cd);
                    }
                    return tl;
                }
            }
        }
        return null;
    }

    public CategoryDetails getCategoryDetails(String category, int toyId) throws SQLException {
        String query = "SELECT * FROM " + category + " WHERE toy_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, toyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractCategoryDetailsFromResultSet(category, rs);
                }
            }
        }
        return null;
    }

    public static ToyListing extractToyListing(ResultSet rs) throws SQLException {
        double initialPrice = rs.getDouble("initial_price");
        String category = rs.getString("category");
        String name = rs.getString("name");
        int startAge = rs.getInt("start_age");
        int endAge = rs.getInt("end_age");
        double secretMinPrice = rs.getDouble("secret_min_price");
        LocalDateTime closingDateTime = rs.getTimestamp("closing_datetime").toLocalDateTime();
        double increment = rs.getDouble("increment");
        int toyId = rs.getInt("toy_id");
        LocalDateTime startDateTime = rs.getTimestamp("start_datetime").toLocalDateTime();
        String username = rs.getString("username");

        return new ToyListing(initialPrice, category, name, startAge, endAge,
                secretMinPrice, closingDateTime, increment, toyId, startDateTime, username);
    }

    private CategoryDetails extractCategoryDetailsFromResultSet(String category, ResultSet rs) throws SQLException {
        // Extract category details from ResultSet and create CategoryDetails object
        CategoryDetails cd = new CategoryDetails();
        if (category.equals("action_figure")) {
            cd.addDetail("height",rs.getDouble("height"));
            cd.addDetail("canMove", rs.getBoolean("can_move"));
            cd.addDetail("characterName",rs.getString("character_name"));
            return cd;
        } else if (category.equals("board_game")) {
            int playerCount = rs.getInt("player_count");
            String brand = rs.getString("brand");
            boolean isCardsGame = rs.getBoolean("is_cards_game");
            cd.addDetail("playerCount",playerCount);
            cd.addDetail("brand",brand);
            cd.addDetail("isCardsGame",isCardsGame);

            return cd;
        } else if (category.equals("stuffed_animal")) {
            String color = rs.getString("color");
            String brand = rs.getString("brand");
            String animal = rs.getString("animal");
            cd.addDetail("color",color);
            cd.addDetail("brand",brand);
            cd.addDetail("animal",animal);
            return cd;
        }
        return null;
    }
}
