package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.ConversationRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ConversationServiceTest {

    @Mock
    private ConversationRepository conversationRepo;
    @Mock
    private AISentimentService sentimentService;
    @Mock
    private AICrisisDetectionService crisisService;
    @Mock
    private GroqService groqService;
    @Mock
    private AuthService authService;

    @InjectMocks
    private ConversationService conversationService;

    @Test
    void saveUserMessage_savesMessage_whenAuthorized() {
        User user = new User();
        user.setId("u1");
        when(authService.getCurrentUser()).thenReturn(user);
        when(sentimentService.analyzeSentiment(any())).thenReturn("neutral");
        when(conversationRepo.save(any(ConversationMessage.class))).thenAnswer(i -> i.getArgument(0));

        ConversationMessage result = conversationService.saveUserMessage("u1", "Hello");
        assertThat(result.getSender()).isEqualTo("user");
        assertThat(result.getContent()).isEqualTo("Hello");
    }

    @Test
    void handleIncomingMessage_returnsReply_whenNotCrisis() {
        User user = new User();
        user.setId("u1");
        when(authService.getCurrentUser()).thenReturn(user);

        // Mocks for saveUserMessage
        when(sentimentService.analyzeSentiment(any())).thenReturn("neutral");
        // Mocks for handleIncomingMessage logic
        when(crisisService.isCrisis(any())).thenReturn(false);
        when(groqService.generateReply(eq("u1"), any())).thenReturn("AI Reply");

        ConversationService.ConversationResult result = conversationService.handleIncomingMessage("u1", "Hello");

        assertThat(result.reply).isEqualTo("AI Reply");
        verify(conversationRepo, times(2)).save(any(ConversationMessage.class)); // 1 user msg, 1 ai msg
    }

    @Test
    void handleIncomingMessage_returnsCrisisMessage_whenCrisis() {
        User user = new User();
        user.setId("u1");
        when(authService.getCurrentUser()).thenReturn(user);

        when(sentimentService.analyzeSentiment(any())).thenReturn("sad");
        when(crisisService.isCrisis(any())).thenReturn(true);
        when(crisisService.getEmergencyMessage()).thenReturn("Emergency!");

        ConversationService.ConversationResult result = conversationService.handleIncomingMessage("u1", "Help");

        assertThat(result.reply).isEqualTo("Emergency!");
        verify(groqService, never()).generateReply(any(), any());
    }

    @Test
    void getConversationForUser_returnsList() {
        User user = new User();
        user.setId("u1");
        when(authService.getCurrentUser()).thenReturn(user);
        when(conversationRepo.findByUserId("u1")).thenReturn(List.of(new ConversationMessage()));

        List<ConversationMessage> result = conversationService.getConversationForUser("u1");
        assertThat(result).hasSize(1);
    }
}
