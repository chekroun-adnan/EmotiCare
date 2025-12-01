package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.Goal;
import com.EmotiCare.Repositories.GoalRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class GoalService {

    private final GoalRepository goalRepository;
    private final GroqService groqService;

    public GoalService(GoalRepository goalRepository, GroqService groqService) {
        this.goalRepository = goalRepository;
        this.groqService = groqService;
    }

    public Goal createGoal(Goal goal) {
        goal.setCompleted(false);
        return goalRepository.save(goal);
    }

    public List<Goal> getGoals(String userId) {
        return goalRepository.findByUserId(userId);
    }

    public Optional<Goal> getGoal(String id) {
        return goalRepository.findById(id);
    }

    public Goal updateGoal(Goal goal) {
        return goalRepository.save(goal);
    }

    public void deleteGoal(String id) {
        goalRepository.deleteById(id);
    }

    public Goal markGoalCompleted(String id) {
        Goal g = goalRepository.findById(id).orElseThrow(() -> new RuntimeException("Goal not found"));
        g.setCompleted(true);
        return goalRepository.save(g);
    }

    public String suggestGoalsWithAI(String userId) {
        List<Goal> goals = getGoals(userId);
        StringBuilder sb = new StringBuilder();
        if (goals.isEmpty()) {
            sb.append("User has no existing goals.");
        } else {
            sb.append("User goals:\n");
            for (Goal g : goals) {
                sb.append("- ").append(g.getDescription()).append(" (completed: ").append(g.isCompleted()).append(")\n");
            }
        }
        String system = "Suggest 3 achievable goals for this user based on their current goals and habits. Keep them specific and actionable.";
        return groqService.ask(system, userId, sb.toString());
    }
}