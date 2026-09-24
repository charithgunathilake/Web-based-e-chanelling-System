package com.echannel.exception;

/**
 * Custom checked exception used throughout the Repository layer.
 * Demonstrates INHERITANCE: this class extends Java's built-in Exception
 * class and forwards the message / cause to the parent constructor.
 */
public class DatabaseException extends Exception {

    public DatabaseException(String message) {
        super(message);
    }

    public DatabaseException(String message, Throwable cause) {
        super(message, cause);
    }
}
