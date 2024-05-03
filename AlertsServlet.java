import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlertsServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            // Get the current user's username
            String username = (String) request.getSession().getAttribute("user");

            // Fetch alerts for the current user from the database
            List<String> alerts = new ArrayList<>();
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "username", "password");
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM alerts WHERE username = ?");
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                // Construct the alert message
                String alertMessage = "Alert: ";
                alertMessage += rs.getString("message"); // Adjust based on your alert structure
                alerts.add(alertMessage);
            }

            // Close resources
            rs.close();
            pstmt.close();
            conn.close();

            // Pass alerts data to the JSP
            request.setAttribute("alerts", alerts);
            RequestDispatcher rd = request.getRequestDispatcher("alerts.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
}
