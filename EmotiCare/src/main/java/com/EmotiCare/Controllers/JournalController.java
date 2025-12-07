package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.Journal;
import com.EmotiCare.Services.JournalService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/journals")
public class JournalController {

    private final JournalService journalService;

    public JournalController(JournalService journalService) {
        this.journalService = journalService;
    }

    @PostMapping
    public ResponseEntity<Journal> createEntry(
            @RequestParam String userId,
            @RequestParam String text
    ) {
        return ResponseEntity.ok(journalService.createEntry(userId, text));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Journal>> getEntries(@PathVariable String userId) {
        return ResponseEntity.ok(journalService.getEntries(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getEntry(@PathVariable String userId, @RequestParam String id) {
        Journal j = journalService.getEntry(id, userId);
        if (j == null) {
            return ResponseEntity.status(404).body("Journal entry not found");
        }
        return ResponseEntity.ok(j);
    }

    public ResponseEntity<?> deleteEntry(
            @PathVariable String id,
            @RequestParam String userId
    ) {
        Journal j = journalService.getEntry(id, userId);
        if (j == null) {
            return ResponseEntity.status(404).body("Journal entry not found");
        }
        journalService.deleteEntry(id, userId);
        return ResponseEntity.ok("Journal entry deleted");
    }

    @GetMapping("/prompt/{userId}")
    public ResponseEntity<String> getPrompt(@PathVariable String userId) {
        return ResponseEntity.ok(journalService.generatePrompt(userId));
    }

    @GetMapping("/summarize/{userId}")
    public ResponseEntity<String> summarize(
            @PathVariable String userId,
            @RequestParam(defaultValue = "5") int maxEntries
    ) {
        return ResponseEntity.ok(journalService.summarizeJournalsWithAI(userId, maxEntries));
    }
}