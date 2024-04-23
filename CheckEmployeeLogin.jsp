<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 4/21/24
  Time: 6:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Check Employee Login</title>
</head>
<body>
<%
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        log("DB Connection established.");

        String id = request.getParameter("username");
        String password = request.getParameter("password");
        log("Received ID: " + id + " and password.");

        String lookup = "SELECT id, password FROM admin WHERE id=? AND password=?";
        PreparedStatement ps = con.prepareStatement(lookup);
        ps.setString(1, id);
        ps.setString(2, password);
        log("Prepared statement for admin lookup.");

        ResultSet result = ps.executeQuery();
        log("Query executed for admin.");

        if (result.next()) {
            session.setAttribute("employeeid", id);
            log("Admin user validated, redirecting...");
            response.sendRedirect("AdminMain.jsp?user=" + id);
        } else {
            log("Admin user not found, checking customer rep...");
            lookup = "SELECT id, password FROM customer_representative WHERE id=? AND password=?";
            ps = con.prepareStatement(lookup);
            ps.setString(1, id);
            ps.setString(2, password);
            result = ps.executeQuery();
            log("Query executed for customer rep.");

            if (result.next()) {
                session.setAttribute("employeeid", id);
                log("Customer rep validated, redirecting...");
                response.sendRedirect("CustomerRepresentativeMain.jsp?rep_id=" + id);
            } else {
                log("Customer rep not found, incorrect login.");
                response.sendRedirect("AdminRepLogin.jsp?loginRet=" + URLEncoder.encode("Incorrect employee ID or password.", "ISO-8859-1"));
            }
        }
    } catch (Exception e) {
        log("Exception caught: " + e.getMessage());
        response.sendRedirect("AdminRepLogin.jsp?loginRet=" + URLEncoder.encode("Error logging in. Please try again.", "ISO-8859-1"));
    }
%>
</body>
</html>
