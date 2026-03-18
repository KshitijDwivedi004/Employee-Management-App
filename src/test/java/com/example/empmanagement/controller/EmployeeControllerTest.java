package com.example.empmanagement.controller;

import com.example.empmanagement.dto.EmployeeDTO;
import com.example.empmanagement.entity.Employee;
import com.example.empmanagement.exception.ResourceNotFoundException;
import com.example.empmanagement.service.EmployeeService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Controller slice tests using @WebMvcTest.
 *
 * @WebMvcTest loads only the web layer (DispatcherServlet, controller,
 * validation, exception handler) — no JPA, no real service.
 * The service is replaced with a Mockito mock via @MockBean.
 *
 * Because JSP rendering requires a servlet container, view resolution
 * is not tested here — only that the controller returns the correct
 * view name, model attributes, and HTTP status codes.
 */
@WebMvcTest(EmployeeController.class)
class EmployeeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private EmployeeService employeeService;

    private Employee sampleEmployee;

    @BeforeEach
    void setUp() {
        sampleEmployee = Employee.builder()
                .id(1L)
                .name("Arjun Sharma")
                .email("arjun@example.com")
                .department("Engineering")
                .salary(new BigDecimal("90000.00"))
                .build();
    }

    // ----------------------------------------------------------------
    // GET /employees
    // ----------------------------------------------------------------

    @Test
    @DisplayName("GET /employees returns 200 and employee-list view")
    void listEmployees_returns200() throws Exception {
        given(employeeService.getAllEmployees()).willReturn(List.of(sampleEmployee));

        mockMvc.perform(get("/employees"))
                .andExpect(status().isOk())
                .andExpect(view().name("employee-list"))
                .andExpect(model().attributeExists("employees"));
    }

    // ----------------------------------------------------------------
    // GET /employees/new
    // ----------------------------------------------------------------

    @Test
    @DisplayName("GET /employees/new returns form view with blank DTO")
    void showAddForm_returns200() throws Exception {
        mockMvc.perform(get("/employees/new"))
                .andExpect(status().isOk())
                .andExpect(view().name("employee-form"))
                .andExpect(model().attributeExists("employeeDTO"));
    }

    // ----------------------------------------------------------------
    // POST /employees
    // ----------------------------------------------------------------

    @Test
    @DisplayName("POST /employees with valid data redirects to list")
    void saveEmployee_validData_redirects() throws Exception {
        given(employeeService.saveEmployee(any(EmployeeDTO.class))).willReturn(sampleEmployee);

        mockMvc.perform(post("/employees")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .param("name",       "Arjun Sharma")
                .param("email",      "arjun@example.com")
                .param("department", "Engineering")
                .param("salary",     "90000.00"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/employees"));
    }

    @Test
    @DisplayName("POST /employees with blank name returns form with errors")
    void saveEmployee_blankName_returnsForm() throws Exception {
        mockMvc.perform(post("/employees")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .param("name",       "")   // invalid
                .param("email",      "arjun@example.com")
                .param("department", "Engineering")
                .param("salary",     "90000.00"))
                .andExpect(status().isOk())
                .andExpect(view().name("employee-form"))
                .andExpect(model().attributeHasFieldErrors("employeeDTO", "name"));
    }

    @Test
    @DisplayName("POST /employees with invalid email returns form with errors")
    void saveEmployee_invalidEmail_returnsForm() throws Exception {
        mockMvc.perform(post("/employees")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .param("name",       "Arjun")
                .param("email",      "not-an-email")  // invalid
                .param("department", "Engineering")
                .param("salary",     "90000.00"))
                .andExpect(status().isOk())
                .andExpect(view().name("employee-form"))
                .andExpect(model().attributeHasFieldErrors("employeeDTO", "email"));
    }

    // ----------------------------------------------------------------
    // GET /employees/edit/{id}
    // ----------------------------------------------------------------

    @Test
    @DisplayName("GET /employees/edit/{id} returns pre-filled form")
    void showEditForm_found_returns200() throws Exception {
        given(employeeService.getEmployeeById(1L)).willReturn(sampleEmployee);

        mockMvc.perform(get("/employees/edit/1"))
                .andExpect(status().isOk())
                .andExpect(view().name("employee-form"))
                .andExpect(model().attributeExists("employeeDTO"));
    }

    @Test
    @DisplayName("GET /employees/edit/{id} with unknown ID surfaces error view")
    void showEditForm_notFound_surfacesError() throws Exception {
        given(employeeService.getEmployeeById(99L))
                .willThrow(new ResourceNotFoundException("Employee", "id", 99L));

        mockMvc.perform(get("/employees/edit/99"))
                .andExpect(status().isOk())
                .andExpect(view().name("error"));
    }

    // ----------------------------------------------------------------
    // GET /employees/delete/{id}
    // ----------------------------------------------------------------

    @Test
    @DisplayName("GET /employees/delete/{id} redirects after deletion")
    void deleteEmployee_redirects() throws Exception {
        given(employeeService.getEmployeeById(1L)).willReturn(sampleEmployee);
        willDoNothing().given(employeeService).deleteEmployee(1L);

        mockMvc.perform(get("/employees/delete/1"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/employees"));
    }

    // ----------------------------------------------------------------
    // GET /employees/search (REST JSON)
    // ----------------------------------------------------------------

    @Test
    @DisplayName("GET /employees/search returns JSON array")
    void searchEmployees_returnsJson() throws Exception {
        given(employeeService.searchEmployees("eng")).willReturn(List.of(sampleEmployee));

        mockMvc.perform(get("/employees/search").param("keyword", "eng"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$[0].name").value("Arjun Sharma"))
                .andExpect(jsonPath("$[0].department").value("Engineering"));
    }

    @Test
    @DisplayName("GET /employees/search with empty keyword returns empty array")
    void searchEmployees_emptyKeyword_returnsEmpty() throws Exception {
        given(employeeService.searchEmployees("")).willReturn(List.of());

        mockMvc.perform(get("/employees/search").param("keyword", ""))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$").isEmpty());
    }
}
