package com.EmotiCare.Controllers;

import com.EmotiCare.Services.ProactiveAIService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/proactive")
public class ProactiveAIController {

    private final ProactiveAIService proactiveService;

    public ProactiveAIController(ProactiveAIService proactiveService) {
        this.proactiveService = proactiveService;
    }

    @GetMapping("/manual-checkin/{userId}")
    public ResponseEntity<String> manualCheckIn(@PathVariable String userId) {
        String reply = proactiveService.manualCheckIn(userId);
        return ResponseEntity.ok(reply);
    }
}
