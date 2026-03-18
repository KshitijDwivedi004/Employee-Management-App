package com.example.empmanagement;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Application entry point.
 *
 * Extends SpringBootServletInitializer so the app can be deployed as a WAR
 * to an external Tomcat, while still running with the embedded server via
 * `mvn spring-boot:run` during development.
 */
@SpringBootApplication
public class EmpManagementApplication extends SpringBootServletInitializer {

    /**
     * Required override for WAR deployment.
     * Maps the Spring Boot app to the servlet initializer.
     */
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(EmpManagementApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(EmpManagementApplication.class, args);
    }
}
