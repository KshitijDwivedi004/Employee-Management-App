package com.example.empmanagement.service;

import com.example.empmanagement.dto.EmployeeDTO;
import com.example.empmanagement.entity.Employee;
import com.example.empmanagement.exception.ResourceNotFoundException;
import com.example.empmanagement.repository.EmployeeRepository;
import com.example.empmanagement.service.impl.EmployeeServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.*;

/**
 * Unit tests for EmployeeServiceImpl.
 *
 * @ExtendWith(MockitoExtension) initialises mocks and injects them —
 * no Spring context is loaded, so these tests run in milliseconds.
 *
 * BDDMockito (given/when/then style) is used instead of Mockito
 * (when/verify style) for readability.
 */
@ExtendWith(MockitoExtension.class)
class EmployeeServiceImplTest {

    @Mock
    private EmployeeRepository employeeRepository;

    @InjectMocks
    private EmployeeServiceImpl employeeService;

    private Employee sampleEmployee;
    private EmployeeDTO sampleDTO;

    @BeforeEach
    void setUp() {
        sampleEmployee = Employee.builder()
                .id(1L)
                .name("Arjun Sharma")
                .email("arjun@example.com")
                .department("Engineering")
                .salary(new BigDecimal("90000.00"))
                .build();

        sampleDTO = EmployeeDTO.builder()
                .name("Arjun Sharma")
                .email("arjun@example.com")
                .department("Engineering")
                .salary(new BigDecimal("90000.00"))
                .build();
    }

    // ----------------------------------------------------------------
    // getAllEmployees
    // ----------------------------------------------------------------

    @Test
    @DisplayName("getAllEmployees returns sorted list from repository")
    void getAllEmployees_returnsSortedList() {
        given(employeeRepository.findAll(any(Sort.class)))
                .willReturn(List.of(sampleEmployee));

        List<Employee> result = employeeService.getAllEmployees();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getName()).isEqualTo("Arjun Sharma");
        then(employeeRepository).should().findAll(any(Sort.class));
    }

    // ----------------------------------------------------------------
    // getEmployeesPage
    // ----------------------------------------------------------------

    @Test
    @DisplayName("getEmployeesPage returns a paged result from repository")
    void getEmployeesPage_returnsPagedResult() {
        given(employeeRepository.findAll(any(Pageable.class)))
                .willReturn(new PageImpl<>(List.of(sampleEmployee)));

        var result = employeeService.getEmployeesPage(0, 10);

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getName()).isEqualTo("Arjun Sharma");
        then(employeeRepository).should().findAll(any(Pageable.class));
    }

    // ----------------------------------------------------------------
    // getEmployeeById
    // ----------------------------------------------------------------

    @Test
    @DisplayName("getEmployeeById returns employee when ID exists")
    void getEmployeeById_found() {
        given(employeeRepository.findById(1L)).willReturn(Optional.of(sampleEmployee));

        Employee result = employeeService.getEmployeeById(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getEmail()).isEqualTo("arjun@example.com");
    }

    @Test
    @DisplayName("getEmployeeById throws ResourceNotFoundException when ID missing")
    void getEmployeeById_notFound_throws() {
        given(employeeRepository.findById(99L)).willReturn(Optional.empty());

        assertThatThrownBy(() -> employeeService.getEmployeeById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Employee")
                .hasMessageContaining("99");
    }

    // ----------------------------------------------------------------
    // saveEmployee
    // ----------------------------------------------------------------

    @Test
    @DisplayName("saveEmployee persists and returns saved entity")
    void saveEmployee_success() {
        given(employeeRepository.existsByEmailIgnoreCase("arjun@example.com")).willReturn(false);
        given(employeeRepository.save(any(Employee.class))).willReturn(sampleEmployee);

        Employee result = employeeService.saveEmployee(sampleDTO);

        assertThat(result.getName()).isEqualTo("Arjun Sharma");
        then(employeeRepository).should().save(any(Employee.class));
    }

    @Test
    @DisplayName("saveEmployee throws IllegalArgumentException on duplicate email")
    void saveEmployee_duplicateEmail_throws() {
        given(employeeRepository.existsByEmailIgnoreCase("arjun@example.com")).willReturn(true);

        assertThatThrownBy(() -> employeeService.saveEmployee(sampleDTO))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("already exists");

        then(employeeRepository).should(never()).save(any());
    }

    // ----------------------------------------------------------------
    // updateEmployee
    // ----------------------------------------------------------------

    @Test
    @DisplayName("updateEmployee applies changes to existing entity")
    void updateEmployee_success() {
        EmployeeDTO updateDTO = EmployeeDTO.builder()
                .name("Arjun Updated")
                .email("arjun@example.com")
                .department("Management")
                .salary(new BigDecimal("110000.00"))
                .build();

        given(employeeRepository.findById(1L)).willReturn(Optional.of(sampleEmployee));
        given(employeeRepository.findByEmailIgnoreCase("arjun@example.com"))
                .willReturn(Optional.of(sampleEmployee)); // same employee — allowed
        given(employeeRepository.save(any(Employee.class))).willAnswer(inv -> inv.getArgument(0));

        Employee result = employeeService.updateEmployee(1L, updateDTO);

        assertThat(result.getName()).isEqualTo("Arjun Updated");
        assertThat(result.getDepartment()).isEqualTo("Management");
    }

    @Test
    @DisplayName("updateEmployee throws when email belongs to different employee")
    void updateEmployee_emailTakenByOther_throws() {
        Employee other = Employee.builder().id(2L).email("arjun@example.com").build();
        EmployeeDTO dto = EmployeeDTO.builder()
                .name("X").email("arjun@example.com").department("HR")
                .salary(BigDecimal.TEN).build();

        given(employeeRepository.findById(1L)).willReturn(Optional.of(sampleEmployee));
        given(employeeRepository.findByEmailIgnoreCase("arjun@example.com"))
                .willReturn(Optional.of(other)); // different ID — conflict

        assertThatThrownBy(() -> employeeService.updateEmployee(1L, dto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("another employee");
    }

    // ----------------------------------------------------------------
    // deleteEmployee
    // ----------------------------------------------------------------

    @Test
    @DisplayName("deleteEmployee calls repository delete for existing employee")
    void deleteEmployee_success() {
        given(employeeRepository.findById(1L)).willReturn(Optional.of(sampleEmployee));
        willDoNothing().given(employeeRepository).delete(sampleEmployee);

        employeeService.deleteEmployee(1L);

        then(employeeRepository).should().delete(sampleEmployee);
    }

    @Test
    @DisplayName("deleteEmployee throws ResourceNotFoundException for unknown ID")
    void deleteEmployee_notFound_throws() {
        given(employeeRepository.findById(99L)).willReturn(Optional.empty());

        assertThatThrownBy(() -> employeeService.deleteEmployee(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ----------------------------------------------------------------
    // searchEmployees
    // ----------------------------------------------------------------

    @Test
    @DisplayName("searchEmployees returns empty list for blank keyword")
    void searchEmployees_blankKeyword_returnsEmpty() {
        List<Employee> result = employeeService.searchEmployees("  ");

        assertThat(result).isEmpty();
        then(employeeRepository).should(never()).searchByKeyword(any());
    }

    @Test
    @DisplayName("searchEmployees delegates to repository for valid keyword")
    void searchEmployees_validKeyword_delegates() {
        given(employeeRepository.searchByKeyword("eng")).willReturn(List.of(sampleEmployee));

        List<Employee> result = employeeService.searchEmployees("eng");

        assertThat(result).hasSize(1);
        then(employeeRepository).should().searchByKeyword("eng");
    }
}
