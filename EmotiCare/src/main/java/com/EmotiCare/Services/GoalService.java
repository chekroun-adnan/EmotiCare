package com.EmotiCare.Services;

import com.EmotiCare.Entities.Goal;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.GoalRepository;
import com.EmotiCare.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.nio.file.AccessDeniedException;
import java.time.LocalDate;
import java.util.List;

@Service
public class GoalService {

    @Autowired
    private GoalRepository goalRepository;

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private AuthService authService;

    public Goal createGoal(Goal goal){
        User user = authService.getCurrentUser();
        goal.setUser(user);
        goal.setTitle(goal.getTitle());
        if (goal.getStartDate() == null) {
            goal.setStartDate(LocalDate.now());
        }

        if (goal.getStatus() == null) {
            goal.setStatus("TO_DO");
        }
        return goalRepository.save(goal);
    }

    public Goal updateGoal(Goal  goal){
        Goal existingGoal = goalRepository.findById(goal.getGoalId())
                .orElseThrow(()-> new RuntimeException("Goal Not Found"));
        User user = authService.getCurrentUser();
        if (!existingGoal.getUser().getId().equals(user.getId())){
            throw new RuntimeException("Unauthorized");
        }
        existingGoal.setTitle(goal.getTitle());
        existingGoal.setDescription(goal.getDescription());
        existingGoal.setStatus(goal.getStatus());
        existingGoal.setEstimatedBenefit(goal.getEstimatedBenefit());
        existingGoal.setStartDate(LocalDate.now());
        existingGoal.setRecommendedBy(goal.getRecommendedBy());
        existingGoal.setEndDate(goal.getEndDate());
        return goalRepository.save(existingGoal);
    }

    public void deleteGoal(String goalId) throws Exception{
        Goal existinggoal = goalRepository.findById(goalId)
                .orElseThrow(()-> new RuntimeException("Goal Not Found"));

        User user = authService.getCurrentUser();

        if (!existinggoal.getUser().getId().equals(user.getId())){
            throw new AccessDeniedException("You are not authorized to delete this goal");
        }
        goalRepository.delete(existinggoal);
    }

    public List<Goal> getAllGoalsByUserId(){
        User user = authService.getCurrentUser();
        return goalRepository.findByUserId(user.getId());
    }
}
