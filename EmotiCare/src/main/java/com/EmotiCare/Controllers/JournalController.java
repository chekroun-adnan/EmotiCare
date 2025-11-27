package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.JournalEntry;
import com.EmotiCare.Services.JournalService;
import com.EmotiCare.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

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
            JournalEntry savedEntry = journalService.addJournalEntry(journalEntry);
            return ResponseEntity.ok("Journal Entry Created");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/delete")
    public ResponseEntity<?> deleteJournal(@RequestParam String entryId ) {
        try {
            journalService.deleteJournal(entryId);
            return ResponseEntity.ok("Journal Entry Deleted");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping ("/get")
    public ResponseEntity<?> getJournalByDate() {
        try{
            List<JournalEntry> journalEntries = journalService.getAllJournalEntries();
            return ResponseEntity.ok(journalEntries);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/update")
    public ResponseEntity<?> updateJournalEntry(@RequestBody JournalEntry journalEntry) {
        try {
            journalService.updateJournal(journalEntry);
            return ResponseEntity.ok("Journal Entry Updated");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
