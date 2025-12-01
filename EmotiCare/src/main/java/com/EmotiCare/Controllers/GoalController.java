package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.Goal;
import com.EmotiCare.Services.GoalService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/goals")
public class GoalController {

    private final GoalService goalService;

    public GoalController(GoalService goalService) {
        this.goalService = goalService;
    }

    @PostMapping
    public ResponseEntity<Goal> createGoal(@RequestBody Goal goal) {
        return ResponseEntity.ok(goalService.createGoal(goal));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Goal>> getGoals(@PathVariable String userId) {
        return ResponseEntity.ok(goalService.getGoals(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Goal> getGoal(@PathVariable String id) {
        return goalService.getGoal(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<Goal> updateGoal(@PathVariable String id, @RequestBody Goal updated) {
        return goalService.getGoal(id)
                .map(existing -> {
                    updated.setId(id);
                    return ResponseEntity.ok(goalService.updateGoal(updated));
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteGoal(@PathVariable String id) {
        if (goalService.getGoal(id).isEmpty()) {
            return ResponseEntity.status(404).body("Goal not found");
        }
        goalService.deleteGoal(id);
        return ResponseEntity.ok("Goal deleted");
    }

    @PostMapping("/{id}/complete")
    public ResponseEntity<?> markCompleted(@PathVariable String id) {
        try {
            return ResponseEntity.ok(goalService.markGoalCompleted(id));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body("Goal not found");
        }
    }

    @GetMapping("/suggest/{userId}")
    public ResponseEntity<String> suggestGoals(@PathVariable String userId) {
        return ResponseEntity.ok(goalService.suggestGoalsWithAI(userId));
    }
}