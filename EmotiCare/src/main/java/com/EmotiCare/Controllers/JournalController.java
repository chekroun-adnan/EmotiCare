package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.Journal;
import com.EmotiCare.Services.JournalService;
import com.EmotiCare.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
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
    public ResponseEntity<?> getEntry(@PathVariable String id) {
        Journal j = journalService.getEntry(id);
        if (j == null) {
            return ResponseEntity.status(404).body("Journal entry not found");
        }
        return ResponseEntity.ok(j);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteEntry(@PathVariable String id) {
        Journal j = journalService.getEntry(id);
        if (j == null) {
            return ResponseEntity.status(404).body("Journal entry not found");
        }
        journalService.deleteEntry(id);
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