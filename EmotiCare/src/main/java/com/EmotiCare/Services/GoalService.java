package com.EmotiCare.Services;

import com.EmotiCare.Entities.Goal;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.GoalRepository;
import com.EmotiCare.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

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
        User user = authService.getCurrentUser();
         Goal existinggoal = goalRepository.findById(goal.getGoalId())
                .orElseThrow(()-> new RuntimeException("Goal Not Found"));
        if (!existinggoal.getUser().getId().equals(user.getId())){
            throw new RuntimeException("Unauthorized");
        }
        goal.setTitle(goal.getTitle());
        goal.setDescription(goal.getDescription());
        goal.setStatus(goal.getStatus());
        goal.setEstimatedBenefit(goal.getEstimatedBenefit());
        goal.setStartDate(LocalDate.now());
        goal.setRecommendedBy(goal.getRecommendedBy());
        goal.setEndDate(goal.getEndDate());
        return goalRepository.save(goal);
    }

    public void deleteGoal(String goalId){
        User user = authService.getCurrentUser();
        Goal existinggoal = goalRepository.findById(goalId)
                .orElseThrow(()-> new RuntimeException("Goal Not Found"));
        if (existinggoal.getUser().getId().equals(user.getId())){
            goalRepository.delete(existinggoal);
        }
    }

    public List<Goal> getAllGoalsByUserId(){
        User user = authService.getCurrentUser();
        return goalRepository.findByUserId(user.getId());
    }
}
