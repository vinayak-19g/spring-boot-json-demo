package com.example.sqlwebhook.service;

import com.example.sqlwebhook.dto.SolutionRequest;
import com.example.sqlwebhook.dto.WebhookRequest;
import com.example.sqlwebhook.dto.WebhookResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Service
@Slf4j
public class WebhookService {

    private final WebClient webClient;

    @Value("${app.name:John Doe}")
    private String name;

    @Value("${app.regNo:REG12347}")
    private String regNo;

    @Value("${app.email:john@example.com}")
    private String email;

    public WebhookService() {
        this.webClient = WebClient.builder()
                .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                .build();
    }

    public void executeWebhookFlow() {
        try {
            log.info("Starting webhook flow...");
            
            // Step 1: Generate webhook
            WebhookResponse webhookResponse = generateWebhook();
            log.info("Webhook generated successfully: {}", webhookResponse.getWebhook());
            
            // Step 2: Solve SQL problem based on regNo
            String sqlQuery = solveSqlProblem(webhookResponse.getAccessToken());
            log.info("SQL problem solved. Query: {}", sqlQuery);
            
            // Step 3: Submit solution
            submitSolution(webhookResponse.getAccessToken(), sqlQuery);
            log.info("Solution submitted successfully!");
            
        } catch (Exception e) {
            log.error("Error in webhook flow: ", e);
        }
    }

    private WebhookResponse generateWebhook() {
        WebhookRequest request = new WebhookRequest();
        request.setName(name);
        request.setRegNo(regNo);
        request.setEmail(email);

        return webClient.post()
                .uri("https://bfhldevapigw.healthrx.co.in/hiring/generateWebhook/JAVA")
                .bodyValue(request)
                .retrieve()
                .bodyToMono(WebhookResponse.class)
                .block();
    }

    private String solveSqlProblem(String accessToken) {
        // Determine question based on last two digits of regNo
        String lastTwoDigits = regNo.substring(regNo.length() - 2);
        int lastTwoDigitsInt = Integer.parseInt(lastTwoDigits);
        
        if (lastTwoDigitsInt % 2 == 1) {
            // Odd - Question 1
            return solveQuestion1();
        } else {
            // Even - Question 2
            return solveQuestion2();
        }
    }

    private String solveQuestion1() {
        // Question 1: Find the department with the highest average salary
        return """
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
                """;
    }

    private String solveQuestion2() {
        // Question 2: Find employees who earn more than their department average
        return """
                SELECT e.employee_id, e.first_name, e.last_name, e.salary, d.department_name
                FROM employees e
                JOIN departments d ON e.department_id = d.department_id
                WHERE e.salary > (
                    SELECT AVG(salary)
                    FROM employees
                    WHERE department_id = e.department_id
                )
                ORDER BY e.salary DESC
                """;
    }

    private void submitSolution(String accessToken, String sqlQuery) {
        SolutionRequest request = new SolutionRequest();
        request.setFinalQuery(sqlQuery);

        webClient.post()
                .uri("https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA")
                .header(HttpHeaders.AUTHORIZATION, accessToken)
                .bodyValue(request)
                .retrieve()
                .bodyToMono(String.class)
                .block();
    }
}
