package com.EmotiCare.Services;

import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.ConversationRepository;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class AISentimentService {

    private final Map<String, List<String>> keywords = new LinkedHashMap<>();
    private final ConversationRepository conversationRepository;
    private final AuthService authService;
    private  final AISentimentService aisentimentService;

    public AISentimentService(ConversationRepository conversationRepository, AuthService authService, AISentimentService aisentimentService) {
        this.conversationRepository = conversationRepository;
        this.authService = authService;
        this.aisentimentService = aisentimentService;
        keywords.put("joyful", Arrays.asList("happy","joy","glad","delighted","pleased","content","cheerful","excited"));
        keywords.put("sad", Arrays.asList("sad","down","unhappy","depressed","blue","tearful"));
        keywords.put("stressed", Arrays.asList("stressed","anxious","overwhelmed","tense","burnout","panic"));
        keywords.put("angry", Arrays.asList("angry","mad","furious","irritated","annoyed","frustrated"));
        keywords.put("fearful", Arrays.asList("afraid","scared","fear","terrified","nervous"));
        keywords.put("lonely", Arrays.asList("lonely","alone","isolated"));
        keywords.put("bored", Arrays.asList("bored","unmotivated","meh","listless"));
        keywords.put("surprised", Arrays.asList("surprised","shocked","astonished"));
        keywords.put("confident", Arrays.asList("confident","proud","capable","sure"));
        keywords.put("neutral", Arrays.asList());
    }

    public String analyzeSentiment(String message) {
        if (message == null) return "neutral";
        String lower = message.toLowerCase();
        for (Map.Entry<String, List<String>> e : keywords.entrySet()) {
            for (String kw : e.getValue()) {
                if (lower.contains(kw)) return e.getKey();
            }
        }
        return "neutral";
    }
    public String analyzeUserMessage(String messageId) {
        ConversationMessage msg = conversationRepository.findById(messageId)
                .orElseThrow(() -> new RuntimeException("Message not found"));

        User currentUser = authService.getCurrentUser();
        if (!msg.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        return aisentimentService.analyzeSentiment(msg.getContent());
    }

    public void addKeyword(String emotion, String keyword) {
        keywords.computeIfAbsent(emotion, k -> new ArrayList<>()).add(keyword.toLowerCase());
    }
}
