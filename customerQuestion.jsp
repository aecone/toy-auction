<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 5/2/24
  Time: 7:57 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Customer Service</title>
  <link rel="stylesheet" type="text/css" href="styles.css">

  <style>
    .center {
      margin-left: auto;
      margin-right: auto;
    }
    table, th, td {
      border: 1px solid;
      border-collapse: collapse;
    }
    .form-container {
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    input[type="submit"] {
      margin-top: 10px; /* Add some space between the textarea and the button */
      width: 50%; /* Set the width of the button */
    }
  </style>
</head>
<body>
<%
  //Get the database connection
  ApplicationDB db = new ApplicationDB();
  Connection con = db.getConnection();
  Statement stmt = con.createStatement();
  String username = (String) session.getAttribute("user");
  if (username == null) {
    response.sendRedirect("CustomerMain.jsp");
  }
  ResultSet questionSet = stmt.executeQuery("SELECT q.question_text FROM question q WHERE q.username = username");
%>
<h1>Customer Service</h1>
<div style="display: flex; min-width: 150vh; padding:0 200px;">
  <div style="flex: 1; padding-right: 50px;  align-items: center; flex-direction: column;">
    <h3 style="text-align: center;" >Contact Us</h3>
    <form method="post" action="checkQuestion.jsp" class="form-container">
      <textarea id="question" name="c_question" rows="10" cols="50">Type in your inquiry here.</textarea>
      <input type="submit" style="padding: 10px; margin-top: 25px;" value="Send"/>
    </form>
  </div>
  <div style="flex: 2; display: flex; flex-direction: column;">
    <h3 style="text-align: center;">Your Past Questions</h3>
    <table style="width: 90%; border-collapse: collapse;">
      <tr>
      </tr>
      <%
        if (!questionSet.next()) {
      %>
      <tr>
        <td colspan="2" style="text-align: center;">None</td>
      </tr>
      <%
      } else {
        questionSet.beforeFirst();
        while (questionSet.next()) { %>
      <tr>
        <td><%= questionSet.getString(1) %></td>
      </tr>
      <%
          }
        }
      %>
    </table>
  </div>
</div>
<a class="back-button"href="CustomerMain.jsp">Back</a>

</body>
</html>



