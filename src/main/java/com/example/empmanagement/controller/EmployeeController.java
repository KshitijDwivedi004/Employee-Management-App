package com.example.empmanagement.controller;

import com.example.empmanagement.dto.EmployeeDTO;
import com.example.empmanagement.entity.Employee;
import com.example.empmanagement.service.EmployeeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * MVC Controller for all Employee operations.
 *
 * Dual role:
 *  - @Controller methods render JSP views (list, form, error pages)
 *  - @ResponseBody method returns JSON for the jQuery live-search AJAX call
 *
 * URL design:
 *  GET  /employees              → list all
 *  GET  /employees/new          → show blank add form
 *  POST /employees              → save new employee
 *  GET  /employees/{id}/edit    → show pre-filled edit form
 *  PUT  /employees/{id}         → apply update
 *  DELETE /employees/{id}       → delete and redirect
 *  GET  /employees/search       → JSON search for jQuery (REST)
 */
@Controller
@RequestMapping("/employees")
@Slf4j
@RequiredArgsConstructor
public class EmployeeController {

    private final EmployeeService employeeService;

    // ----------------------------------------------------------------
    // READ — List all employees
    // ----------------------------------------------------------------

    @GetMapping
    public String listEmployees(Model model) {
        log.debug("GET /employees");
        model.addAttribute("employees", employeeService.getAllEmployees());
        return "employee-list";
    }

    // ----------------------------------------------------------------
    // CREATE — Show form / handle submission
    // ----------------------------------------------------------------

    @GetMapping("/new")
    public String showAddForm(Model model) {
        log.debug("GET /employees/new");
        model.addAttribute("employeeDTO", new EmployeeDTO());
        model.addAttribute("formTitle", "Add New Employee");
        model.addAttribute("formAction", "/employees");
        return "employee-form";
    }

    /**
     * Handles form POST for a new employee.
     *
     * @Valid triggers Bean Validation on the DTO fields.
     * BindingResult must immediately follow the @Valid parameter —
     * if swapped, Spring throws an exception instead of populating errors.
     *
     * RedirectAttributes.addFlashAttribute() stores a one-time message
     * in the session that survives the redirect and is available in the
     * next request's model — then deleted automatically.
     */
    @PostMapping
    public String saveEmployee(
            @Valid @ModelAttribute("employeeDTO") EmployeeDTO dto,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            log.debug("Validation failed on save: {} errors", result.getErrorCount());
            model.addAttribute("formTitle", "Add New Employee");
            model.addAttribute("formAction", "/employees");
            return "employee-form";
        }

        try {
            Employee saved = employeeService.saveEmployee(dto);
            log.info("Saved employee id={}", saved.getId());
            redirectAttributes.addFlashAttribute("successMessage",
                "Employee \"" + saved.getName() + "\" added successfully.");
        } catch (IllegalArgumentException ex) {
            // Duplicate email — surface as a field error
            result.rejectValue("email", "email.duplicate", ex.getMessage());
            model.addAttribute("formTitle", "Add New Employee");
            model.addAttribute("formAction", "/employees");
            return "employee-form";
        }

        return "redirect:/employees";
    }

    // ----------------------------------------------------------------
    // UPDATE — Show pre-filled form / handle submission
    // ----------------------------------------------------------------

    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model) {
        log.debug("GET /employees/{}/edit", id);
        Employee employee = employeeService.getEmployeeById(id);

        // Map entity → DTO so the form stays decoupled from the entity
        EmployeeDTO dto = EmployeeDTO.builder()
                .id(employee.getId())
                .name(employee.getName())
                .email(employee.getEmail())
                .department(employee.getDepartment())
                .salary(employee.getSalary())
                .build();

        model.addAttribute("employeeDTO", dto);
        model.addAttribute("formTitle", "Edit Employee");
        model.addAttribute("formAction", "/employees/" + id);
        return "employee-form";
    }

    @PutMapping("/{id}")
    public String updateEmployee(
            @PathVariable Long id,
            @Valid @ModelAttribute("employeeDTO") EmployeeDTO dto,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            log.debug("Validation failed on update id={}: {} errors", id, result.getErrorCount());
            model.addAttribute("formTitle", "Edit Employee");
            model.addAttribute("formAction", "/employees/" + id);
            return "employee-form";
        }

        try {
            Employee updated = employeeService.updateEmployee(id, dto);
            log.info("Updated employee id={}", updated.getId());
            redirectAttributes.addFlashAttribute("successMessage",
                "Employee \"" + updated.getName() + "\" updated successfully.");
        } catch (IllegalArgumentException ex) {
            result.rejectValue("email", "email.duplicate", ex.getMessage());
            model.addAttribute("formTitle", "Edit Employee");
            model.addAttribute("formAction", "/employees/" + id);
            return "employee-form";
        }

        return "redirect:/employees";
    }

    // ----------------------------------------------------------------
    // DELETE
    // ----------------------------------------------------------------

    @DeleteMapping("/{id}")
    public String deleteEmployee(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        log.debug("DELETE /employees/{}", id);
        Employee employee = employeeService.getEmployeeById(id); // throws 404 if missing
        employeeService.deleteEmployee(id);
        redirectAttributes.addFlashAttribute("successMessage",
            "Employee \"" + employee.getName() + "\" deleted successfully.");
        return "redirect:/employees";
    }

    // ----------------------------------------------------------------
    // REST — jQuery live search (returns JSON, not a view)
    // ----------------------------------------------------------------

    /**
     * Called by jQuery on every keystroke in the search box.
     * Returns a JSON array of matching employees.
     *
     * @ResponseBody bypasses the view resolver and writes the return
     * value directly to the HTTP response body via Jackson.
     */
    @GetMapping("/search")
    @ResponseBody
    public List<Employee> searchEmployees(@RequestParam(defaultValue = "") String keyword) {
        log.debug("GET /employees/search?keyword={}", keyword);
        return employeeService.searchEmployees(keyword);
    }
}
