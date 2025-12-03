package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.Habit;
import com.EmotiCare.Repositories.HabitRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class RecommendationService {

    private final HabitRepository habitRepository;
    private final GroqService groqService;

    public RecommendationService(HabitRepository habitRepository, GroqService groqService) {
        this.habitRepository = habitRepository;
        this.groqService = groqService;
    }

    public List<Habit> getUserHabits(String userId) {
        return habitRepository.findByUserId(userId);
    }

    public String recommendActivitiesForUser(String userId, String moodSummary) {
        List<Habit> habits = getUserHabits(userId);
        String habitList = habits.stream()
                .map(h -> h.getName() + (h.getDescription() == null ? "" : " - " + h.getDescription()))
                .collect(Collectors.joining("\n"));

        String system = "You are an empathetic assistant that suggests small science-backed wellbeing activities tailored to a user's mood and habits. Provide 3 short suggestions with short reasons.";
        String prompt = "Mood summary: " + (moodSummary == null ? "none" : moodSummary) + "\nUser habits:\n" + (habitList.isEmpty() ? "none" : habitList);
        return groqService.ask(system, userId, prompt);
    }
}
