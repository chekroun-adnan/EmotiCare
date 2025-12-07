package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.Goal;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.GoalRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class GoalService {

    private final GoalRepository goalRepository;
    private final GroqService groqService;
    private final AuthService authService;

    public GoalService(GoalRepository goalRepository, GroqService groqService, AuthService authService) {
        this.goalRepository = goalRepository;
        this.groqService = groqService;
        this.authService = authService;
    }

    public Goal createGoal(Goal goal) {
        goal.setCompleted(false);
        return goalRepository.save(goal);
    }

    public List<Goal> getGoals(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return List.of();
        }
        return goalRepository.findByUserId(userId);
    }

    public Optional<Goal> getGoal(String userId, String id) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return Optional.empty();
        }
        return goalRepository.findById(id);
    }

    public Goal updateGoal(Goal goal) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(goal.getUserId())) {
            throw new RuntimeException("Unauthorized");
        }
        Goal existingGoal = goalRepository.findById(goal.getId())
                .orElseThrow(() -> new RuntimeException("Goal not found"));
        existingGoal.setDescription(goal.getDescription());
        existingGoal.setCompleted(goal.isCompleted());
        return goalRepository.save(goal);
    }

    public void deleteGoal(String id) {
        User currentUser = authService.getCurrentUser();
        Goal g = goalRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Goal not found"));
        if (!currentUser.getId().equals(g.getUserId())) {
            throw new RuntimeException("Unauthorized");
        }
        goalRepository.deleteById(id);
    }

    public Goal markGoalCompleted(String id) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(id)) {
            throw new RuntimeException("Unauthorized");
        }
        Goal g = goalRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Goal not found"));
        g.setCompleted(true);
        return goalRepository.save(g);
    }

    public String suggestGoalsWithAI(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return "unauthorized";
        }
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