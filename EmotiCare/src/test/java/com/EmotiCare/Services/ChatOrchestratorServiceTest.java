package com.EmotiCare.Services;

import com.EmotiCare.DTO.ChatResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ChatOrchestratorServiceTest {

    @Mock
    private AICrisisDetectionService crisisService;
    @Mock
    private AISentimentService sentimentService;
    @Mock
    private ConversationService conversationService;
    @Mock
    private RecommendationService recommendationService;
    @Mock
    private SuggestedActionService suggestedActionService;
    @Mock
    private TherapySessionService therapySessionService;

    @InjectMocks
    private ChatOrchestratorService orchestratorService;

    @Test
    void handleChat_returnsCrisisResponse_whenCrisis() {
        when(crisisService.isCrisis("help")).thenReturn(true);
        when(crisisService.getEmergencyMessage()).thenReturn("Emergency");

        ChatResponse response = orchestratorService.handleChat("u1", "help");
        assertThat(response.isCrisis()).isTrue();
        assertThat(response.getReply()).isEqualTo("Emergency");
    }

    @Test
    void handleChat_returnsNormalResponse_whenNotCrisis() {
        when(crisisService.isCrisis("hello")).thenReturn(false);
        when(conversationService.handleIncomingMessage("u1", "hello"))
                .thenReturn(new ConversationService.ConversationResult("Hi", Map.of()));
        when(sentimentService.analyzeSentiment("hello")).thenReturn("happy");
        when(recommendationService.recommendActivitiesForUser("u1", "happy")).thenReturn("Recs");

        ChatResponse response = orchestratorService.handleChat("u1", "hello");
        assertThat(response.isCrisis()).isFalse();
        assertThat(response.getReply()).isEqualTo("Hi");
    }
}
