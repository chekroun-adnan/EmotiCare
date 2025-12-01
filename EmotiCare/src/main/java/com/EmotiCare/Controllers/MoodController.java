package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.Mood;
import com.EmotiCare.Services.MoodService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/moods")
public class MoodController {

    private final MoodService moodService;

    public MoodController(MoodService moodService) {
        this.moodService = moodService;
    }

    @PostMapping("/track")
    public ResponseEntity<Mood> saveMood(
            @RequestParam String userId,
            @RequestParam String mood,
            @RequestParam(required = false) String note
    ) {
        return ResponseEntity.ok(moodService.saveMood(userId, mood, note));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Mood> getMood(@PathVariable String id) {
        return moodService.getMood(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/history/{userId}")
    public ResponseEntity<List<Mood>> getMoodHistory(@PathVariable String userId) {
        return ResponseEntity.ok(moodService.getMoodHistory(userId));
    }

    @GetMapping("/counts/{userId}")
    public ResponseEntity<Map<String, Long>> getMoodCounts(
            @PathVariable String userId,
            @RequestParam(defaultValue = "7") int days
    ) {
        return ResponseEntity.ok(moodService.getMoodCountsLastNDays(userId, days));
    }

    @GetMapping("/distribution/{userId}")
    public ResponseEntity<Map<String, Double>> moodDistributionPercent(
            @PathVariable String userId,
            @RequestParam(defaultValue = "7") int days
    ) {
        return ResponseEntity.ok(moodService.moodDistributionPercent(userId, days));
    }

    @GetMapping("/predict/{userId}")
    public ResponseEntity<String> predictNextMood(@PathVariable String userId) {
        return ResponseEntity.ok(moodService.predictNextMoodWithAI(userId));
    }
}