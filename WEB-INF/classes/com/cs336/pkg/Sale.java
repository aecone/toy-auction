package com.cs336.pkg;

import java.time.LocalDateTime;

public class Sale {
    private String saleId;
    private LocalDateTime date;
    private int toyId;
    private int bidId;

    public Sale(String saleId, LocalDateTime date, int toyId, int bidId) {
        this.saleId = saleId;
        this.date = date;
        this.toyId = toyId;
        this.bidId = bidId;
    }

    public String getSaleId() {
        return saleId;
    }

    public void setSaleId(String saleId) {
        this.saleId = saleId;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public int getToyId() {
        return toyId;
    }

    public void setToyId(int toyId) {
        this.toyId = toyId;
    }

    public int getBidId() {
        return bidId;
    }

    public void setBidId(int bidId) {
        this.bidId = bidId;
    }

    @Override
    public String toString() {
        return "Sale{" +
                "saleId='" + saleId + '\'' +
                ", date=" + date +
                ", toyId=" + toyId +
                ", bidId=" + bidId +
                '}';
    }
}
