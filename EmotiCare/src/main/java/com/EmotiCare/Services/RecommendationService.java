package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.Habit;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.HabitRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class RecommendationService {

    private final HabitRepository habitRepository;
    private final GroqService groqService;
    private final AuthService authService;

    public RecommendationService(HabitRepository habitRepository, GroqService groqService, AuthService authService) {
        this.habitRepository = habitRepository;
        this.groqService = groqService;
        this.authService = authService;
    }

    public List<Habit> getUserHabits(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }
        return habitRepository.findByUserId(currentUser.getId());
    }

    public String recommendActivitiesForUser(String userId, String moodSummary) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }
        if (moodSummary == null || moodSummary.trim().isEmpty()) {
            moodSummary = "none";
        }
        List<Habit> habits = getUserHabits(userId);

        String habitList = habits.isEmpty()
                ? "none"
                : habits.stream()
                .map(h -> h.getName() + (h.getDescription() == null ? "" : " - " + h.getDescription()))
                .collect(Collectors.joining("\n"));

        String system =
                "You are an empathetic assistant that suggests small, science-backed wellbeing activities " +
                        "tailored to a user's mood and habits. Provide exactly 3 short suggestions, each with a one-sentence reason.";

        String prompt =
                "Mood summary: " + moodSummary +
                        "\nUser habits:\n" + habitList;

        return groqService.ask(system, userId, prompt);
    }
}
