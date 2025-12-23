package com.EmotiCare.Services;

import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Entities.Emotion;
import com.EmotiCare.Repositories.ConversationRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class EmotionTimelineServiceTest {

    @Mock
    private ConversationRepository repo;

    @InjectMocks
    private EmotionTimelineService service;

    @Test
    void timeline_returnsPoints() {
        ConversationMessage msg = new ConversationMessage();
        msg.setSentiment("JOY"); // match the enum
        msg.setTimestamp(LocalDateTime.now());

        when(repo.findByUserIdAndTimestampAfter(eq("u1"), any())).thenReturn(List.of(msg));

        List<EmotionTimelineService.EmotionPoint> result = service.timeline("u1", 7);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).emotion()).isEqualTo(Emotion.JOY);
        assertThat(result.get(0).score()).isEqualTo(2); // matches emotionScore(Emotion.JOY)
    }
}
