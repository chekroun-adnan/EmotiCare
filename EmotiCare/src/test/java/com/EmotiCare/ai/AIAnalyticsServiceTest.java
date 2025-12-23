package com.EmotiCare.ai;

import com.EmotiCare.Entities.Mood;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.MoodRepository;
import com.EmotiCare.Services.AuthService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AIAnalyticsServiceTest {

    @Mock
    private MoodRepository moodRepository;
    @Mock
    private AuthService authService;

    @InjectMocks
    private AIAnalyticsService service;

    @Test
    void generateWeeklySummary_returnsSummary() {
        User user = new User();
        user.setId("u1");
        when(authService.getCurrentUser()).thenReturn(user);

        Mood m = new Mood();
        m.setMood("happy");
        when(moodRepository.findByUserIdOrderByTimestampAsc("u1")).thenReturn(List.of(m));

        String summary = service.generateWeeklySummary(user);
        assertThat(summary).contains("happy=1");
    }
}
