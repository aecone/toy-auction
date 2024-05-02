package com.cs336.pkg;

import java.time.LocalDateTime;

public class Bid {
    private int bidId;
    private LocalDateTime time;
    private double price;
    private String username;
    private int toyId;

    // Constructors
    public Bid() {
    }

    public Bid(int bidId, LocalDateTime time, double price, String username, int toyId) {
        this.bidId = bidId;
        this.time = time;
        this.price = price;
        this.username = username;
        this.toyId = toyId;
    }

    // Getters and Setters
    public int getBidId() {
        return bidId;
    }

    public void setBidId(int bidId) {
        this.bidId = bidId;
    }

    public LocalDateTime getTime() {
        return time;
    }

    public void setTime(LocalDateTime time) {
        this.time = time;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getToyId() {
        return toyId;
    }

    public void setToyId(int toyId) {
        this.toyId = toyId;
    }

    // toString method
    @Override
    public String toString() {
        return "Bid{" +
                "bidId=" + bidId +
                ", time=" + time +
                ", price=" + price +
                ", username='" + username + '\'' +
                ", toyId=" + toyId +
                '}';
    }
}
