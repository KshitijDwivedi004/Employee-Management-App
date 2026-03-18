package com.example.empmanagement.service.impl;

import com.example.empmanagement.dto.EmployeeDTO;
import com.example.empmanagement.entity.Employee;
import com.example.empmanagement.exception.ResourceNotFoundException;
import com.example.empmanagement.repository.EmployeeRepository;
import com.example.empmanagement.service.EmployeeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
@Slf4j
@RequiredArgsConstructor
public class EmployeeServiceImpl implements EmployeeService {

    private final EmployeeRepository employeeRepository;

    @Override
    @Transactional(readOnly = true)
    public List<Employee> getAllEmployees() {
        log.debug("Fetching all employees sorted by name");
        return employeeRepository.findAll(Sort.by(Sort.Direction.DESC, "updatedAt"));
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Employee> getEmployeesPage(int page, int size) {
        int safePage = Math.max(page, 0);
        int safeSize = Math.min(Math.max(size, 1), 100);
        Pageable pageable = PageRequest.of(safePage, safeSize, Sort.by(Sort.Direction.DESC, "updatedAt"));
        log.debug("Fetching employee page {} with size {}", safePage, safeSize);
        return employeeRepository.findAll(pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public Employee getEmployeeById(Long id) {
        log.debug("Fetching employee with id: {}", id);
        return employeeRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Employee", "id", id));
    }

    @Override
    public Employee saveEmployee(EmployeeDTO dto) {
        log.debug("Creating new employee with email: {}", dto.getEmail());

        // Guard: email must be unique across all employees
        if (employeeRepository.existsByEmailIgnoreCase(dto.getEmail())) {
            throw new IllegalArgumentException(
                "An employee with email '" + dto.getEmail() + "' already exists."
            );
        }

        Employee employee = mapToEntity(dto, new Employee());
        Employee saved = employeeRepository.save(employee);
        log.info("Created employee id={} name={}", saved.getId(), saved.getName());
        return saved;
    }

    @Override
    public Employee updateEmployee(Long id, EmployeeDTO dto) {
        log.debug("Updating employee id: {}", id);

        Employee existing = employeeRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Employee", "id", id));

        // Guard: allow keeping own email, but reject if another employee owns the new email
        Optional<Employee> emailOwner = employeeRepository.findByEmailIgnoreCase(dto.getEmail());
        if (emailOwner.isPresent() && !emailOwner.get().getId().equals(id)) {
            throw new IllegalArgumentException(
                "Email '" + dto.getEmail() + "' is already used by another employee."
            );
        }

        mapToEntity(dto, existing);  // update fields in-place
        Employee updated = employeeRepository.save(existing);
        log.info("Updated employee id={}", updated.getId());
        return updated;
    }

    @Override
    public void deleteEmployee(Long id) {
        log.debug("Deleting employee id: {}", id);

        // Verify exists before deleting — gives a meaningful 404 instead of silent no-op
        Employee employee = employeeRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Employee", "id", id));

        employeeRepository.delete(employee);
        log.info("Deleted employee id={} name={}", id, employee.getName());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Employee> searchEmployees(String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return Collections.emptyList();
        }
        log.debug("Searching employees with keyword: {}", keyword);
        return employeeRepository.searchByKeyword(keyword.trim());
    }


    private Employee mapToEntity(EmployeeDTO dto, Employee target) {
        target.setName(dto.getName().trim());
        target.setEmail(dto.getEmail().trim().toLowerCase());
        target.setDepartment(dto.getDepartment().trim());
        target.setSalary(dto.getSalary());
        return target;
    }
}
