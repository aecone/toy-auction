package com.cs336.pkg;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class SaleData {
    private Connection conn;

    public SaleData(Connection conn) {
        this.conn = conn;
    }

    public void insertSale(int toy_id, int b_id) throws SQLException {
        String sql = "INSERT INTO sale ( date, toy_id, b_id) VALUES (NOW(), ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, toy_id);
            pstmt.setInt(2, b_id);
            pstmt.executeUpdate();
        }
    }

    // You can add more methods here, such as updateSale(), deleteSale(), etc.
}

