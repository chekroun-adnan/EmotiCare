package com.EmotiCare.Services;

import com.EmotiCare.DTO.ChatResponse;
import com.EmotiCare.Entities.TherapySession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ChatOrchestratorService {

    private final AICrisisDetectionService crisisService;
    private final AISentimentService sentimentService;
    private final ConversationService conversationService;
    private final RecommendationService recommendationService;
    private final SuggestedActionService suggestedActionService;
    private final TherapySessionService therapySessionService;

    public ChatResponse handleChat(String userId, String message) {

        if (crisisService.isCrisis(message)) {
            return ChatResponse.crisis(
                    crisisService.getEmergencyMessage()
            );
        }

        ConversationService.ConversationResult convoResult =
                conversationService.handleIncomingMessage(userId, message);

        String sentiment = sentimentService.analyzeSentiment(message);

        String recommendations =
                recommendationService.recommendActivitiesForUser(userId, sentiment);

        suggestedActionService.generateAndSaveActions(
                userId,
                "User mood: " + sentiment + ". Message: " + message
        );

        return ChatResponse.normal(
                convoResult.reply,
                sentiment,
                recommendations,
                convoResult.actions
        );
    }

    public TherapySession startSession(String userId) {
        return therapySessionService.startSession(userId);
    }

    public String summarizeSession(String sessionId) {
        return therapySessionService.summarizeSessionWithAI(sessionId);
    }
}

