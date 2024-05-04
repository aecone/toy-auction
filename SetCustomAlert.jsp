<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<html>
<head>
    <title>Create Custom Alert</title>
    <link rel="stylesheet" type="text/css" href="styles.css">

</head>
<body>
<form action="insertAlert.jsp" method="POST" onsubmit="return validateForm()">
    Alert Name: <input type="text" name="alertName" required/> <br>
    Category: <select name="category" onchange="showAdditionalFields()" required>
        <option value="" disabled selected hidden>select a toy category</option>
        <option value="action_figure">Action Figure</option>
        <option value="stuffed_animal">Stuffed Animal</option>
        <option value="board_game">Board Game</option>
    </select> <br>

    Max Price: <input type="number" name="maxPrice" step="0.01" required/> <br>
    Min Price: <input type="number" name="minPrice" step="0.01" required/> <br>

    Age Range: <input type="number" name="startAge" required/> - <input type="number" name="endAge" required/> <br>

    <input type="submit" value="Create Alert"/>
</form>
<a href="CustomerMain.jsp">Cancel</a>

<script>
    function validateForm() {
        var alertName = document.getElementsByName("alertName")[0].value.trim();
        var category = document.getElementsByName("category")[0].value;
        var maxPrice = parseFloat(document.getElementsByName("maxPrice")[0].value);
        var minPrice = parseFloat(document.getElementsByName("minPrice")[0].value);
        var startAge = parseInt(document.getElementsByName("startAge")[0].value);
        var endAge = parseInt(document.getElementsByName("endAge")[0].value);

        if (alertName === "" || category === "" || isNaN(maxPrice) || isNaN(minPrice) || isNaN(startAge) || isNaN(endAge)) {
            alert("Please fill in all fields.");
            return false;
        }

        if (maxPrice <= minPrice) {
            alert("Maximum price must be greater than minimum price.");
            return false;
        }

        if (startAge >= endAge) {
            alert("Start age must be less than end age.");
            return false;
        }

        return true;
    }
</script>
</body>
</html>
