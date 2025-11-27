package com.EmotiCare.Services;

import com.EmotiCare.Entities.JournalEntry;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.JournalRepository;
import com.EmotiCare.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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

    public JournalEntry addJournalEntry(JournalEntry journal) {
        User currentUser = authService.getCurrentUser();
        JournalEntry journalEntry = new JournalEntry();
        journalEntry.setUser(currentUser);
        journalEntry.setContent(journal.getContent());
        journalEntry.setEmotionTags(null);
        journalEntry.setSentimentScore(0.0);
        journalEntry.setCreatedAt(LocalDateTime.now());
        return journalRepository.save(journalEntry);
    }

    public List<JournalEntry> getAllJournalEntries() {
        User currentUser = authService.getCurrentUser();
        return journalRepository.findByUser_Id(currentUser.getId());
    }

    public List<JournalEntry> getJournalEntriesByDate(LocalDate date) {
        User currentUser = authService.getCurrentUser();
        return journalRepository.findByUserAndCreatedAtBetween(
                currentUser,
                date.atStartOfDay(),
                date.plusDays(1).atStartOfDay()
        );
    }

    public void deleteJournal(String entryId) throws Exception{
        User currentUser = authService.getCurrentUser();
        JournalEntry existingJournal = journalRepository.findById(entryId)
                .orElseThrow(() -> new RuntimeException("Journal entry not found"));

        if (!existingJournal.getUser().getId().equals(currentUser.getId())) {
            throw new AccessDeniedException("You are not authorized to delete this journal entry");
        }
        journalRepository.delete(existingJournal);
    }

    public JournalEntry updateJournal(JournalEntry journal) {
        JournalEntry existingJournal = journalRepository.findById(journal.getEntryId())
                .orElseThrow(() -> new RuntimeException("Journal entry not found"));

        User currentUser = authService.getCurrentUser();

        if (!existingJournal.getUser().getId().equals(currentUser.getId())) {
            throw new RuntimeException("You are not authorized to update this journal entry");
        }
        existingJournal.setContent(journal.getContent());
        existingJournal.setEmotionTags(journal.getEmotionTags());
        existingJournal.setSentimentScore(journal.getSentimentScore());
        return journalRepository.save(existingJournal);
    }
}
