# SQL Webhook Spring Boot Application

This Spring Boot application implements a webhook-based SQL problem solving system that:

1. **Generates a webhook** on startup by sending a POST request with user details
2. **Solves a SQL problem** based on the registration number (odd/even determines the question)
3. **Submits the solution** to the webhook URL using JWT authentication

## Features

- **Automatic execution** on application startup (no manual triggers needed)
- **Dynamic question selection** based on registration number
- **JWT authentication** for secure solution submission
- **Comprehensive logging** for debugging and monitoring
- **Configurable user details** via application properties

## Project Structure

```
src/main/java/com/example/sqlwebhook/
├── SqlwebhookApplication.java    # Main application class with startup trigger
├── dto/
│   ├── WebhookRequest.java       # Request DTO for webhook generation
│   ├── WebhookResponse.java      # Response DTO from webhook generation
│   └── SolutionRequest.java      # Request DTO for solution submission
└── service/
    └── WebhookService.java       # Main service handling the webhook flow
```

## Configuration

The application can be configured via `application.properties`:

```properties
# User details for webhook generation
app.name=John Doe
app.regNo=REG12347
app.email=john@example.com

# Logging configuration
logging.level.com.example.sqlwebhook=INFO
logging.level.org.springframework.web=INFO
```

## SQL Problems

The application solves one of two SQL problems based on the last two digits of the registration number:

### Question 1 (Odd numbers)
**Problem**: Find the department with the highest average salary

**Solution**:
```sql
SELECT d.department_name, AVG(e.salary) as avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
HAVING AVG(e.salary) = (
    SELECT MAX(avg_dept_salary)
    FROM (
        SELECT AVG(salary) as avg_dept_salary
        FROM employees
        GROUP BY department_id
    ) dept_avg
)
```

### Question 2 (Even numbers)
**Problem**: Find employees who earn more than their department average

**Solution**:
```sql
SELECT e.employee_id, e.first_name, e.last_name, e.salary, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
)
ORDER BY e.salary DESC
```

## API Endpoints Used

1. **Generate Webhook**: `POST https://bfhldevapigw.healthrx.co.in/hiring/generateWebhook/JAVA`
2. **Submit Solution**: `POST https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA`

## Technologies Used

- **Spring Boot 3.5.5** - Main framework
- **Spring WebFlux** - Reactive HTTP client
- **Lombok** - Reduces boilerplate code
- **Maven** - Build tool

## Building and Running

### Prerequisites
- Java 17 or higher
- Maven 3.6 or higher

### Build the Application
```bash
mvn clean package
```

### Run the Application
```bash
java -jar target/sqlwebhook-0.0.1-SNAPSHOT.jar
```

### Run with Maven
```bash
mvn spring-boot:run
```

## Execution Flow

1. **Application Startup**: The `CommandLineRunner` bean triggers the webhook flow
2. **Webhook Generation**: Sends POST request with user details to generate webhook
3. **Question Selection**: Determines which SQL problem to solve based on regNo
4. **Solution Generation**: Creates the appropriate SQL query
5. **Solution Submission**: Sends the SQL query to the webhook URL with JWT token
6. **Completion**: Logs success and application continues running

## Logging

The application provides detailed logging at each step:
- Webhook generation status
- Question selection (odd/even)
- SQL query generation
- Solution submission status
- Error handling

## Error Handling

The application includes comprehensive error handling:
- Network request failures
- Invalid responses
- Configuration issues
- All errors are logged for debugging

## Customization

To customize the application for different users:
1. Update the `application.properties` file with new user details
2. Modify the SQL queries in `WebhookService.java` if needed
3. Adjust logging levels as required

## Dependencies

- `spring-boot-starter-web` - Web application support
- `spring-boot-starter-webflux` - Reactive HTTP client
- `lombok` - Code generation
- `spring-boot-starter-test` - Testing support
