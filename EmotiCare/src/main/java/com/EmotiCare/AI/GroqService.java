package com.EmotiCare.AI;

import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Repositories.ConversationRepository;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.*;

@Service
public class GroqService {
    private static final Logger logger = LoggerFactory.getLogger(GroqService.class);

    @Value("${groq.api.key}") private String apiKey;
    @Value("${groq.api.url}") private String apiUrl;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final ConversationRepository conversationRepo;

    public GroqService(ConversationRepository conversationRepo) {
        this.conversationRepo = conversationRepo;
    }

    // low-level call
    private Optional<String> callApi(String systemPrompt, String userMessage) {
        try {
            List<Map<String, String>> messages = new ArrayList<>();
            messages.add(Map.of("role", "system", "content", systemPrompt));
            messages.add(Map.of("role", "user", "content", userMessage));

            Map<String, Object> payload = new HashMap<>();
            payload.put("model", "meta-llama/llama-4-scout-17b-16e-instruct");
            payload.put("messages", messages);

            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(apiKey);
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(payload, headers);

            ResponseEntity<Map> resp = restTemplate.exchange(apiUrl, HttpMethod.POST, entity, Map.class);
            Map body = resp.getBody();
            if (body == null) return Optional.empty();

            List<Map<String, Object>> choices = (List<Map<String, Object>>) body.get("choices");
            if (choices == null || choices.isEmpty()) return Optional.empty();
            Map<String, Object> first = choices.get(0);
            Map<String, Object> message = (Map<String, Object>) first.get("message");
            if (message == null) return Optional.empty();

            String content = (String) message.get("content");
            return Optional.ofNullable(content);

        } catch (Exception e) {
            logger.error("Groq API call failed", e);
            return Optional.empty();
        }
    }

    public String ask(String systemPrompt, String userId, String userMessage) {
        Optional<String> resp = callApi(systemPrompt, userMessage);
        String content = resp.orElse("Sorry, I couldn't reach the AI service right now.");
        try {
            ConversationMessage assistant = new ConversationMessage();
            assistant.setUserId(userId);
            assistant.setSender("assistant");
            assistant.setContent(content);
            assistant.setTimestamp(LocalDateTime.now());
            conversationRepo.save(assistant);
        } catch (Exception e) {
            logger.warn("Failed to save assistant message: {}", e.getMessage());
        }
        return content;
    }

    public Optional<String> askRaw(String systemPrompt, String userMessage) {
        return callApi(systemPrompt, userMessage);
    }

    public Optional<Map<String, Object>> askForJson(String systemPrompt, String userMessage) {
        Optional<String> raw = callApi(systemPrompt, userMessage);
        if (raw.isEmpty()) return Optional.empty();
        String content = raw.get().trim();
        try {
            // Try to locate JSON within the content
            int start = content.indexOf('{');
            int end = content.lastIndexOf('}');
            if (start >= 0 && end >= 0 && end > start) {
                String json = content.substring(start, end + 1);
                Map<String, Object> map = objectMapper.readValue(json, new TypeReference<>() {});
                return Optional.of(map);
            }
            // not JSON
            return Optional.empty();
        } catch (Exception e) {
            logger.warn("Failed to parse JSON from AI response: {}", e.getMessage());
            return Optional.empty();
        }
    }

    public String moderate(String userId, String textToModerate) {
        String system = "You are a content moderator. Answer 'allow' or 'block' and a one-line reason for the following text.";
        return ask(system, userId, textToModerate);
    }

    public String summarize(String userId, String text, int bullets) {
        String system = "Summarize the following text in " + bullets + " concise bullet points.";
        return ask(system, userId, text);
    }


    public String predictMood(String userId, String moodHistory) {
        String system = "Based on the mood history, return a single-word mood label (e.g., happy, sad, stressed, neutral). Only output the word.";
        Optional<String> raw = askRaw(system, moodHistory);
        if (raw.isEmpty()) return "neutral";
        String first = raw.get().trim().split("\\s+")[0].replaceAll("[^a-zA-Z_-]", "").toLowerCase();
        return first.isEmpty() ? "neutral" : first;
    }

    public Optional<Map<String, Object>> requestJsonActions(String userId, String context) {
        String system = "Return a JSON object with key 'actions' which is an array of objects {\"action\":\"NAME\",\"description\":\"...\",\"urgency\":\"low|medium|high\"}. Do not include extra text.";
        return askForJson(system, context);
    }

    public String generateTherapyMessageAndSave(String userId, String userMessage) {
        String reply = "I hear you. " + userMessage;

        ConversationMessage assistant = new ConversationMessage();
        assistant.setUserId(userId);
        assistant.setSender("assistant");
        assistant.setContent(reply);
        assistant.setTimestamp(LocalDateTime.now());

        conversationRepo.save(assistant);
        return reply;
    }

}