package com.languageapp.language_learning_backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.retry.annotation.EnableRetry;
import org.springframework.boot.web.context.WebServerInitializedEvent;
import org.springframework.context.ApplicationListener;
import java.net.URI;
import java.awt.*;

@SpringBootApplication
@EnableRetry
@EnableScheduling
@EnableCaching
public class LanguageLearningBackendApplication implements ApplicationListener<WebServerInitializedEvent> {

	public static void main(String[] args) {
		SpringApplication.run(LanguageLearningBackendApplication.class, args);
	}

	@Override
	public void onApplicationEvent(WebServerInitializedEvent event) {
		int port = event.getWebServer().getPort();
		String url = "http://localhost:" + port + "/swagger-ui.html";
		try {
			Desktop.getDesktop().browse(new URI(url));
		} catch (Exception e) {
			System.out.println("Swagger UI: " + url);
		}
	}
}
