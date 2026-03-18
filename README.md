# Employee Management Application

Spring Boot 3 · JSP · Hibernate · MySQL

---

## Prerequisites

| Tool    | Version   |
|---------|-----------|
| Java    | 17+       |
| Maven   | 3.9+      |
| MySQL   | 8.0+      |

---

## Database Setup

```bash
mysql -u root -p < schema.sql
```

This creates the `emp_mgmt_db` database, the `employees` table, and inserts 5 seed rows.

---

## Configuration

Edit `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/emp_mgmt_db?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
```

---

## Run (Development)

```bash
# Must use mvn spring-boot:run — NOT java -jar
# JSP requires the classpath, not the fat JAR layout
mvn spring-boot:run
```

Open: **http://localhost:8080/employees**

> **Why not `java -jar`?**
> Spring Boot's fat JAR uses a nested classloader that doesn't support JSP compilation.
> `mvn spring-boot:run` uses the regular project classpath, which `tomcat-embed-jasper` can read.

---

## Project Structure

```
src/main/java/com/example/empmanagement/
├── EmpManagementApplication.java   ← entry point + WAR initializer
├── controller/EmployeeController   ← MVC + REST search endpoint
├── dto/EmployeeDTO                 ← form-backing object (no audit fields)
├── entity/Employee                 ← JPA entity
├── exception/
│   ├── ResourceNotFoundException
│   └── GlobalExceptionHandler
├── repository/EmployeeRepository   ← JPA + custom JPQL search
└── service/
    ├── EmployeeService             ← interface
    └── impl/EmployeeServiceImpl    ← business logic + @Transactional

src/main/webapp/WEB-INF/views/
├── employee-list.jsp    ← table + live jQuery search
├── employee-form.jsp    ← add / edit form
├── error.jsp            ← global error page
└── fragments/header.jsp ← shared navbar + CSS imports
```

---

## Endpoints

| Method | URL                        | Description              |
|--------|----------------------------|--------------------------|
| GET    | `/employees`               | List all employees       |
| GET    | `/employees/new`           | Show add form            |
| POST   | `/employees`               | Save new employee        |
| GET    | `/employees/{id}/edit`     | Show edit form           |
| PUT    | `/employees/{id}`          | Update employee          |
| DELETE | `/employees/{id}`          | Delete employee          |
| GET    | `/employees/search?keyword=` | Live search (JSON)    |
