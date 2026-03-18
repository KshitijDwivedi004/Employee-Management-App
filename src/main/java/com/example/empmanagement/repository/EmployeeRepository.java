package com.example.empmanagement.repository;

import com.example.empmanagement.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data JPA repository for Employee entities.
 *
 * JpaRepository<Employee, Long> provides:
 *   - save(), findById(), findAll(), deleteById(), existsById(), count(), etc.
 *
 * Custom methods below are resolved at startup via Spring Data query derivation
 * or explicit JPQL (@Query).
 */
@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    /**
     * Derived query: finds employees where name OR department contains the
     * given keyword (case-insensitive). Used by the jQuery live search endpoint.
     *
     * Equivalent JPQL:
     *   SELECT e FROM Employee e
     *   WHERE LOWER(e.name) LIKE LOWER(CONCAT('%', :name, '%'))
     *      OR LOWER(e.department) LIKE LOWER(CONCAT('%', :dept, '%'))
     */
    List<Employee> findByNameContainingIgnoreCaseOrDepartmentContainingIgnoreCase(
        String name, String department
    );

    /**
     * Checks whether a given email is already registered.
     * Used in the service layer to prevent duplicate email entries.
     */
    boolean existsByEmailIgnoreCase(String email);

    /**
     * Checks if an email belongs to a different employee (used on update
     * to allow keeping one's own email without triggering the uniqueness check).
     */
    Optional<Employee> findByEmailIgnoreCase(String email);

    /**
     * Custom JPQL search — searches across name, email, and department
     * in a single query. Used as an alternative to the derived query above
     * when you need broader matching.
     */
    @Query("SELECT e FROM Employee e WHERE " +
           "LOWER(e.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(e.department) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(e.email) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Employee> searchByKeyword(@Param("keyword") String keyword);
}
