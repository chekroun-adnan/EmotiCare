package com.EmotiCare.Controllers;


import com.EmotiCare.AI.GroqService;
import com.EmotiCare.DTO.UserMessageDTO;
import com.EmotiCare.Entities.TherapySession;
import com.EmotiCare.Services.TherapySessionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/therapy")
public class TherapySessionController {

    private final TherapySessionService sessionService;

    public TherapySessionController(TherapySessionService sessionService) {
        this.sessionService = sessionService;
    }

    @PostMapping("/start/{userId}")
    public ResponseEntity<TherapySession> startSession(@PathVariable String userId) {
        return ResponseEntity.ok(sessionService.startSession(userId));
    }

    @PostMapping("/end/{sessionId}")
    public ResponseEntity<TherapySession> endSession(@PathVariable String sessionId) {
        return ResponseEntity.ok(sessionService.endSession(sessionId));
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<TherapySession> getSession(@PathVariable String sessionId) {
        return sessionService.getSession(sessionId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<TherapySession>> getSessionsForUser(@PathVariable String userId) {
        return ResponseEntity.ok(sessionService.getSessionsForUser(userId));
    }

    @GetMapping("/summarize/{sessionId}")
    public ResponseEntity<String> summarizeSession(@PathVariable String sessionId) {
        return ResponseEntity.ok(sessionService.summarizeSessionWithAI(sessionId));
    }
}
