package model;

import java.sql.Timestamp;

public class Contact {
    private int contactID;
    private Integer userID; // Using Integer to allow null for guests
    private String name;
    private String phone;
    private String subject;
    private String message;
    private String reply;
    private Timestamp createdAt;

    // Constructors
    public Contact() {
    }

    public Contact(int contactID, Integer userID, String name, String phone, 
                  String subject, String message, String reply, Timestamp createdAt) {
        this.contactID = contactID;
        this.userID = userID;
        this.name = name;
        this.phone = phone;
        this.subject = subject;
        this.message = message;
        this.reply = reply;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getContactID() {
        return contactID;
    }

    public void setContactID(int contactID) {
        this.contactID = contactID;
    }

    public Integer getUserID() {
        return userID;
    }

    public void setUserID(Integer userID) {
        this.userID = userID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Contact{" +
                "contactID=" + contactID +
                ", userID=" + userID +
                ", name='" + name + '\'' +
                ", phone='" + phone + '\'' +
                ", subject='" + subject + '\'' +
                ", message='" + message + '\'' +
                ", reply='" + reply + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}