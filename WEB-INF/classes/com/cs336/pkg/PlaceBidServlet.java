package com.cs336.pkg;

import com.sun.tools.jconsole.JConsoleContext;
import com.sun.tools.jconsole.JConsolePlugin;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.List;
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


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            int toyId = Integer.parseInt(request.getParameter("id"));
            double bidAmt = Double.parseDouble(request.getParameter("bidAmt"));
            System.out.println(request.getParameter("isAutoBid"));
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
                BidDAO bidDAO = new BidDAO(conn);
                //insert new bid and get its id
                int bidId = bidDAO.insertBid(bidAmt,request.getSession().getAttribute("user").toString(), toyId, isAutoBid);

                //see which autobids are tracking this toylisting
                AutomaticBidDAO autobidDAO = new AutomaticBidDAO(conn);
                List<AutomaticBid> autoBids = autobidDAO.getAutomaticBidsByToyId(toyId);

                double prevHighestBid = bidAmt;
                double highestBid = autobidDAO.checkAutoBids(autoBids, prevHighestBid, toyId);

                while(highestBid>prevHighestBid){ //an autobidder placed a new bid
                    prevHighestBid = highestBid;
                    //see which autobids are still tracking the toy listing
                    autoBids = autobidDAO.getAutomaticBidsByToyId(toyId);
                    highestBid = autobidDAO.checkAutoBids(autoBids, prevHighestBid, toyId);
                }

                // Insert current user's bid into autobid table if it's an autobid
                if (isAutoBid) {
                    autobidDAO.insertAutomaticBid(autoBidIncrement, maxBid, bidId, toyId);

                    //run check with just added autobid in case price was raised by other autobids in while loop above
                    if(highestBid > bidAmt){
                        autoBids = autobidDAO.getAutomaticBidsByToyId(toyId);
                        prevHighestBid = highestBid;
                        highestBid = autobidDAO.checkAutoBids(autoBids, prevHighestBid, toyId);
                        while(highestBid>prevHighestBid){
                            prevHighestBid = highestBid;
                            autoBids = autobidDAO.getAutomaticBidsByToyId(toyId);
                            highestBid = autobidDAO.checkAutoBids(autoBids, prevHighestBid, toyId);
                        }
                    }
                }
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
