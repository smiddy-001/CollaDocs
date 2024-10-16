package com.colladocs.Application;

import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.colladocs.utils.SubscriptionLimits.SubscriptionLimits;

public class Application {

    private static Connection connection;

    private enum Subscription {
        FREE,
        BASIC,
        ADVANCED
    }

    public static void main(String[] args) throws SQLException{
        try {
            openDatabaseConnection();
            addUser("rileys1000@gmail.com", "password", Subscription.BASIC);
        } catch (SQLException e) {
            System.err.println("Error occurred: " + e.getMessage());
        } finally {
            closeDatabaseConnection();
        }
    }

    private static void addUser(String email, String password, Subscription subscription) throws SQLException{
        System.out.println("Creating a user...");
        int rowsInserted;
        try (PreparedStatement statement = connection.prepareStatement("""
                    INSERT INTO DOCUMENT_USER(email, password, join_date, last_login_date, subscription_type, max_documents, max_document_size)
                    VALUES(?, ?, ?, ?, ?, ?, ?)
                """)) {

                Timestamp current_time = new Timestamp(System.currentTimeMillis());

                int max_docs = getLimits(subscription).getMaxDocuments();
                int max_doc_size = getLimits(subscription).getMaxDocumentSize();

                statement.setString(1, email); // starts at 1, so the first ? is replaced with the email
                statement.setString(2, password);
                statement.setTimestamp(3, current_time);
                statement.setTimestamp(4, current_time);
                statement.setInt(5, subscription.ordinal());
                statement.setInt(6, max_docs);
                statement.setInt(7, max_doc_size);

                rowsInserted = statement.executeUpdate();
            }
            System.out.println("Rows inserted: " + rowsInserted);
    }

    private static SubscriptionLimits getLimits(Subscription subscription) {
        switch (subscription) {
            case FREE:
                return new SubscriptionLimits(5, 5000);
            case BASIC:
                return new SubscriptionLimits(50, 96000);
            case ADVANCED:
                return new SubscriptionLimits(500, 512000);
            default:
                throw new IllegalArgumentException("Invalid subscription type: " + subscription);
        }
    }

    private static void openDatabaseConnection() throws SQLException{
        System.out.println("Connection to database");
        connection = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521/ORCLPDB1",
            "user_G9feN", "ceMrSe3PYV"
        );
        System.out.println("Connection valid: " + connection.isValid(5));
    }

    private static void closeDatabaseConnection() throws SQLException{
        System.out.println("Closing database connection...");
        connection.close();
        System.out.println("Connection valid: " + connection.isValid(5));
    }
}
