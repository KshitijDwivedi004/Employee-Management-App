package com.example.empmanagement.exception;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

/**
 * Centralized exception handling for the MVC (JSP) layer.
 *
 * NOTE: @ControllerAdvice only intercepts exceptions thrown INSIDE
 * controller or service methods — not inside Servlet filters.
 * Filter-level exceptions (e.g. JWT errors) need to be handled
 * directly inside the filter with try-catch.
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * Handles the case where an employee ID does not exist.
     * Renders the error.jsp view with a descriptive message.
     */
    @ExceptionHandler(ResourceNotFoundException.class)
    public String handleResourceNotFound(ResourceNotFoundException ex, Model model) {
        model.addAttribute("errorTitle", "Resource Not Found");
        model.addAttribute("errorMessage", ex.getMessage());
        return "error";
    }

    /**
     * Catch-all for any unexpected runtime exception.
     * Prevents a raw stack trace from being shown to the user.
     */
    @ExceptionHandler(Exception.class)
    public String handleGenericException(Exception ex, Model model) {
        model.addAttribute("errorTitle", "Something Went Wrong");
        model.addAttribute("errorMessage", "An unexpected error occurred. Please try again.");
        return "error";
    }
}
