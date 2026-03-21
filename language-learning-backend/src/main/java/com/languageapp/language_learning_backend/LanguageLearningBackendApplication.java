package com.languageapp.language_learning_backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LanguageLearningBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(LanguageLearningBackendApplication.class, args);

		String url = "http://localhost:8080/swagger-ui.html";

		System.out.println("\n=====================================");
		System.out.println("🚀 APPLICATION STARTED SUCCESSFULLY!");
		System.out.println("👉 SWAGGER UI: " + url);
		System.out.println("=====================================\n");
	}
}