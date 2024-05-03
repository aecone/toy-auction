package com.cs336.pkg;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class BidData {
    private Connection conn;


    public BidData(Connection conn){
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

    public int insertBid(double price, String username, int toyId, boolean isAutoBid) throws SQLException {
        String sql = "INSERT INTO bid (time, price, username, toy_id, is_auto_bid) VALUES (NOW(), ?, ?, ?,?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setDouble(1, price);
            pstmt.setString(2, username);
            pstmt.setInt(3, toyId);
            pstmt.setBoolean(4, isAutoBid);
            pstmt.executeUpdate();
            ResultSet generatedKeys = pstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                return generatedKeys.getInt(1);
            }
            generatedKeys.close();

        }
        catch(SQLException e){
            System.out.println(e);
        }
        return -1;
    }
    public Bid extractBidFromResultSet(ResultSet rs) throws SQLException {
        int b_id = rs.getInt("b_id");
        double price = rs.getDouble("price");
        String username = rs.getString("username");
        int toyId = rs.getInt("toy_id");
        Timestamp time = rs.getTimestamp("time");
        LocalDateTime dateTime = time.toLocalDateTime();
        boolean isAutoBid = rs.getBoolean("is_auto_bid");
        return new Bid(b_id, dateTime,price, username, toyId, isAutoBid);
    }

    public double highestBid(int toyId) throws SQLException {
        String priceQuery = "SELECT price FROM bid WHERE toy_id = ? ORDER BY price DESC LIMIT 1";
        try(PreparedStatement pstmt = conn.prepareStatement(priceQuery)) {
            pstmt.setInt(1, toyId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("price");
            }
            rs.close();
        }
        return -1;
    }

    public Bid highestBidObj(int toyId) throws SQLException{
        String priceQuery = "SELECT * FROM bid WHERE toy_id = ? ORDER BY price DESC LIMIT 1";
        try(PreparedStatement pstmt = conn.prepareStatement(priceQuery)) {
            pstmt.setInt(1, toyId);
            ResultSet rs = pstmt.executeQuery();
            if (rs!=null && rs.next()) {
                return extractBidFromResultSet(rs);
            }
        }
        return null;
    }

    public List<Bid> getBidsByUser(String username) throws SQLException {
        String sql = "SELECT * FROM bid WHERE username = ?";
        List<Bid> bids = new ArrayList<>();
        try(PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try(ResultSet rs = pstmt.executeQuery()){

                while(rs.next()){
                    bids.add(extractBidFromResultSet(rs));
                }
            }
        }
        return bids;
    }



}
