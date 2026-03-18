package com.example.empmanagement.service;

import com.example.empmanagement.dto.EmployeeDTO;
import com.example.empmanagement.entity.Employee;
import org.springframework.data.domain.Page;

import java.util.List;


public interface EmployeeService {

    List<Employee> getAllEmployees();

    Page<Employee> getEmployeesPage(int page, int size);

    Employee getEmployeeById(Long id);

    Employee saveEmployee(EmployeeDTO dto);

    Employee updateEmployee(Long id, EmployeeDTO dto);

    void deleteEmployee(Long id);

    List<Employee> searchEmployees(String keyword);
}
