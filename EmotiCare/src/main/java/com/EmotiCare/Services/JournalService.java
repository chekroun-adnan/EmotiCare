package com.EmotiCare.Services;

import com.EmotiCare.Entities.JournalEntry;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.JournalRepository;
import com.EmotiCare.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

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

    public JournalEntry addJournalEntry(String content) {
        User currentUser = authService.getCurrentUser();
        JournalEntry journalEntry = new JournalEntry();
        journalEntry.setUser(currentUser);
        journalEntry.setContent(content);
        journalEntry.setEmotionTags(null);
        journalEntry.setSentimentScore(0.0);
        journalEntry.setCreatedAt(LocalDateTime.now());
        return journalRepository.save(journalEntry);
    }

    public List<JournalEntry> getJournalEntryByDate(LocalDateTime createdAt){
        User currentUser = authService.getCurrentUser();
        return journalRepository.findByUserAndCreatedAt(currentUser,createdAt);
    }

    public List<JournalEntry> getAllJournalEntries() {
        User currentUser = authService.getCurrentUser();
        return journalRepository.findByUser_Id(currentUser.getId());
    }

    public void deleteJournal(String entryId){
        User currentUser = authService.getCurrentUser();

        JournalEntry existingJournal = journalRepository.findById(entryId)
                .orElseThrow(()->new RuntimeException("Journal entry not found"));

        if (!existingJournal.getUser().getId().equals(currentUser.getId())) {
            throw new RuntimeException("You are not authorized to delete this journal entry");
        }
        journalRepository.delete(existingJournal);
    }
}
