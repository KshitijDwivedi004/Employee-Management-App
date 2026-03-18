-- Classpath schema used by Spring Boot SQL initialization.
-- DataSource already points to emp_mgmt_db, so no CREATE DATABASE/USE statements.

CREATE TABLE IF NOT EXISTS employees (
    id           BIGINT          NOT NULL AUTO_INCREMENT,
    name         VARCHAR(100)    NOT NULL,
    email        VARCHAR(150)    NOT NULL,
    department   VARCHAR(100)    NOT NULL,
    salary       DECIMAL(12, 2)  NOT NULL,
    created_at   TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_employee PRIMARY KEY (id),
    CONSTRAINT uk_employee_email UNIQUE (email)
);

-- Safe seed: duplicate emails are skipped.
INSERT IGNORE INTO employees (name, email, department, salary) VALUES
  ('Arjun Sharma',   'arjun.sharma@example.com',   'Engineering',  95000.00),
  ('Priya Mehta',    'priya.mehta@example.com',    'HR',           72000.00),
  ('Vikram Singh',   'vikram.singh@example.com',   'Engineering',  88000.00),
  ('Ananya Gupta',   'ananya.gupta@example.com',   'Marketing',    65000.00),
  ('Rajan Pillai',   'rajan.pillai@example.com',   'Finance',      91000.00);
