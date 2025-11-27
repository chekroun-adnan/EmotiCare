package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.Habit;
import com.EmotiCare.Services.HabitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/habits")
public class HabitController {

    @Autowired
    private HabitService habitService;


    @PostMapping("/create")
    public ResponseEntity<Habit> saveHabit(Habit habit) {
        try{
            Habit savedHabit = habitService.addHabit(habit);
            return ResponseEntity.ok(savedHabit);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/get")
    public ResponseEntity<?> getAllHabits(String userId){
        try{
            List<Habit> habits = habitService.getAllHabitsByUserId(userId);
            return ResponseEntity.ok(habits);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/delete")
    public ResponseEntity<?> deleteHabit(String habitId){
        try{
            habitService.deleteHabit(habitId);
            return ResponseEntity.ok("Habit Deleted");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/update")
    public ResponseEntity<?> updateHabit(Habit habit){
        try{
            Habit updatedHabit = habitService.updateGoal(habit);
            return ResponseEntity.ok(updatedHabit);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
