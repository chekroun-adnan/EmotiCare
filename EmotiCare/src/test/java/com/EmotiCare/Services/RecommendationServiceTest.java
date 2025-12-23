package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.Habit;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.HabitRepository;
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
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RecommendationServiceTest {

    @Mock
    private HabitRepository habitRepository;

    @Mock
    private GroqService groqService;

    @Mock
    private AuthService authService;

    @InjectMocks
    private RecommendationService recommendationService;

    @Test
    void getUserHabits_returnsHabits_whenAuthorized() {
        User user = new User();
        user.setId("user1");
        when(authService.getCurrentUser()).thenReturn(user);
        when(habitRepository.findByUserId("user1")).thenReturn(List.of(new Habit()));

        List<Habit> result = recommendationService.getUserHabits("user1");
        assertThat(result).hasSize(1);
    }

    @Test
    void getUserHabits_throws_whenUnauthorized() {
        User user = new User();
        user.setId("user1");
        when(authService.getCurrentUser()).thenReturn(user);

        assertThatThrownBy(() -> recommendationService.getUserHabits("user2"))
                .isInstanceOf(RuntimeException.class)
                .hasMessageContaining("Unauthorized");
    }

    @Test
    void recommendActivitiesForUser_returnsRecommendation() {
        User user = new User();
        user.setId("user1");
        when(authService.getCurrentUser()).thenReturn(user);
        when(habitRepository.findByUserId("user1")).thenReturn(List.of());
        when(groqService.ask(any(), eq("user1"), any())).thenReturn("Recommendations");

        String result = recommendationService.recommendActivitiesForUser("user1", "Happy");
        assertThat(result).isEqualTo("Recommendations");
    }
}
