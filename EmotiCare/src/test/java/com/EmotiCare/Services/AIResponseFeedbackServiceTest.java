package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.AIResponseFeedback;
import com.EmotiCare.Repositories.AIResponseFeedbackRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AIResponseFeedbackServiceTest {

    @Mock
    private AIResponseFeedbackRepository feedbackRepository;
    @Mock
    private GroqService groqService;

    @InjectMocks
    private AIResponseFeedbackService feedbackService;

    @Test
    void saveFeedback_saves() {
        when(feedbackRepository.save(any())).thenReturn(new AIResponseFeedback());
        AIResponseFeedback result = feedbackService.saveFeedback(new AIResponseFeedback());
        assertThat(result).isNotNull();
    }

    @Test
    void getFeedbackById_returnsOptional() {
        when(feedbackRepository.findById("1")).thenReturn(Optional.of(new AIResponseFeedback()));
        assertThat(feedbackService.getFeedbackById("1")).isPresent();
    }

    @Test
    void analyzeFeedbackWithAI_returnsSummary() {
        AIResponseFeedback f1 = new AIResponseFeedback();
        f1.setRating(5);
        f1.setComment("Good");
        when(feedbackRepository.findByUserId("u1")).thenReturn(List.of(f1));
        when(groqService.ask(any(), eq("u1"), any())).thenReturn("Feedback Summary");

        String result = feedbackService.analyzeFeedbackWithAI("u1");
        assertThat(result).isEqualTo("Feedback Summary");
    }
}
