package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.Habit;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.HabitRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class HabitService {

    private final HabitRepository habitRepository;
    private final GroqService groqService;
    private final AuthService authService;

    public HabitService(HabitRepository habitRepository, GroqService groqService, AuthService authService) {
        this.habitRepository = habitRepository;
        this.groqService = groqService;
        this.authService = authService;
    }

    public Habit createHabit(Habit habit) {
        habit.setCompleted(false);
        return habitRepository.save(habit);
    }

    public List<Habit> getHabits(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return List.of();
        }
        return habitRepository.findByUserId(userId);
    }

    public Optional<Habit> getHabit(String id, String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return Optional.empty();
        }
        return habitRepository.findById(id);
    }

    public Habit updateHabit(Habit habit) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(habit.getUserId())) {
            throw new RuntimeException("Unauthorized");
        }
        return habitRepository.save(habit);
    }

    public void deleteHabit(String id) {
        habitRepository.deleteById(id);
    }

    public Habit markCompleted(String habitId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(habitId)) {
            throw new RuntimeException("Unauthorized");
        }
        Habit h = habitRepository.findById(habitId).orElseThrow(() -> new RuntimeException("Habit not found"));
        h.setCompleted(true);
        return habitRepository.save(h);
    }

    public String suggestHabitsWithAI(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return "unauthorized";
        }
        List<Habit> habits = getHabits(userId);
        String habitsText;

        if (habits.isEmpty()) {
            habitsText = "User has no tracked habits.";
        } else {
            habitsText = habits.stream()
                    .map(h -> "- " + h.getName() + (h.getDescription() != null && !h.getDescription().isBlank() ? ": " + h.getDescription() : ""))
                    .collect(Collectors.joining("\n"));
        }
        String system = "You are an assistant suggesting small habit improvements. Provide 3 practical, actionable suggestions tailored to the user's habits.";

        String suggestions = groqService.ask(system, userId, habitsText);
        return (suggestions == null || suggestions.isBlank()) ? "No habit suggestions available." : suggestions;
    }
}