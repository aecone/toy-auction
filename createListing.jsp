<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/8/24
  Time: 12:39 PM
  User enters details to create a new listing.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<html>
<head>
    <title>Create Listing</title>

</head>
<body>
<form action="insertListing.jsp" id="listingForm" method="POST" onsubmit="return validateForm()">
    Name: <input type="text" name="name"/> <br/>
    Category: <select name="category">
    <option value="" disabled selected hidden>select a toy category</option>
    <option value="action_figure">action figure</option>
    <option value="stuffed_animal">stuffed animal</option>
    <option value="board_game">board game</option>
</select><br>
    Age range: <input type="number" name="start_age"/> - <input type='number' name="end_age"/><br/>
    Price: <input type="number" name="price" step="0.01" /><br/>

    Increment: <input type=" number" name="increment" step="0.01"/> <br/>
    Minimum price: <input type="number" name="min_price" step="0.01"/> <br/>
    <%--    Start date and time: <input type="datetime-local" name="startDT"/> <br/>--%>
    Closing date and time: <input type="datetime-local" name="endDT"/> <br/>
    <input type="submit" value="Submit"/>
</form>
<script>
    function validateForm() {
        var form = document.getElementById("listingForm");
        var inputs = form.getElementsByTagName("input");
        var dropdown = form.querySelector("select[name='category']");
        for (var i = 0; i < inputs.length; i++) {
            if (inputs[i].value.trim() === "") {
                alert("Please fill in all fields.");
                return false; // Prevent form submission
            }
        }
        var price = parseFloat(document.getElementsByName("price")[0].value);
        var start_age = parseInt(document.getElementsByName("start_age")[0].value);
        var end_age = parseInt(document.getElementsByName('end_age')[0].value);
        var min_price = parseFloat(document.getElementsByName('min_price')[0].value);
        var increment = parseFloat(document.getElementsByName('increment')[0].value);
        if (price < 0 || start_age < 0 || end_age < 0 || min_price < 0 || increment < 0) {
            alert("Please enter non-negative values for price, age, and price increment.");
            return false; // Prevent form submission
        }
        if (start_age > end_age) {
            alert("Start age must be less than or equal to end age.");
            return false; // Prevent form submission
        }
        if (!dropdown.value) {
            alert("Please select a category.");
            return false; // Prevent form submission
        }
        return true; // Allow form submission
    }
</script>
</body>
</html>
