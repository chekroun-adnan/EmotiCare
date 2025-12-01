package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.Habit;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.HabitRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class HabitService {

    private final HabitRepository habitRepository;
    private final GroqService groqService;

    public HabitService(HabitRepository habitRepository, GroqService groqService) {
        this.habitRepository = habitRepository;
        this.groqService = groqService;
    }

    public Habit createHabit(Habit habit) {
        habit.setCompleted(false);
        return habitRepository.save(habit);
    }

    public List<Habit> getHabits(String userId) {
        return habitRepository.findByUserId(userId);
    }

    public Optional<Habit> getHabit(String id) {
        return habitRepository.findById(id);
    }

    public Habit updateHabit(Habit habit) {
        return habitRepository.save(habit);
    }

    public void deleteHabit(String id) {
        habitRepository.deleteById(id);
    }

    public Habit markCompleted(String habitId) {
        Habit h = habitRepository.findById(habitId).orElseThrow(() -> new RuntimeException("Habit not found"));
        h.setCompleted(true);
        return habitRepository.save(h);
    }

    public String suggestHabitsWithAI(String userId) {
        List<Habit> habits = getHabits(userId);
        StringBuilder sb = new StringBuilder();
        if (habits.isEmpty()) {
            sb.append("User has no tracked habits.");
        } else {
            sb.append("User habits:\n");
            for (Habit h : habits) {
                sb.append("- ").append(h.getName());
                if (h.getDescription() != null && !h.getDescription().isEmpty())
                    sb.append(": ").append(h.getDescription());
                sb.append("\n");
            }
        }
        String system = "You are an assistant suggesting small habit improvements. Provide 3 practical suggestions tailored to the user's habits.";
        return groqService.ask(system, userId, sb.toString());
    }
}