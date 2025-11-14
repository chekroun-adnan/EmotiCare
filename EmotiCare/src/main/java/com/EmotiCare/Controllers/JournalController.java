package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.JournalEntry;
import com.EmotiCare.Services.JournalService;
import com.EmotiCare.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/journal")
public class JournalController {

    @Autowired
    private final JournalService journalService;
    @Autowired
    private final UserService userService;

    public JournalController(JournalService journalService, UserService userService) {
        this.journalService = journalService;
        this.userService = userService;
    }

    @PostMapping("/create")
    public ResponseEntity<?> createJournal(@RequestBody JournalEntry journalEntry) {
        try {
            JournalEntry savedEntry = journalService.addJournalEntry(journalEntry.getContent());
            return ResponseEntity.ok(savedEntry);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/delete/{entryId}")
    public ResponseEntity<?> deleteJournal(@PathVariable String entryId ) {
        try {
            journalService.deleteJournal(entryId);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
