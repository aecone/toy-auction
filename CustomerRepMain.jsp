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
<html>
<head>
    <title>Customer Rep Main</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;

        }
        tr:nth-child(even) {
            background-color: #fffefe;
        }
        tr:nth-child(odd) {
            background-color: #efefef;
        }
        tr:hover {
            background-color: #DCEDFF; /* Optional: for hover effect */
        }
        td {
            padding: 10px;
            border: 2px solid;
            text-align: left;
            max-width: 500px; /* Correct the CSS error */
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;

        }
        .clickable-row {
            cursor: pointer;
        }
        form{
            border: 2px black solid;
        }
    </style>

</head>
<body>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    String rep_id = (String) session.getAttribute("employeeid");
    if (rep_id == null) {
        response.sendRedirect("login.jsp");
    }
%>
<h1>Hello <%= rep_id %> </h1>

<h2>Questions To Address</h2>
<%
    Statement st = con.createStatement();
    ResultSet resultset = st.executeQuery("SELECT q_id, question_text FROM question");
%>
<form action="answerQuestion.jsp" style="width:70%;" method="post">
    <table>
        <%
            if (!resultset.next()) {
        %>
        <tr>
            <td colspan="2">None</td>
        </tr>
        <%
        } else {
            resultset.beforeFirst();
            while (resultset.next()) {
        %>
        <tr class="clickable-row" data-q_id="<%= resultset.getString(1) %>">
            <td><%= resultset.getString(2) %></td>
        </tr>
        <%
                } // end while
            } // end if
        %>
    </table>
    <input type="hidden" name="q_id" id="hiddenInput">
</form>



<a class="back-button" href="logout.jsp">Logout</a>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const rows = document.querySelectorAll('.clickable-row');
        rows.forEach(row => {
            row.addEventListener('click', function() {
                const q_id = this.getAttribute('data-q_id');
                const hiddenInput = document.getElementById('hiddenInput');
                hiddenInput.value = q_id;
                this.closest('form').submit();
            });
        });
    });
</script>

</body>
</html>
