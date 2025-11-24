package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.MoodEntry;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Services.MoodEntryService;
import com.EmotiCare.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.List;
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
            moodEntryService.createMood(mood, sentimentScore, notes);
            return ResponseEntity.ok("Mood Entry Created");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/history")
    public ResponseEntity<List<MoodEntry>> getMoodHistory(@RequestParam String userId) {
        List<MoodEntry> moodHistory = moodEntryService.getMoodHistoryByUserId(userId);
        return ResponseEntity.ok(moodHistory);
    }
}
