package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.AllInteractionHistory;
import com.EmotiCare.Services.AllInteractionHistoryService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/history")
public class AllInteractionHistoryController {

    private final AllInteractionHistoryService historyService;

    public AllInteractionHistoryController(AllInteractionHistoryService historyService) {
        this.historyService = historyService;
    }

    @PostMapping("/create")
    public ResponseEntity<AllInteractionHistory> createHistory(@RequestParam String userId) {
        return ResponseEntity.ok(historyService.createEmptyHistory(userId));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<?> getHistory(@PathVariable String userId) {
        Optional<AllInteractionHistory> history = historyService.getHistory(userId);
        return history.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping("/{historyId}/add-mood")
    public ResponseEntity<AllInteractionHistory> addMood(
            @PathVariable String historyId,
            @RequestParam String moodId) {

        return ResponseEntity.ok(historyService.addMoodToHistory(historyId, moodId));
    }

    @PostMapping("/{historyId}/add-journal")
    public ResponseEntity<AllInteractionHistory> addJournal(
            @PathVariable String historyId,
            @RequestParam String journalId) {

        return ResponseEntity.ok(historyService.addJournalToHistory(historyId, journalId));
    }

    @PostMapping("/{historyId}/add-message")
    public ResponseEntity<AllInteractionHistory> addMessage(
            @PathVariable String historyId,
            @RequestParam String messageId) {

        return ResponseEntity.ok(historyService.addMessageToHistory(historyId, messageId));
    }

    @PutMapping("/save")
    public ResponseEntity<AllInteractionHistory> save(@RequestBody AllInteractionHistory history) {
        return ResponseEntity.ok(historyService.save(history));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable String id) {
        historyService.deleteHistory(id);
        return ResponseEntity.ok("History deleted");
    }
}
