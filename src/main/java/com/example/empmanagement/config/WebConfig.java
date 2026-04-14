package com.example.empmanagement.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.CharacterEncodingFilter;

/**
 * Web Configuration for Employee Management System.
 *
 * Configures character encoding for proper handling of UTF-8 characters
 * (like the Rupee symbol ₹) throughout the application.
 */
@Configuration
public class WebConfig {

    /**
     * Character Encoding Filter ensures all HTTP requests and responses
     * use UTF-8 encoding. This prevents character corruption issues
     * with special characters like the Rupee symbol (₹).
     */
    @Bean
    public CharacterEncodingFilter characterEncodingFilter() {
        CharacterEncodingFilter filter = new CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true);
        return filter;
    }
}
