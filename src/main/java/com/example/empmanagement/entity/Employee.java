package com.example.empmanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * JPA entity mapped to the `employees` table.
 *
 * Lombok annotations (@Getter, @Setter, etc.) generate boilerplate at
 * compile time — no need to write getters/setters manually.
 *
 * Bean Validation annotations (@NotBlank, @Email, etc.) are enforced
 * by both Hibernate (DDL constraints) and Spring MVC (@Valid in controller).
 */
@Entity
@Table(
    name = "employees",
    uniqueConstraints = @UniqueConstraint(columnNames = "email", name = "uk_employee_email")
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Name is required")
    @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
    @Column(nullable = false, length = 100)
    private String name;

    @NotBlank(message = "Email is required")
    @Email(message = "Please provide a valid email address")
    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @NotBlank(message = "Department is required")
    @Size(max = 100, message = "Department name must not exceed 100 characters")
    @Column(nullable = false, length = 100)
    private String department;

    @NotNull(message = "Salary is required")
    @DecimalMin(value = "0.0", inclusive = false, message = "Salary must be greater than 0")
    @Digits(integer = 10, fraction = 2, message = "Salary format: up to 10 digits, 2 decimal places")
    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal salary;


    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
