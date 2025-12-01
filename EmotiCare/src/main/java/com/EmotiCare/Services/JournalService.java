package com.EmotiCare.Services;

import com.EmotiCare.Entities.Journal;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.JournalRepository;
import com.EmotiCare.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.nio.file.AccessDeniedException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class JournalService {

    @Autowired
   private JournalRepository journalRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private AuthService authService;

    public Journal addJournalEntry(Journal journal) {
        User currentUser = authService.getCurrentUser();
        Journal journalEntry = new Journal();
        journalEntry.setUserId(currentUser.getId());
        journalEntry.setText(journal.getText());
        journalEntry.setTimestamp(LocalDateTime.now());
        return journalRepository.save(journalEntry);
    }

    public List<Journal> getAllJournalEntries() {
        User currentUser = authService.getCurrentUser();
        return journalRepository.findByUserId(currentUser.getId());
    }

    public List<Journal> getJournalEntriesByDate(LocalDate date) {
        User currentUser = authService.getCurrentUser();
        return journalRepository.findByUserIdAndTimestampBetween(
                currentUser.getId(),
                date.atStartOfDay(),
                date.plusDays(1).atStartOfDay()
        );
    }

    public void deleteJournal(String entryId) throws Exception{
        User currentUser = authService.getCurrentUser();
        Journal existingJournal = journalRepository.findById(entryId)
                .orElseThrow(() -> new RuntimeException("Journal entry not found"));

        if (!existingJournal.getUserId().equals(currentUser.getId())) {
            throw new AccessDeniedException("You are not authorized to delete this journal entry");
        }
        journalRepository.delete(existingJournal);
    }

    public Journal updateJournal(Journal journal) {
        Journal existingJournal = journalRepository.findById(journal.getId())
                .orElseThrow(() -> new RuntimeException("Journal entry not found"));

        User currentUser = authService.getCurrentUser();

        if (!existingJournal.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("You are not authorized to update this journal entry");
        }
        existingJournal.setText(journal.getText());
        return journalRepository.save(existingJournal);
    }
}
