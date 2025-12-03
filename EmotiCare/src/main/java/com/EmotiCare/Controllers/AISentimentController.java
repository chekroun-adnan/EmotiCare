package com.EmotiCare.Controllers;

import com.EmotiCare.Services.AISentimentService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/sentiment")
public class AISentimentController {

    private final AISentimentService sentimentService;

    public AISentimentController(AISentimentService sentimentService) {
        this.sentimentService = sentimentService;
    }

    @PostMapping("/analyze")
    public ResponseEntity<String> analyze(@RequestParam String message) {
        return ResponseEntity.ok(sentimentService.analyzeSentiment(message));
    }

    @PostMapping("/add-keyword")
    public ResponseEntity<String> addKeyword(
            @RequestParam String emotion,
            @RequestParam String keyword) {

        sentimentService.addKeyword(emotion, keyword);
        return ResponseEntity.ok("Keyword added");
    }
}
