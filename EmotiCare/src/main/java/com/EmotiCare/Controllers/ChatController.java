package com.EmotiCare.Controllers;

import com.EmotiCare.AI.AICrisisDetectionService;
import com.EmotiCare.AI.AIPredictionService;
import com.EmotiCare.AI.AISentimentService;
import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Repositories.ConversationRepository;
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

    public ChatController(GroqService groqService, AISentimentService sentimentService,
                          AIPredictionService predictionService, AICrisisDetectionService crisisService,
                          ConversationRepository conversationRepository){
        this.groqService = groqService;
        this.sentimentService = sentimentService;
        this.predictionService = predictionService;
        this.crisisService = crisisService;
        this.conversationRepository = conversationRepository;
    }

    @PostMapping("/send")
    public String sendMessage(@RequestParam String userId, @RequestParam String message){
        // 1. Crisis detection
        if(crisisService.isCrisis(message)) return crisisService.getEmergencyMessage();

        String sentiment = sentimentService.analyzeSentiment(message);

        String predictedMood = predictionService.predictNextMood(userId);

        ConversationMessage userMsg = new ConversationMessage();
        userMsg.setUserId(userId);
        userMsg.setSender("user");
        userMsg.setContent(message);
        userMsg.setSentiment(sentiment);
        userMsg.setTimestamp(LocalDateTime.now());
        conversationRepository.save(userMsg);

        // 5. Generate AI response
        String aiResponse = groqService.generateTherapyMessageAndSave(userId,message);

        return aiResponse + "\n(Predicted next mood: " + predictedMood + ")";
    }

    @GetMapping("/history")
    public List<ConversationMessage> getHistory(@RequestParam String userId){
        return conversationRepository.findByUserIdOrderByTimestampAsc(userId);
    }
}
