package com.example.empmanagement.repository;

import com.example.empmanagement.entity.Employee;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Integration tests for EmployeeRepository.
 *
 * @DataJpaTest spins up an in-memory H2 database, applies your entity
 * mappings (ddl-auto=create-drop for test scope), and configures
 * only the JPA slice of the application context — no controllers, no services.
 *
 * This is the right place to test custom @Query methods and derived
 * query correctness without mocking.
 */
@DataJpaTest
@ActiveProfiles("test")
class EmployeeRepositoryTest {

    @Autowired
    private EmployeeRepository employeeRepository;

    @BeforeEach
    void setUp() {
        employeeRepository.deleteAll();

        employeeRepository.saveAll(List.of(
            Employee.builder().name("Arjun Sharma")
                .email("arjun@example.com").department("Engineering")
                .salary(new BigDecimal("90000")).build(),
            Employee.builder().name("Priya Mehta")
                .email("priya@example.com").department("HR")
                .salary(new BigDecimal("72000")).build(),
            Employee.builder().name("Vikram Singh")
                .email("vikram@example.com").department("Engineering")
                .salary(new BigDecimal("88000")).build()
        ));
    }

    @Test
    @DisplayName("findAll returns all seeded employees")
    void findAll_returnsAll() {
        assertThat(employeeRepository.findAll()).hasSize(3);
    }

    @Test
    @DisplayName("existsByEmailIgnoreCase returns true for existing email")
    void existsByEmail_found() {
        assertThat(employeeRepository.existsByEmailIgnoreCase("ARJUN@EXAMPLE.COM")).isTrue();
    }

    @Test
    @DisplayName("existsByEmailIgnoreCase returns false for unknown email")
    void existsByEmail_notFound() {
        assertThat(employeeRepository.existsByEmailIgnoreCase("nobody@example.com")).isFalse();
    }

    @Test
    @DisplayName("findByEmailIgnoreCase returns employee for known email")
    void findByEmail_found() {
        Optional<Employee> result = employeeRepository.findByEmailIgnoreCase("priya@example.com");
        assertThat(result).isPresent();
        assertThat(result.get().getName()).isEqualTo("Priya Mehta");
    }

    @Test
    @DisplayName("searchByKeyword matches name partial")
    void searchByKeyword_nameMatch() {
        List<Employee> results = employeeRepository.searchByKeyword("arj");
        assertThat(results).hasSize(1);
        assertThat(results.get(0).getName()).isEqualTo("Arjun Sharma");
    }

    @Test
    @DisplayName("searchByKeyword matches department partial — returns multiple")
    void searchByKeyword_departmentMatch() {
        List<Employee> results = employeeRepository.searchByKeyword("Engineering");
        assertThat(results).hasSize(2);
    }

    @Test
    @DisplayName("searchByKeyword is case-insensitive")
    void searchByKeyword_caseInsensitive() {
        List<Employee> results = employeeRepository.searchByKeyword("PRIYA");
        assertThat(results).hasSize(1);
    }

    @Test
    @DisplayName("searchByKeyword returns empty for no match")
    void searchByKeyword_noMatch() {
        List<Employee> results = employeeRepository.searchByKeyword("zzznomatch");
        assertThat(results).isEmpty();
    }

    @Test
    @DisplayName("save persists new employee and assigns generated ID")
    void save_assignsId() {
        Employee emp = Employee.builder()
                .name("New Person").email("new@example.com")
                .department("Finance").salary(new BigDecimal("65000")).build();

        Employee saved = employeeRepository.save(emp);

        assertThat(saved.getId()).isNotNull().isPositive();
    }

    @Test
    @DisplayName("deleteById removes employee from database")
    void deleteById_removesRecord() {
        Long id = employeeRepository.findByEmailIgnoreCase("arjun@example.com")
                .map(Employee::getId).orElseThrow();

        employeeRepository.deleteById(id);

        assertThat(employeeRepository.findById(id)).isEmpty();
        assertThat(employeeRepository.count()).isEqualTo(2);
    }
}
