package com.example.sqlwebhook;

import com.example.sqlwebhook.service.WebhookService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
@Slf4j
public class SqlwebhookApplication {

	public static void main(String[] args) {
		SpringApplication.run(SqlwebhookApplication.class, args);
	}

	@Bean
	public CommandLineRunner commandLineRunner(WebhookService webhookService) {
		return args -> {
			log.info("Application started. Executing webhook flow...");
			webhookService.executeWebhookFlow();
		};
	}
}
