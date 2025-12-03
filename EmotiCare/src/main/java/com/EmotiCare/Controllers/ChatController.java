package com.EmotiCare.Controllers;

import com.EmotiCare.AI.AIPredictionService;
import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Repositories.ConversationRepository;
import com.EmotiCare.Services.AICrisisDetectionService;
import com.EmotiCare.Services.AISentimentService;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/chat")
public class ChatController {

    private final GroqService groqService;
    private final AISentimentService sentimentService;
    private final AIPredictionService predictionService;
    private final AICrisisDetectionService crisisService;
    private final ConversationRepository conversationRepository;

    private static final String DEFAULT_SYSTEM_PROMPT = """
            You are EmotiCare, a friendly emotional-support assistant.
            Always respond with empathy, emotional awareness, and supportive advice.
            Avoid giving medical or legal advice.
            Keep messages helpful, gentle, and conversational.
            """;

    public ChatController(GroqService groqService,
                          AISentimentService sentimentService,
                          AIPredictionService predictionService,
                          AICrisisDetectionService crisisService,
                          ConversationRepository conversationRepository) {

        this.groqService = groqService;
        this.sentimentService = sentimentService;
        this.predictionService = predictionService;
        this.crisisService = crisisService;
        this.conversationRepository = conversationRepository;
    }

    // -------------------------------------------------------------
    // MAIN CHAT ENDPOINT
    // -------------------------------------------------------------
    @PostMapping("/send")
    public String sendMessage(@RequestParam String userId, @RequestParam String message) {

        // 1. CRISIS DETECTION (HIGH PRIORITY)
        if (crisisService.isCrisis(message)) {
            return crisisService.getEmergencyMessage();
        }

        // 2. SENTIMENT ANALYSIS
        String sentiment = sentimentService.analyzeSentiment(message);

        // 3. PREDICT NEXT MOOD BASED ON HISTORY
        String predictedMood = predictionService.predictNextMood(userId);

        // 4. SAVE USER MESSAGE
        ConversationMessage userMsg = new ConversationMessage();
        userMsg.setUserId(userId);
        userMsg.setSender("user");
        userMsg.setContent(message);
        userMsg.setSentiment(sentiment);
        userMsg.setTimestamp(LocalDateTime.now());
        conversationRepository.save(userMsg);

        String aiResponse = groqService.ask(
                DEFAULT_SYSTEM_PROMPT,
                userId,
                message
        );

        return aiResponse + "\n\n(Predicted next mood: " + predictedMood + ")";
    }

    @GetMapping("/history")
    public List<ConversationMessage> getHistory(@RequestParam String userId) {
        return conversationRepository.findByUserIdOrderByTimestampAsc(userId);
    }
}