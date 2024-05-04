<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/14/24
  Time: 12:01 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.OffsetTime" %>
<%@ page import="java.time.ZoneOffset" %>
<%@ page import="java.text.DecimalFormat" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Browse Listings</title>
    <script>
        window.onload = function() {
            // Get all table rows
            var rows = document.querySelectorAll('table tr[data-href]');
            // Add click event listener to each row
            rows.forEach(function(row) {
                row.addEventListener('click', function() {
                    let href = row.getAttribute('data-href');
                    window.location.href = href;
                });
            });


            document.querySelector("#search-btn").addEventListener('click', ()=>{
                let url = new URL(window.location.href);
                url.searchParams.set("search",  document.querySelector("#search-input").value);
                window.history.replaceState({}, '', url.toString());
                location.reload();

            });
            document.querySelector("#filter-btn").addEventListener('click', ()=>{
                let url = new URL(window.location.href);
                let priceMin = document.querySelector("#price-min").valueAsNumber;
                if (!isNaN(priceMin)) {
                    url.searchParams.set("priceMin", priceMin);
                }

                let priceMax = document.querySelector("#price-max").valueAsNumber;
                if (!isNaN(priceMax)) {
                    url.searchParams.set("priceMax", priceMax);
                }

                let ageMin = document.querySelector("#age-min").valueAsNumber;
                if (!isNaN(ageMin)) {
                    url.searchParams.set("ageMin", ageMin);
                }

                let ageMax = document.querySelector("#age-max").valueAsNumber;
                if (!isNaN(ageMax)) {
                    url.searchParams.set("ageMax", ageMax);
                }
                let category = document.querySelector("#category-select").value;
                if (category){
                    url.searchParams.set("category",  category);
                }

                window.history.replaceState({}, '', url.toString());
                location.reload();

            });
            document.querySelector("#filter-toggle").addEventListener('click', ()=>{
                let div = document.querySelector(".filter-controls");
                div.style.display = div.style.display == "none" ? "block" : "none";
            });
        };


    </script>
</head>
<div class="search-controls">
    <div class="row search-row">
        <input  type="text" placeholder=" Search by product name" id= "search-input"/>
        <input type="submit" value="Search" id="search-btn"/>
        <input type="submit" value="Show filters" id="filter-toggle"/>
    </div>
    <div class="filter-controls" style="display: none">
        <div class="row filter-row">
            <p>Price Range</p>
            <div class="column">
                <div class="row">
                    <p>min</p>
                    <input id="price-min" class="filter-input"  type="number"  />
                    <p>max</p>
                    <input id="price-max" class="filter-input" type="number" />
                </div>
            </div>
        </div>

        <div class="row filter-row">
            <p>Age</p>
            <div class="column">
                <div class="row">
                    <p>min</p>
                    <input id="age-min" class="filter-input" type="number" />
                    <p>max</p>
                    <input id="age-max" class="filter-input" type="number"  />
                </div>
            </div>
        </div>

        <div class="row filter-row">
            <p>Category</p>
            <div class="column">
                <div class="row">
                    <select name="category" id="category-select" onchange="showAdditionalFields()">
                        <option value="" selected >select a toy category</option>
                        <option value="action_figure">action figure</option>
                        <option value="stuffed_animal">stuffed animal</option>
                        <option value="board_game">board game</option>

                    </select>
                    <input type="submit" value="Apply filters" id="filter-btn"/>
                </div>
            </div>
        </div>
    </div>

</div>

<%

// Create a connection to the database
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    BidData bidData = new BidData(conn);
    ToyListingData tld = new ToyListingData(conn);
    String search_query = request.getParameter("search");
    String user = request.getParameter("id");
    try {
        List<ToyListing> toys;
        if(user!= null){
            if (search_query != null) {
                toys = tld.getAllListingsWithSearch(search_query, user);
            } else {
                toys = tld.getAllListingsFromUser(user);
            }
        }
        else {
            if (search_query != null) {
                toys = tld.getAllListingsWithSearch(search_query, null);
            } else {
                toys = tld.getAllListings();
            }
        }

        if(toys== null || toys.isEmpty()){
            out.println("There are no listings.");
        }
        else {
            // Display the data in a table
            out.println("<table>");
            out.println("<tr><th>Category</th><th>Name</th><th>Age Range</th><th>Current Price</th><th>Increment</th><th>Start Time</th><th>Closing Time</th><th>status</th></tr>");
            for(ToyListing toy : toys) {
                String category = toy.getCategory();
                int id = toy.getToyId();
                double curPrice = bidData.highestBid(id);
                DecimalFormat df = new DecimalFormat("#.##");
                //no bids placed on it yet
                if(curPrice ==-1){
                    curPrice = toy.getInitialPrice();
                }
                String url = "listingDetails.jsp?id=" + id;
                out.println("<tr data-href=\"" + url + "\" class =\"listing-tr\">");
                category = category.replace("_", " ");
                out.println("<td>" + category + "</td>");
                out.println("<td>" + toy.getName() + "</td>");
                out.println("<td>" + toy.getStartAge() +" - "+ toy.getEndAge()+"</td>");
                out.println("<td>" + df.format(curPrice) + "</td>");
                out.println("<td>" + toy.getIncrement() + "</td>");

                LocalDateTime startTime = toy.getStartDateTime();
                // Define the format with AM/PM and without seconds
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm a");
                // Format the datetime using the formatter
                String startDT = startTime.format(formatter);
                out.println("<td>" + startDT + "</td>");
                LocalDateTime endTime = toy.getClosingDateTime();
                String endDT = endTime.format(formatter);
                out.println("<td>" + endDT + "</td>");

                if (LocalDateTime.now().toEpochSecond(ZoneOffset.UTC) > startTime.toEpochSecond(ZoneOffset.UTC) &&
                        LocalDateTime.now().toEpochSecond(ZoneOffset.UTC) < endTime.toEpochSecond(ZoneOffset.UTC)){
                    out.println("<td>auction in progress</td>");
                }else if (LocalDateTime.now().toEpochSecond(ZoneOffset.UTC) < startTime.toEpochSecond(ZoneOffset.UTC)){
                    out.println("<td>auction starting soon</td>");
                }
                else{
                    if(toy.getOpenStatus())
                        tld.deactivateToyListing(id);
                    out.println("<td>auction done</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>");
        }
        // Close resources
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle any exceptions
    } finally {
        // Ensure resources are closed even in case of exceptions
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
<p>
<a href="CustomerMain.jsp">Home</a>
</p>
</body>
</html>

