package com.example.empmanagement.service;

import com.example.empmanagement.dto.EmployeeDTO;
import com.example.empmanagement.entity.Employee;

import java.util.List;

/**
 * Service contract for Employee business operations.
 *
 * Programming to an interface (not the concrete class) means:
 *   - Controllers depend only on this abstraction, not on Hibernate internals.
 *   - The implementation can be swapped or mocked in tests without changing callers.
 */
public interface EmployeeService {

    /** Returns all employees ordered by name ascending. */
    List<Employee> getAllEmployees();

    /**
     * Returns an employee by ID.
     * @throws com.example.empmanagement.exception.ResourceNotFoundException if not found
     */
    Employee getEmployeeById(Long id);

    /**
     * Persists a new employee.
     * @throws IllegalArgumentException if the email is already registered
     */
    Employee saveEmployee(EmployeeDTO dto);

    /**
     * Updates an existing employee's fields.
     * @throws com.example.empmanagement.exception.ResourceNotFoundException if ID not found
     * @throws IllegalArgumentException if the new email belongs to a different employee
     */
    Employee updateEmployee(Long id, EmployeeDTO dto);

    /**
     * Deletes an employee by ID.
     * @throws com.example.empmanagement.exception.ResourceNotFoundException if not found
     */
    void deleteEmployee(Long id);

    /**
     * Full-text search across name, department, and email.
     * Returns an empty list (not null) when nothing matches.
     */
    List<Employee> searchEmployees(String keyword);
}
