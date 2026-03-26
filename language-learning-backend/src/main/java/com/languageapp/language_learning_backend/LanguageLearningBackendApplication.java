package com.languageapp.language_learning_backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class LanguageLearningBackendApplication {

	public static void main(String[] args) {
		ConfigurableApplicationContext context =
				SpringApplication.run(LanguageLearningBackendApplication.class, args);

		String backendUrl = context.getEnvironment()
				.getProperty("backend.url");

		String url = backendUrl + "/swagger-ui.html";

		System.out.println("\n=====================================");
		System.out.println("🚀 APPLICATION STARTED SUCCESSFULLY!");
		System.out.println("👉 SWAGGER UI: " + url);
		System.out.println("=====================================\n");
	}
}