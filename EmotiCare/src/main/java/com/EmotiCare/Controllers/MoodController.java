package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.Mood;
import com.EmotiCare.Services.MoodService;
import com.EmotiCare.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/mood")
public class MoodEntryController {

    @Autowired
    private final MoodService moodService;
    @Autowired
    private final UserService userService;

    public MoodEntryController(MoodService moodService, UserService userService) {
        this.moodService = moodService;
        this.userService = userService;
    }

    @PostMapping("/create")
    public ResponseEntity<?> addMoodEntry(@RequestParam String mood,@RequestParam(required = false) Double sentimentScore, @RequestParam(required = false) String notes) {
        try{
            moodService.createMood(mood, sentimentScore, notes);
            return ResponseEntity.ok("Mood Entry Created");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/history")
    public ResponseEntity<List<Mood>> getMoodHistory(@RequestParam String userId) {
        List<Mood> moodHistory = moodService.getMoodHistory(userId);
        return ResponseEntity.ok(moodHistory);
    }
}
