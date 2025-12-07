package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.Habit;
import com.EmotiCare.Services.HabitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/habits")
public class HabitController {

    private final HabitService habitService;

    public HabitController(HabitService habitService) {
        this.habitService = habitService;
    }

    @PostMapping
    public ResponseEntity<Habit> createHabit(@RequestBody Habit habit) {
        return ResponseEntity.ok(habitService.createHabit(habit));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Habit>> getHabits(@PathVariable String userId) {
        return ResponseEntity.ok(habitService.getHabits(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Habit> getHabit(@PathVariable String id, @RequestParam String userId) {
        return habitService.getHabit(id, userId)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<Habit> updateHabit(@PathVariable String id, @RequestBody Habit updated) {
        return habitService.getHabit(id, updated.getUserId())
                .map(existing -> {
                    updated.setId(id);
                    return ResponseEntity.ok(habitService.updateHabit(updated));
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/user/{userId}/{id}")
    public ResponseEntity<?> deleteHabit(@PathVariable String userId, @PathVariable String id) {
        if (habitService.getHabit(id, userId).isEmpty()) {
            return ResponseEntity.status(404).body("Habit not found");
        }
        habitService.deleteHabit(id);
        return ResponseEntity.ok("Habit deleted");
    }

    @PostMapping("/complete/{id}")
    public ResponseEntity<?> markCompleted(@PathVariable String id) {
        try {
            return ResponseEntity.ok(habitService.markCompleted(id));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body("Habit not found");
        }
    }

    @GetMapping("/suggest/{userId}")
    public ResponseEntity<String> suggestHabitsWithAI(@PathVariable String userId) {
        return ResponseEntity.ok(habitService.suggestHabitsWithAI(userId));
    }
}
