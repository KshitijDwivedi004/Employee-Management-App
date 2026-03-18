package com.example.empmanagement.dto;

import jakarta.validation.constraints.*;
import lombok.*;

import java.math.BigDecimal;

/**
 * Data Transfer Object for Employee.
 *
 * Used as the form-backing object in controller methods annotated with
 * @ModelAttribute. Keeps the HTTP layer decoupled from the JPA entity,
 * protecting audit fields (createdAt, updatedAt) from being overwritten
 * by a malicious or malformed request payload.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmployeeDTO {

    private Long id;

    @NotBlank(message = "Name is required")
    @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
    private String name;

    @NotBlank(message = "Email is required")
    @Email(message = "Please provide a valid email address")
    private String email;

    @NotBlank(message = "Department is required")
    @Size(max = 100, message = "Department name must not exceed 100 characters")
    private String department;

    @NotNull(message = "Salary is required")
    @DecimalMin(value = "0.0", inclusive = false, message = "Salary must be greater than 0")
    @Digits(integer = 10, fraction = 2, message = "Salary: up to 10 digits, 2 decimal places")
    private BigDecimal salary;
}
