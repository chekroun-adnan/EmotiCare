package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.Habit;
import com.EmotiCare.Services.RecommendationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/recommendation")
public class RecommendationController {

    private final RecommendationService recommendationService;

    public RecommendationController(RecommendationService recommendationService) {
        this.recommendationService = recommendationService;
    }

    @GetMapping("/habits/{userId}")
    public ResponseEntity<List<Habit>> getUserHabits(@PathVariable String userId) {
        return ResponseEntity.ok(recommendationService.getUserHabits(userId));
    }

    @GetMapping("/activities/{userId}")
    public ResponseEntity<String> recommendActivities(
            @PathVariable String userId,
            @RequestParam(required = false) String moodSummary) {

        String suggestions = recommendationService.recommendActivitiesForUser(userId, moodSummary);
        return ResponseEntity.ok(suggestions);
    }
}
