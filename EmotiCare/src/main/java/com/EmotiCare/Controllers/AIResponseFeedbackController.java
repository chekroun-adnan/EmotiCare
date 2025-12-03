package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.AIResponseFeedback;
import com.EmotiCare.Services.AIResponseFeedbackService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/feedback")
public class AIResponseFeedbackController {

    private final AIResponseFeedbackService feedbackService;

    public AIResponseFeedbackController(AIResponseFeedbackService feedbackService) {
        this.feedbackService = feedbackService;
    }

    @PostMapping
    public ResponseEntity<AIResponseFeedback> create(@RequestBody AIResponseFeedback feedback) {
        return ResponseEntity.ok(feedbackService.saveFeedback(feedback));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AIResponseFeedback> getById(@PathVariable String id) {
        return feedbackService.getFeedbackById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<AIResponseFeedback>> getByUser(@PathVariable String userId) {
        return ResponseEntity.ok(feedbackService.getFeedbackForUser(userId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        feedbackService.deleteFeedback(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/analyze/{userId}")
    public ResponseEntity<String> analyze(@PathVariable String userId) {
        return ResponseEntity.ok(feedbackService.analyzeFeedbackWithAI(userId));
    }
}
