<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 4/21/24
  Time: 6:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <meta charset="ISO-8859-1">
    <title>Admin Homepage</title>
</head>
<body>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    Statement stmt = con.createStatement();
    String admin_id = (String) session.getAttribute("employeeid");
    if (admin_id == null) {
        response.sendRedirect("login.jsp");
    }
    ResultSet resultset = stmt.executeQuery("SELECT id, password FROM customer_representative");
%>
<h1>Admin Home</h1>
<div style="display: flex; min-width: 150vh; padding:0 200px;">
    <div style="flex: 2; padding-right: 50px;"> <!-- Takes half the width of the parent container -->
        <h3 style="text-align: center;">Current Customer Reps</h3>
        <table style="width: 90%; border-collapse: collapse;">
            <tr>
                <th>Rep ID</th>
                <th>Password</th>
            </tr>
            <%
                if (!resultset.next()) {
            %>
            <tr>
                <td colspan="2" style="text-align: center;">None</td>
            </tr>
            <%
            } else {
                resultset.beforeFirst();
                while (resultset.next()) { %>
            <tr>
                <td><%= resultset.getString(1) %></td>
                <td><%= resultset.getString(2) %></td>
            </tr>
            <%
                    }
                }
            %>
        </table>
    </div>
    <div style="flex: 1; display: flex; flex-direction: column;"> <!-- Also takes half the width of the parent container -->
        <div>
            <h3 style="text-align: center;">Add Customer Rep</h3>
            <form method="post" action="makeRep.jsp">
                <table style="width: 100%;">
                    <tr>
                        <td>New Rep ID: <input type="text" name="id" value="" maxlength="30" required/></td>
                    </tr>
                    <tr>
                        <td>Rep Password: <input type="text" name="password" value="" maxlength="30" required/></td>
                    </tr>
                    <tr>
                        <td><input type="submit" value="Add" style="width: 100px;"/></td>
                    </tr>
                    <% if (request.getParameter("CreateRet") != null) { %>
                    <tr>
                        <td><p style="text-align: center;
                                color: <%= request.getParameter("CreateRetCode").equals("0") ? "blue" : "red" %>;">
                            <%= request.getParameter("CreateRet") %>
                        </p></td>
                    </tr>
                    <% } %>
                </table>
            </form>
        </div>
        <div>
            <h3 class="center-texts">Sales Reports</h3>
            <form action="CreateSalesReport.jsp">
                <table style="width: 100%;">
                    <tr>
                        <th>Start Date</th>
                        <th>End Date</th>
                    </tr>
                    <tr>
                        <td ><input type="datetime-local" required name="date1"></td>
                        <td><input type="datetime-local" required name="date2"></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;"><input type="submit" value="Create" style="width: 100px;"/></td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
</div>

</body>
</html>


<a style="margin-top: 30px;" href="logout.jsp">Logout</a>
</body>
</html>
