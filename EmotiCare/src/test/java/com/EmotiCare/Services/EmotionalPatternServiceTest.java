package com.EmotiCare.Services;

import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Repositories.ConversationRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class EmotionalPatternServiceTest {

    @Mock
    private ConversationRepository repo;

    @InjectMocks
    private EmotionalPatternService service;

    @Test
    void detectPattern_detectsStressAtNight() {
        ConversationMessage m = new ConversationMessage();
        m.setSentiment("stressed");
        m.setTimestamp(LocalDateTime.of(2023, 1, 1, 23, 0)); // 11 PM
        List<ConversationMessage> msgs = Collections.nCopies(3, m);

        when(repo.findByUserIdAndTimestampAfter(eq("u1"), any())).thenReturn(msgs);

        String result = service.detectPattern("u1");
        assertThat(result).contains("Stress seems to appear more often late at night");
    }

    @Test
    void detectPattern_returnsNone_whenLowStress() {
        when(repo.findByUserIdAndTimestampAfter(eq("u1"), any())).thenReturn(List.of());
        String result = service.detectPattern("u1");
        assertThat(result).contains("No strong emotional pattern");
    }
}
