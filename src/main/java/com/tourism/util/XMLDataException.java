package com.tourism.util;

/**
 * Thrown when tourist_places.xml cannot be found, read, or parsed.
 * Servlets catch this and forward the user to a friendly error page
 * instead of letting a raw stack trace reach the browser.
 */
public class XMLDataException extends Exception {

    public XMLDataException(String message) {
        super(message);
    }

    public XMLDataException(String message, Throwable cause) {
        super(message, cause);
    }
}
