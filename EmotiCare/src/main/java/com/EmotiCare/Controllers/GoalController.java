package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.Goal;
import com.EmotiCare.Services.GoalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/goals")
public class GoalController {

    @Autowired
    private GoalService goalService;

    @PostMapping("/create")
    public ResponseEntity<String> createGoal(@RequestBody Goal goal) {
        try{
            goalService.createGoal(goal);
            return ResponseEntity.ok("Goal Created");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/update")
    public ResponseEntity<String> updateGoal(@RequestBody Goal goal) {
        try {
            goalService.updateGoal(goal);
            return ResponseEntity.ok("Goal Updated");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/delete")
    public  ResponseEntity<String> deleteGoal(@RequestParam String goalId) {
        try {
            goalService.deleteGoal(goalId);
            return ResponseEntity.ok("Goal Deleted");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/get")
    public  ResponseEntity<?> getGoals() {
        try {
            List<Goal> goals = goalService.getAllGoalsByUserId();
            return ResponseEntity.ok(goals);
        }catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
