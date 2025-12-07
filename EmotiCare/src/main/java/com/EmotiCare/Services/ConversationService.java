package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.ConversationRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ConversationService {

    private final ConversationRepository conversationRepo;
    private final AISentimentService sentimentService;
    private final AICrisisDetectionService crisisService;
    private final GroqService groqService;
    private final AuthService authService;

    public ConversationService(ConversationRepository conversationRepo,
                               AISentimentService sentimentService,
                               AICrisisDetectionService crisisService,
                               GroqService groqService, AuthService authService) {
        this.conversationRepo = conversationRepo;
        this.sentimentService = sentimentService;
        this.crisisService = crisisService;
        this.groqService = groqService;
        this.authService = authService;
    }

    public ConversationMessage saveUserMessage(String userId, String content) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }
        ConversationMessage cm = new ConversationMessage();
        cm.setUserId(userId);
        cm.setSender("user");
        cm.setContent(content);
        cm.setSentiment(sentimentService.analyzeSentiment(content));
        cm.setTimestamp(LocalDateTime.now());
        return conversationRepo.save(cm);
    }

    public Optional<ConversationMessage> getMessage(String userId, String id) {
        User currentUser = authService.getCurrentUser();

        if (!currentUser.getId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }

        Optional<ConversationMessage> msg = conversationRepo.findById(id);

        if (msg.isEmpty() || !msg.get().getUserId().equals(userId)) {
            throw new RuntimeException("Message not found or unauthorized");
        }

        return msg;
    }

    public List<ConversationMessage> getConversationForUser(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }
        return conversationRepo.findByUserId(userId);
    }

    public ConversationResult handleIncomingMessage(String userId, String message) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }

        if (message == null || message.trim().isEmpty()) {
            throw new RuntimeException("Message cannot be empty.");
        }
        message = message.trim();

        ConversationMessage userMsg = saveUserMessage(userId, message);

        if (crisisService.isCrisis(message)) {
            String emergency = crisisService.getEmergencyMessage();

            ConversationMessage assistant = new ConversationMessage();
            assistant.setUserId(userId);
            assistant.setSender("assistant");
            assistant.setContent(emergency);
            assistant.setTimestamp(LocalDateTime.now());
            conversationRepo.save(assistant);

            return new ConversationResult(emergency, null);
        }
        String reply = groqService.generateTherapyMessageAndSave(userId, message);

        Optional<Map<String, Object>> maybeActions = groqService.requestJsonActions(userId, message);
        Map<String, Object> actions = maybeActions.orElse(null);

        return new ConversationResult(reply, actions);
    }

    public static class ConversationResult {
        public final String reply;
        public final Map<String, Object> actions;
        public ConversationResult(String r, Map<String, Object> a) { this.reply = r; this.actions = a; }
    }
}
