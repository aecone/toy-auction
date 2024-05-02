package com.cs336.pkg;

import java.sql.*;
import java.time.LocalDateTime;

public class BidDAO {
    private Connection conn;

    public BidDAO(Connection conn){
        this.conn = conn;
    }

    public Bid getBidById(int b_id) throws SQLException {
        String sql = "SELECT * FROM bid WHERE b_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, b_id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractBidFromResultSet(rs);
                }
            }
        }
        catch(SQLException e){
            System.out.println(e);
        }
        return null;
    }

    public int insertBid(double price, String username, int toyId) throws SQLException {
        String sql = "INSERT INTO bid (time, price, username, toy_id) VALUES (NOW(), ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setDouble(1, price);
            pstmt.setString(2, username);
            pstmt.setInt(3, toyId);
            pstmt.executeUpdate();
            ResultSet generatedKeys = pstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                return generatedKeys.getInt(1);
            }
        }
        catch(SQLException e){
            System.out.println(e);
        }
        return -1;
    }
    private Bid extractBidFromResultSet(ResultSet rs) throws SQLException {
        int b_id = rs.getInt("b_id");
        double price = rs.getDouble("price");
        String username = rs.getString("username");
        int toyId = rs.getInt("toy_id");
        Timestamp time = rs.getTimestamp("time");
        LocalDateTime dateTime = time.toLocalDateTime();
        return new Bid(b_id, dateTime,price, username, toyId);
    }

}
