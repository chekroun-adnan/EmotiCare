package com.EmotiCare.Controllers;

import com.EmotiCare.Services.MoodEntryService;
import com.EmotiCare.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.Map;

@Controller
@RequestMapping("/mood")
public class MoodEntryController {

    @Autowired
    private final MoodEntryService moodEntryService;
    @Autowired
    private final UserService userService;

    public MoodEntryController(MoodEntryService moodEntryService, UserService userService) {
        this.moodEntryService = moodEntryService;
        this.userService = userService;
    }


    @PostMapping("/create")
    public ResponseEntity<?> addMoodEntry(@RequestParam String mood,@RequestParam(required = false) Double sentimentScore, @RequestParam(required = false) String notes) {
        try{
            moodEntryService.createMoodEntry(mood, sentimentScore, notes);
            return ResponseEntity.ok("Mood Entry Created");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/heatmap")
    public ResponseEntity<?> generateSentimentHeatmap() {
        try {
            Map<LocalDate, String> heatmap = moodEntryService.generateSentimentHeatmap();
            if (heatmap.isEmpty()) {
                return ResponseEntity.ok("No mood entries found for this user.");
            }
            return ResponseEntity.ok(heatmap);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
