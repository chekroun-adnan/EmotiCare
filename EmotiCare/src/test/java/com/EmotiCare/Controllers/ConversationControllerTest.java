package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Services.ConversationService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ConversationControllerTest {

    @Mock
    private ConversationService conversationService;

    @InjectMocks
    private ConversationController controller;

    @Test
    void handleMessage_returnsResult() {
        ConversationService.ConversationResult res = new ConversationService.ConversationResult("reply", null);
        when(conversationService.handleIncomingMessage("u1", "msg")).thenReturn(res);

        ResponseEntity<ConversationService.ConversationResult> response = controller.handleMessage("u1", "msg");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
        assertThat(response.getBody().reply).isEqualTo("reply");
    }

    @Test
    void saveUserMessage_returnsOk() {
        when(conversationService.saveUserMessage("u1", "msg")).thenReturn(new ConversationMessage());
        ResponseEntity<ConversationMessage> response = controller.saveUserMessage("u1", "msg");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getMessage_returnsOk() {
        when(conversationService.getMessage("u1", "m1")).thenReturn(Optional.of(new ConversationMessage()));
        ResponseEntity<ConversationMessage> response = controller.getMessage("u1", "m1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getConversation_returnsOk() {
        when(conversationService.getConversationForUser("u1")).thenReturn(List.of(new ConversationMessage()));
        ResponseEntity<List<ConversationMessage>> response = controller.getConversation("u1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }
}
