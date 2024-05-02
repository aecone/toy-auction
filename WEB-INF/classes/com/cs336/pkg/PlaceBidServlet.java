package com.cs336.pkg;

import com.sun.tools.jconsole.JConsoleContext;
import com.sun.tools.jconsole.JConsolePlugin;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;
import javax.sql.RowSet;
import javax.sql.rowset.CachedRowSet;
import javax.sql.rowset.RowSetProvider;


@WebServlet("/placeBid")
public class PlaceBidServlet extends HttpServlet {
    private double checkAutoBids(Connection conn, PreparedStatement pstmt, ResultSet autobidRS, double highestBid, int toyId, String insertBidSQL) {
        try {
            //check autobids for same toy listing
            while (autobidRS.next()) {
                double increment = autobidRS.getDouble("increment");
                double secretMaxPrice = autobidRS.getDouble("secret_max_price");
                int lastBidId = autobidRS.getInt("last_bid_id");
                int ab_id = autobidRS.getInt("ab_id");
                //get last bid made by the autobid
                String bidquery = "SELECT price, username FROM bid WHERE b_id = ?";
                pstmt = conn.prepareStatement(bidquery);
                pstmt.setInt(1, lastBidId);
                ResultSet bidRS = pstmt.executeQuery();

                if (bidRS.next()) {
                    double price = bidRS.getDouble("price");
                    String user = bidRS.getString("username");
                    pstmt.close();
                    //see if autobid can bid higher
                    double diff = highestBid - price;
                    int incTimes = (int) Math.ceil(diff / increment);
                    double newBid = price + incTimes * increment;
                    if (newBid > secretMaxPrice) {
                        //delete this autobid because can't outcompete current bid
                        String deletesql = "DELETE FROM automatic_bid WHERE ab_id= ?";
                        pstmt = conn.prepareStatement(deletesql);
                        pstmt.setInt(1,ab_id);
                        pstmt.executeUpdate();
                        pstmt.close();
                        //@TODO create alert for this user saying they were outbid
                    } else {
                        //create new bid for user
                        highestBid = newBid;
                        LocalDateTime time = LocalDateTime.now();
                        pstmt = conn.prepareStatement(insertBidSQL, Statement.RETURN_GENERATED_KEYS);
                        pstmt.setTimestamp(1, Timestamp.valueOf(time));
                        pstmt.setDouble(2, newBid);
                        pstmt.setString(3, user);
                        pstmt.setInt(4, toyId);
                        pstmt.executeUpdate();
                        ResultSet generatedKeys = pstmt.getGeneratedKeys();
                        int bidId = -1;
                        if (generatedKeys.next()) {
                            bidId = generatedKeys.getInt(1);
                        }
                        generatedKeys.close();
                        pstmt.close();
                        //update last bid id for autobid
                        String updatesql = "UPDATE automatic_bid SET last_bid_id = ? WHERE ab_id = ?";
                        pstmt=conn.prepareStatement(updatesql);
                        pstmt.setInt(1,bidId);
                        pstmt.setInt(2,ab_id);
                        pstmt.executeUpdate();
                        pstmt.close();
                    }
                } else {
                    // Handle case where no bid was found for the given bid ID
                    System.out.println("Did not find most recent bid for autobid");
                }
                bidRS.close();
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in checkAutoBids: " + e.getMessage());
            // Handle the exception as needed
        }
        return highestBid;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int toyId = Integer.parseInt(request.getParameter("id"));
            double bidAmt = Double.parseDouble(request.getParameter("bidAmt"));
            System.out.println(request.getParameter("isAutoBid"));
            //@TODO fix parsing of isAutoBid
            boolean isAutoBid = request.getParameter("isAutoBid")!=null && request.getParameter("isAutoBid").equals("on");
            double maxBid = -1;
            double autoBidIncrement = -1;
            if (isAutoBid) {
                maxBid = Double.parseDouble(request.getParameter("maxBid"));
                autoBidIncrement = Double.parseDouble(request.getParameter("autoBidIncrement"));
            }
            LocalDateTime bidTime = LocalDateTime.now();

            try {

                //Get the database connection
                ApplicationDB db = new ApplicationDB();
                Connection conn = db.getConnection();

// Create and execute the SQL INSERT statement
                String insertBidSQL = "INSERT INTO bid (time, price, username, toy_id) VALUES (?,?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(insertBidSQL, Statement.RETURN_GENERATED_KEYS);
                pstmt.setTimestamp(1, Timestamp.valueOf(bidTime));
                pstmt.setDouble(2, bidAmt);
                pstmt.setString(3, request.getSession().getAttribute("user").toString());
                pstmt.setInt(4, toyId);

                pstmt.executeUpdate();
                ResultSet generatedKeys = pstmt.getGeneratedKeys();
                int bidId = -1;
                if (generatedKeys.next()) {
                    bidId = generatedKeys.getInt(1);
                }
                generatedKeys.close();
                pstmt.close();
//
                //see which autobids are tracking this toylisting
                String query = "SELECT * FROM automatic_bid WHERE toy_id = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, toyId);
                ResultSet autobidRS = pstmt.executeQuery();
                double prevBid = bidAmt;
                double highestBid = checkAutoBids(conn, pstmt, autobidRS, bidAmt, toyId, insertBidSQL);
                pstmt.close();
                while(highestBid>prevBid){
                    prevBid = highestBid;
                    //see which autobids are still tracking the toy listing
                    pstmt = conn.prepareStatement(query);
                    pstmt.setInt(1, toyId);
                    autobidRS = pstmt.executeQuery();
                    highestBid = checkAutoBids(conn, pstmt, autobidRS, bidAmt, toyId, insertBidSQL);
                }
                // Insert into autobid table
                if (isAutoBid) {
                    String insertAutoBidSQL = "INSERT INTO automatic_bid (increment,secret_max_price,last_bid_id,toy_id) VALUES (?, ?,?,?)";
                    pstmt = conn.prepareStatement(insertAutoBidSQL);
                    pstmt.setDouble(1, autoBidIncrement);
                    pstmt.setDouble(2, maxBid);
                    pstmt.setInt(3, bidId);
                    pstmt.setInt(4, toyId);
                    pstmt.executeUpdate();
                    pstmt.close();
                    //if other autobid's raised price, run cur user's autobid that was just added
                    pstmt = conn.prepareStatement(query);
                    pstmt.setInt(1, toyId);
                    autobidRS = pstmt.executeQuery();
                    prevBid = bidAmt;
                    highestBid = checkAutoBids(conn, pstmt, autobidRS, bidAmt, toyId, insertBidSQL);
                    while(highestBid>prevBid){
                        prevBid = highestBid;
                        //see which autobids are still tracking the toy listing
                        pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, toyId);
                        autobidRS = pstmt.executeQuery();
                        highestBid = checkAutoBids(conn, pstmt, autobidRS, bidAmt, toyId, insertBidSQL);
                    }

                }

                autobidRS.close();
                System.out.println("is auto bid: "+isAutoBid);
                System.out.println("success");
                pstmt.close();
                conn.close();

                response.sendRedirect("/myBids.jsp");
            } catch (Exception e) {
                System.out.println("Error: " + e.getMessage());
            }
        } catch (Exception e) {
            // Handle exceptions
            System.out.println("Error: " + e.getMessage());
        }
//        response.sendRedirect("/myBids.jsp");
    }
}
