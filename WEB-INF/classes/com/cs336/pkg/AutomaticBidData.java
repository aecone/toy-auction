package com.cs336.pkg;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AutomaticBidData {
    private Connection conn;

    public AutomaticBidData(Connection conn) {
        this.conn = conn;
    }

    public List<AutomaticBid> getAutomaticBidsByToyId(int toyId) throws SQLException {
        List<AutomaticBid> automaticBids = new ArrayList<>();
        String query = "SELECT * FROM automatic_bid WHERE toy_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, toyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    AutomaticBid automaticBid = extractAutomaticBidFromResultSet(rs);
                    automaticBids.add(automaticBid);
                }
            }
        }
        catch(SQLException e){
            System.out.println(e);
        }
        return automaticBids;
    }

    public void insertAutomaticBid(double increment, double secretMaxPrice, int lastBidId, int toyId) throws SQLException {
        String insertSQL = "INSERT INTO automatic_bid (increment, secret_max_price, last_bid_id, toy_id) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(insertSQL)) {
            pstmt.setDouble(1, increment);
            pstmt.setDouble(2, secretMaxPrice);
            pstmt.setInt(3, lastBidId);
            pstmt.setInt(4, toyId);
            pstmt.executeUpdate();
        }catch(SQLException e){
            System.out.println(e);
        }
    }

    public void deleteAutomaticBid(int abId) throws SQLException {
        String deleteSQL = "DELETE FROM automatic_bid WHERE ab_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(deleteSQL)) {
            pstmt.setInt(1, abId);
            pstmt.executeUpdate();
        }catch(SQLException e){
            System.out.println(e);
        }
    }

    public void updateLastBid(int abId, int newBidId) throws SQLException {
        String updatesql = "UPDATE automatic_bid SET last_bid_id = ? WHERE ab_id = ?";
        try (PreparedStatement updateStmt = conn.prepareStatement(updatesql)) {
            updateStmt.setInt(1, newBidId);
            updateStmt.setInt(2, abId);
            updateStmt.executeUpdate();
        }catch(SQLException e){
            System.out.println(e);
        }
    }

    // Helper method to extract an AutomaticBid object from the ResultSet
    private AutomaticBid extractAutomaticBidFromResultSet(ResultSet rs) throws SQLException {
        int abId = rs.getInt("ab_id");
        double increment = rs.getDouble("increment");
        double secretMaxPrice = rs.getDouble("secret_max_price");
        int lastBidId = rs.getInt("last_bid_id");
        int toyId = rs.getInt("toy_id");
        return new AutomaticBid(abId, increment, secretMaxPrice, lastBidId, toyId);
    }

    public double checkAutoBids(List<AutomaticBid> autoBids, double highestBid, int toyId) {
        ToyListingData tld = new ToyListingData(conn);

        try {
            double minIncrement = -1;
            try {
                ToyListing tl = tld.getToyListingDetails(toyId, false);
                minIncrement = tl.getIncrement();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            System.out.println("current autobids tracking "+toyId);
            for (AutomaticBid autoBid : autoBids) {
                System.out.println(autoBid.toString());
                double increment = autoBid.getIncrement();
                double secretMaxPrice = autoBid.getSecretMaxPrice();
                int lastBidId = autoBid.getLastBidId();
                int ab_id = autoBid.getAbId();

                // Get last bid made by the autobid
                BidData bidData = new BidData(conn);
                Bid lastBid = bidData.getBidById(lastBidId);
                if(lastBid!=null && lastBid.getPrice()!= highestBid) {
                    double lastBidAmt = lastBid.getPrice();
                    String user = lastBid.getUsername();

                    // See if autobid can bid higher
                    double diff = (highestBid+minIncrement) - lastBidAmt;
                    int incTimes = (int) Math.ceil(diff / increment);
                    double newBid = lastBidAmt + incTimes * increment;

                    if (newBid > secretMaxPrice) {
                        // Delete this autobid because it can't outcompete current bid
                        deleteAutomaticBid(ab_id);
                        //@TODO create alert for this user saying they were outbid
                    } else {
                        // Create new bid for user
                        highestBid = newBid;
                        int newBidId = bidData.insertBid(newBid,user, toyId, true);
                        updateLastBid(ab_id,newBidId);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in checkAutoBids: " + e.getMessage());
            // Handle the exception as needed
        }
        return highestBid;
    }
}
