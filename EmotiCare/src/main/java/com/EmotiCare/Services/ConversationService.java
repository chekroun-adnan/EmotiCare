package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.ConversationMessage;
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

    public ConversationService(ConversationRepository conversationRepo,
                               AISentimentService sentimentService,
                               AICrisisDetectionService crisisService,
                               GroqService groqService) {
        this.conversationRepo = conversationRepo;
        this.sentimentService = sentimentService;
        this.crisisService = crisisService;
        this.groqService = groqService;
    }

    public ConversationMessage saveUserMessage(String userId, String content) {
        ConversationMessage cm = new ConversationMessage();
        cm.setUserId(userId);
        cm.setSender("user");
        cm.setContent(content);
        cm.setSentiment(sentimentService.analyzeSentiment(content));
        cm.setTimestamp(LocalDateTime.now());
        return conversationRepo.save(cm);
    }

    public Optional<ConversationMessage> getMessage(String id) {
        return conversationRepo.findById(id);
    }

    public List<ConversationMessage> getConversationForUser(String userId) {
        return conversationRepo.findByUserId(userId);
    }

    public ConversationResult handleIncomingMessage(String userId, String message) {
        ConversationMessage saved = saveUserMessage(userId, message);

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
