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
   private final JournalRepository journalRepository;
    @Autowired
    private final UserRepository userRepository;

    public JournalService(JournalRepository journalRepository, UserRepository userRepository) {
        this.journalRepository = journalRepository;
        this.userRepository = userRepository;
    }

    public JournalEntry addJournalEntry(String content) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email =   authentication.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(()->new RuntimeException("User not found"));
        JournalEntry journalEntry = new JournalEntry();
        journalEntry.setUser(user);
        journalEntry.setContent(content);
        journalEntry.setEmotionTags(null);
        journalEntry.setSentimentScore(0.0);
        journalEntry.setCreatedAt(LocalDateTime.now());
        return journalRepository.save(journalEntry);
    }

    public List<JournalEntry> getJournalEntry() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email =   authentication.getName();
        User user  = userRepository.findByEmail(email)
                .orElseThrow(()->new RuntimeException("User not found"));
        return journalRepository.findByUser(user);
    }

    public List<JournalEntry> getJournalEntryByDate(LocalDateTime createdAt){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email =   authentication.getName();
        User user  = userRepository.findByEmail(email)
                .orElseThrow(()->new RuntimeException("User not found"));
        return journalRepository.findByUserAndCreatedAt(user,createdAt);
    }

    public void deleteJournal(String entryId){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email =   authentication.getName();

        User user = userRepository.findByEmail(email)
                .orElseThrow(()->new RuntimeException("User not found"));

        JournalEntry existingJournal = journalRepository.findById(entryId)
                .orElseThrow(()->new RuntimeException("Journal entry not found"));

        if (!existingJournal.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("You are not authorized to delete this journal entry");
        }
        journalRepository.delete(existingJournal);
    }
}
