package com.EmotiCare.AI;


import com.EmotiCare.DTO.GroqChatRequest;
import com.EmotiCare.Repositories.UserDataService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Service
public class GroqService {
    private static final Logger logger = LoggerFactory.getLogger(GroqService.class);

    @Value("${groq.api.key}")
    private String apiKey;

    @Value("${groq.api.url}")
    private String apiUrl;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final UserDataService userDataService;

    public GroqService(UserDataService userDataService) {
        this.userDataService = userDataService;
    }


    public String generateTherapyMessage(String userId, String userMessage) {
        try {
            Map<String, Object> userData = userDataService.getUserData(userId);
            logger.info("User data: {}", userData);

            String systemPrompt = "You are a therapy-focused AI assistant. " +
                    "Use the following user data (mood, journal entries, habits, goals) to generate a compassionate response:\n" +
                    objectMapper.writeValueAsString(userData);

            Map<String, String> systemMessage = Map.of("role", "system", "content", systemPrompt);
            Map<String, String> userMsg = Map.of("role", "user", "content", userMessage);

            GroqChatRequest request = new GroqChatRequest();
            request.setModel("meta-llama/llama-4-scout-17b-16e-instruct");
            request.setMessages(List.of(systemMessage, userMsg));

            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(apiKey);
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<GroqChatRequest> entity = new HttpEntity<>(request, headers);
            ResponseEntity<Map> response = restTemplate.exchange(apiUrl, HttpMethod.POST, entity, Map.class);

            List<Map<String, Object>> choices = (List<Map<String, Object>>) response.getBody().get("choices");
            Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
            return (String) message.get("content");

        } catch (Exception e) {
            logger.error("Error in GroqService", e);
            throw new RuntimeException("Groq API call failed: " + e.getMessage(), e);
        }
    }
}
