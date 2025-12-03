package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.WeeklySummary;
import com.EmotiCare.Services.WeeklySummaryService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/weekly-summary")
public class WeeklySummaryController {

    private final WeeklySummaryService weeklySummaryService;

    public WeeklySummaryController(WeeklySummaryService weeklySummaryService) {
        this.weeklySummaryService = weeklySummaryService;
    }

    @PostMapping("/create/{userId}")
    public ResponseEntity<WeeklySummary> createWeeklySummary(@PathVariable String userId) {
        return ResponseEntity.ok(weeklySummaryService.createWeeklySummary(userId));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<WeeklySummary>> getSummariesForUser(@PathVariable String userId) {
        return ResponseEntity.ok(weeklySummaryService.getSummariesForUser(userId));
    }

    @GetMapping("/{summaryId}")
    public ResponseEntity<WeeklySummary> getSummaryById(@PathVariable String summaryId) {
        return weeklySummaryService.getSummaryById(summaryId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{summaryId}")
    public ResponseEntity<Void> deleteSummary(@PathVariable String summaryId) {
        weeklySummaryService.deleteSummary(summaryId);
        return ResponseEntity.noContent().build();
    }
}
