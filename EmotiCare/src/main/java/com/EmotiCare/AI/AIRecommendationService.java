package com.EmotiCare.AI;

import com.EmotiCare.Entities.Habit;
import com.EmotiCare.Repositories.HabitRepository;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
public class AIRecommendationService {
    private final HabitRepository habitRepository;
    public AIRecommendationService(HabitRepository habitRepository){ this.habitRepository = habitRepository; }

    public List<String> recommendActivities(String userId){
        List<Habit> habits = habitRepository.findByUserId(userId);
        List<String> recommendations = new ArrayList<>();
        if(habits.stream().noneMatch(Habit::isCompleted)){
            recommendations.add("Try journaling today.");
            recommendations.add("Go for a short walk.");
        }
        recommendations.add("Meditation or breathing exercise.");
        return recommendations;
    }
}
