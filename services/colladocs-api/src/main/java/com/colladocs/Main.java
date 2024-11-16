package com.colladocs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Map;

import com.colladocs.datatypes.SubscriptionLimits;

import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.PUT;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/user")
public class Main {

    private static Connection connection;

    private enum Subscription {
        FREE,
        BASIC,
        ADVANCED
    }

    public static void main(String[] args) throws SQLException{
        try {
            openDatabaseConnection();
            // below should fail
            try {
                removeUser("rileys1000@gmail.com", "piss sword");
                System.out.println("remove non existant user handled NOT handled correctly");
            } catch (Exception e) {
                System.out.println("removing non existant user handled correctly");
            }
            removeUser("dinglebopper@gmail.com", "dinglepassword");
            
            // below should pass
            try {
                removeUser("rileys1000@gmail.com", "password");
                System.out.println("remove real user handled correctly");
            } catch (Exception e) {
                System.out.println("remove real user NOT handled correctly");
            }
            addUser("rileys1000@gmail.com", "password", Subscription.BASIC);
            try {
                addUser("rileys1000@gmail.com", "password", Subscription.BASIC);
                System.out.println("duplicate users not handled correctly");
            } catch (Exception e) {
                System.out.println("duplicate users handled correctly");
            }

            try {
                changeUserEmail("rileys1000@gmail.com", "dinglebopper@gmail.com", "not my real password");
                System.out.println("renamed email with a non real password (bad)");
            } catch (Exception e) {
                System.out.println("did not rename because we used a non real password");
            }
            changeUserEmail("rileys1000@gmail.com", "dinglebopper@gmail.com", "password");

            changeUserPassword("dinglebopper@gmail.com", "password", "dinglepassword");

            System.out.println("dinglebopper has been demoted to a free account");
            changeUserSubscription("dinglebopper@gmail.com", "dinglepassword", Subscription.FREE);

            System.out.println("dinglebopper has been promoted to a advanced account");
            changeUserSubscription("dinglebopper@gmail.com", "dinglepassword", Subscription.ADVANCED);

        } catch (SQLException e) {
            System.err.println("Error occurred: " + e.getMessage());
        } finally {
            closeDatabaseConnection();
        }
    }

    @GET
    @Path("/{email}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getUser(@PathParam("email") String email) {
        System.out.println("Fetching user data...");
        
        try (PreparedStatement statement = connection.prepareStatement("""
                SELECT email, subscription_type, join_date, last_login_date, max_documents, max_document_size
                FROM DOCUMENT_USER
                WHERE email = ?
            """)) {

            statement.setString(1, email);
            var resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String userEmail = resultSet.getString("email");
                int subscriptionType = resultSet.getInt("subscription_type");
                Timestamp joinDate = resultSet.getTimestamp("join_date");
                Timestamp lastLoginDate = resultSet.getTimestamp("last_login_date");
                int maxDocuments = resultSet.getInt("max_documents");
                int maxDocumentSize = resultSet.getInt("max_document_size");

                // Create a response object for simplicity
                var userResponse = Map.of(
                    "email", userEmail,
                    "subscriptionType", subscriptionType,
                    "joinDate", joinDate.toString(),
                    "lastLoginDate", lastLoginDate.toString(),
                    "maxDocuments", maxDocuments,
                    "maxDocumentSize", maxDocumentSize
                );

                return Response.ok(userResponse, MediaType.APPLICATION_JSON).build();
            } else {
                return Response
                    .status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("User not found"))
                    .build();
            }

        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            return Response
                .status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("An internal error occurred"))
                .build();
        }
    }
    
    @PUT
    @Path("changeEmail")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(Response)
    private static Response changeUserEmail(String oldEmail, String newEmail, String password) throws SQLException {
        if (newEmail.equals(oldEmail)) {
            return Response
                .status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("New email must be different from current email"))
                .build();
        }
        System.out.println("Renaming a users email...");
        int rowsInserted;
        try (PreparedStatement statement = connection.prepareStatement("""
                UPDATE DOCUMENT_USER
                SET email = ?
                WHERE email = ? AND password = ?
            """)) {

            statement.setString(1, newEmail);
            statement.setString(2, oldEmail);
            statement.setString(3, password);

            rowsInserted = statement.executeUpdate();
            return Response.ok(newEmail, MediaType.TEXT_PLAIN);
        } catch (SQLException e) {
                System.err.println("Database error: " + e.getMessage());
            return Response
                .status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("An internal error occurred"))
                .build();
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            return Response
                .status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("An unexpected error occurred"))
                .build();
        }
        if (rowsInserted == 0) {
            throw new SQLException("password incorrect");
        }
        System.out.println(String.format("Rename email from %s to %s: %s", oldEmail, newEmail, (rowsInserted == 1 ? "successfully" : "unsuccessfully")));
    }

    private static void changeUserPassword(String email, String oldPassword, String newPassword) throws SQLException {
        System.out.println("Renaming a users password...");
        int rowsInserted;
        try (PreparedStatement statement = connection.prepareStatement("""
                UPDATE DOCUMENT_USER
                SET password = ?
                WHERE email = ? AND password = ?
            """)) {

            statement.setString(1, newPassword);
            statement.setString(2, email);
            statement.setString(3, oldPassword);

            rowsInserted = statement.executeUpdate();
        }
        System.out.println(String.format("Rename password from %s to %s: %s", oldPassword, newPassword, (rowsInserted == 1 ? "successfully" : "unsuccessfully")));
    }

    private static void changeUserSubscription(String email, String password, Subscription newSubscription) throws SQLException {
        System.out.println("Upgrading a users subscription type...");
        int rowsInserted;
        try (PreparedStatement statement = connection.prepareStatement("""
                UPDATE DOCUMENT_USER
                SET subscription_type = ?, max_documents = ?, max_document_size = ?
                WHERE email = ? AND password = ?
            """)) {

            int new_max_docs = getLimits(newSubscription).getMaxDocuments();
            int new_max_doc_size = getLimits(newSubscription).getMaxDocumentSize();

            statement.setInt(1, newSubscription.ordinal());
            statement.setInt(2, new_max_docs);
            statement.setInt(3, new_max_doc_size);
            statement.setString(4, email);
            statement.setString(5, password);

            rowsInserted = statement.executeUpdate();
        }
        System.out.println(String.format("upgraded user to %s: %s", newSubscription, (rowsInserted == 1 ? "successfully" : "unsuccessfully")));
    }
    
    private static void removeUser(String email, String password) throws SQLException {
        System.out.println("Removing a user...");
        int rowsInserted;
        try (PreparedStatement statement = connection.prepareStatement("""
                    DELETE FROM DOCUMENT_USER
                    WHERE DOCUMENT_USER.email = ?
                    AND DOCUMENT_USER.password = ?
                """)) {

                statement.setString(1, email);
                statement.setString(2, password);

                rowsInserted = statement.executeUpdate();
            }
            System.out.println("Rows deleted: " + rowsInserted);
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

    private static String connectionStatus(Connection connection) throws SQLException{
        return (connection.isValid(5) ? "online" : "offline");
    }

    private static SubscriptionLimits getLimits(Subscription subscription) {
        switch (subscription) {
            case FREE -> {
                return new SubscriptionLimits(3, 5000);
            }
            case BASIC -> {
                return new SubscriptionLimits(50, 96000);
            }
            case ADVANCED -> {
                return new SubscriptionLimits(500, 512000);
            }
            default -> throw new IllegalArgumentException("Invalid subscription type: " + subscription);
        }
    }

    private static void openDatabaseConnection() throws SQLException{
        System.out.println("Connection to database");
        connection = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521/ORCLPDB1",
            "user_G9feN", "ceMrSe3PYV"
        );
        System.out.println("Connection valid: " + connectionStatus(connection));
    }

    private static void closeDatabaseConnection() throws SQLException{
        System.out.println("Closing database connection...");
        connection.close();
        System.out.println("Connection pool status: " + connectionStatus(connection));
    }
}
