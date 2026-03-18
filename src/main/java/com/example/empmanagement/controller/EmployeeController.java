package com.example.empmanagement.controller;

import com.example.empmanagement.dto.EmployeeDTO;
import com.example.empmanagement.entity.Employee;
import com.example.empmanagement.service.EmployeeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;


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
    public String listEmployees(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {
        log.debug("GET /employees?page={}&size={}", page, size);

        Page<Employee> employeePage = employeeService.getEmployeesPage(page, size);
        model.addAttribute("employees", employeePage.getContent());
        model.addAttribute("currentPage", employeePage.getNumber());
        model.addAttribute("totalPages", employeePage.getTotalPages());
        model.addAttribute("pageSize", employeePage.getSize());
        model.addAttribute("totalItems", employeePage.getTotalElements());
        model.addAttribute("hasPrevious", employeePage.hasPrevious());
        model.addAttribute("hasNext", employeePage.hasNext());
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


    @GetMapping("/search")
    @ResponseBody
    public List<Employee> searchEmployees(@RequestParam(defaultValue = "") String keyword) {
        log.debug("GET /employees/search?keyword={}", keyword);
        return employeeService.searchEmployees(keyword);
    }
}
