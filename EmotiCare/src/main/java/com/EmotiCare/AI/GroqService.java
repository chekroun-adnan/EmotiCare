package com.EmotiCare.AI;

import com.EmotiCare.DTO.AIAction;
import com.EmotiCare.DTO.GroqChatRequest;
import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Repositories.ConversationRepository;
import com.EmotiCare.Repositories.UserDataService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
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
    private final ConversationRepository conversationRepository;

    public GroqService(UserDataService userDataService, ConversationRepository conversationRepository) {
        this.userDataService = userDataService;
        this.conversationRepository = conversationRepository;
    }

    /**
     * Sends user message and data to Groq AI, saves conversation, and returns raw AI content.
     */
    public String generateTherapyMessageAndSave(String userId, String userMessage) {
        try {
            Map<String, Object> userData = userDataService.getUserData(userId);
            logger.info("User data keys: {}", userData.keySet());

            // Build messages history for the AI
            List<Map<String, String>> historyMessages = new ArrayList<>();

            String systemPrompt =
                    "You are the AI therapist assistant for EmotiCare. " +
                            "Your task is to respond empathetically to the user, using their data: past messages, mood history, journal entries, habits, and goals. " +
                            "Always generate a human-readable, helpful response that supports the user's feelings. " +
                            "Optionally, include a JSON action object like {\"action\":\"ACTION_NAME\",\"data\":{...}}.";

            Map<String, String> sys = Map.of(
                    "role", "system",
                    "content", systemPrompt + "\nUserData: " + objectMapper.writeValueAsString(userData)
            );
            historyMessages.add(sys);

            Map<String, String> userMsg = Map.of(
                    "role", "user",
                    "content", userMessage
            );
            historyMessages.add(userMsg);

            GroqChatRequest request = new GroqChatRequest();
            request.setModel("meta-llama/llama-4-scout-17b-16e-instruct");
            request.setMessages(historyMessages);

            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(apiKey);
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<GroqChatRequest> entity = new HttpEntity<>(request, headers);

            ResponseEntity<Map> response =
                    restTemplate.exchange(apiUrl, HttpMethod.POST, entity, Map.class);

            List<Map<String, Object>> choices =
                    (List<Map<String, Object>>) response.getBody().get("choices");

            Map<String, Object> message =
                    (Map<String, Object>) choices.get(0).get("message");

            String content = (String) message.get("content");

            // Save user message
            ConversationMessage userMsgEntity = new ConversationMessage();
            userMsgEntity.setUserId(userId);
            userMsgEntity.setSender("user");
            userMsgEntity.setContent(userMessage);
            userMsgEntity.setTimestamp(java.time.LocalDateTime.now());
            conversationRepository.save(userMsgEntity);

            // Save assistant message
            ConversationMessage assistantMsgEntity = new ConversationMessage();
            assistantMsgEntity.setUserId(userId);
            assistantMsgEntity.setSender("assistant");
            assistantMsgEntity.setContent(content);
            assistantMsgEntity.setTimestamp(java.time.LocalDateTime.now());
            conversationRepository.save(assistantMsgEntity);

            return content;

        } catch (Exception e) {
            logger.error("Error in GroqService", e);
            throw new RuntimeException("Groq API call failed: " + e.getMessage(), e);
        }
    }

    /**
     * Generates an AIAction object from AI response, ensuring a human-friendly message.
     */
    public AIAction generateAction(String userId, String userMessage) {
        String raw = generateTherapyMessageAndSave(userId, userMessage);

        try {
            // Try parsing raw response as AIAction
            AIAction action = objectMapper.readValue(raw, AIAction.class);

            // Map structured actions to real message dynamically if data is empty
            if (action.getAction() != null) {
                String userFriendlyMessage = switch (action.getAction()) {
                    case "EXPRESS_FEELINGS" -> {
                        Map<String, Object> data = action.getData();
                        String feeling = data.getOrDefault("feeling", "unspecified").toString();
                        String responsibility = data.getOrDefault("responsibility", "unspecified").toString();
                        yield "I hear that you're feeling " + feeling +
                                " and that your responsibilities make you feel " + responsibility +
                                ". Let's talk through this together.";
                    }
                    case "EXPRESS_EMPATHY" -> "I understand how you feel. Can you tell me more about what's going on?";
                    default -> raw; // fallback
                };
                action.setData(Map.of("message", userFriendlyMessage));
            } else {
                // fallback if raw isn't an action
                AIAction fallback = new AIAction();
                fallback.setAction("SEND_MESSAGE_TO_USER");
                fallback.setData(Map.of("message", raw));
                return fallback;
            }

            return action;

        } catch (Exception e) {
            // fallback if parsing fails
            AIAction fallback = new AIAction();
            fallback.setAction("SEND_MESSAGE_TO_USER");
            fallback.setData(Map.of("message", raw));
            return fallback;
        }
    }
}
