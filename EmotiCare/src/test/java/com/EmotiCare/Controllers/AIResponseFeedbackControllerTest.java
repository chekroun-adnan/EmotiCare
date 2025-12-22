package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.AIResponseFeedback;
import com.EmotiCare.Services.AIResponseFeedbackService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AIResponseFeedbackControllerTest {

    @Mock
    private AIResponseFeedbackService feedbackService;

    @InjectMocks
    private AIResponseFeedbackController controller;

    @Test
    void create_returnsOk() {
        AIResponseFeedback feedback = new AIResponseFeedback();
        when(feedbackService.saveFeedback(feedback)).thenReturn(feedback);

        ResponseEntity<AIResponseFeedback> response = controller.create(feedback);
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getById_returnsOk_whenFound() {
        when(feedbackService.getFeedbackById("1")).thenReturn(Optional.of(new AIResponseFeedback()));
        ResponseEntity<AIResponseFeedback> response = controller.getById("1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getByUser_returnsOk() {
        when(feedbackService.getFeedbackForUser("u1")).thenReturn(List.of(new AIResponseFeedback()));
        ResponseEntity<List<AIResponseFeedback>> response = controller.getByUser("u1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void delete_returnsNoContent() {
        ResponseEntity<Void> response = controller.delete("1");
        verify(feedbackService).deleteFeedback("1");
        assertThat(response.getStatusCodeValue()).isEqualTo(204);
    }

    @Test
    void analyze_returnsOk() {
        when(feedbackService.analyzeFeedbackWithAI("u1")).thenReturn("Analysis");
        ResponseEntity<String> response = controller.analyze("u1");
        assertThat(response.getBody()).isEqualTo("Analysis");
    }
}
