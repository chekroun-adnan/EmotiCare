package com.EmotiCare.Services;

import com.EmotiCare.Entities.Habit;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.HabitRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HabitService {

    @Autowired
    private HabitRepository repository;
    @Autowired
    private AuthService authService;

    public Habit addHabit(Habit habit) {
        User currentUser = authService.getCurrentUser();
        habit.setUserId(currentUser.getId());
        habit.setName(habit.getName());
        habit.setDescription(habit.getDescription());
        return repository.save(habit);
    }

    public void deleteHabit(String habitId) {
        Habit habit = repository.findById(habitId)
                .orElseThrow(() -> new RuntimeException("Habit not found"));
        User currentUser = authService.getCurrentUser();
        if (!habit.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("You are not authorized to delete this habit");
        } else {
            repository.delete(habit);
        }
    }

    public List<Habit> getAllHabitsByUserId(String userId) {
        User currentUser = authService.getCurrentUser();
        return repository.findByUserId(currentUser.getId());
    }

    public Habit updateGoal(Habit habit) {
        Habit existingHabit = repository.findById(habit.getId())
                .orElseThrow(() -> new RuntimeException("Habit not found"));
        User currentUser = authService.getCurrentUser();
        if (!existingHabit.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("You are not authorized to update this habit");
        } else {
            existingHabit.setName(habit.getName());
            existingHabit.setDescription(habit.getDescription());
            return repository.save(existingHabit);
        }
    }
}
