package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.Journal;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.JournalRepository;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.security.SecureRandom;
import java.util.stream.Collectors;

@Service
public class JournalService {

    private final JournalRepository journalRepository;
    private final GroqService groqService;
    private final AuthService authService;
    private final SecureRandom random = new SecureRandom();

    public JournalService(JournalRepository journalRepository, GroqService groqService, AuthService authService) {
        this.journalRepository = journalRepository;
        this.groqService = groqService;
        this.authService = authService;
    }

    public Journal createEntry(String userId, String text) {
        Journal j = new Journal();
        j.setUserId(userId);
        j.setText(text);
        j.setTimestamp(LocalDateTime.now());
        return journalRepository.save(j);
    }

    public List<Journal> getEntries(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return List.of();
        }
        return journalRepository.findByUserId(userId);
    }

    public void deleteEntry(String userId, String entryId) {
        User currentUser = authService.getCurrentUser();

        if (!currentUser.getId().equals(userId)) {
            throw new AccessDeniedException("You cannot delete another user's entry");
        }
        Journal entry = journalRepository.findById(entryId)
                .orElseThrow(() -> new RuntimeException("Entry not found"));
        if (!entry.getUserId().equals(userId)) {
            throw new AccessDeniedException("This entry does not belong to you");
        }

        journalRepository.deleteById(entryId);
    }

    public Journal getEntry(String userId, String entryId) {
        User currentUser = authService.getCurrentUser();

        if (!currentUser.getId().equals(userId)) {
            return null;
        }

        Journal entry = journalRepository.findById(entryId).orElse(null);

        if (entry == null) {
            return null;
        }
        if (!entry.getUserId().equals(userId)) {
            return null;
        }

        return entry;
    }

    public String generatePrompt(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw new AccessDeniedException("You are not allowed to access prompts for another user");
        }
        String[] prompts = {
                "Write about one thing you're grateful for today.",
                "Describe a challenge you faced and how you responded.",
                "What made you smile recently?",
                "Write a letter to your future self about where you'd like to be in a month."
        };
        return prompts[random.nextInt(prompts.length)];
    }

    public String summarizeJournalsWithAI(String userId, int maxEntries) {
        User currentUser = authService.getCurrentUser();

        if (!currentUser.getId().equals(userId)) {
            throw new AccessDeniedException("You are not allowed to summarize journals for another user");
        }

        List<Journal> entries = getEntries(userId);
        if (entries.isEmpty())
            return "No journal entries available.";

        maxEntries = Math.min(maxEntries, 50);

        List<Journal> recent = entries.stream()
                .sorted((a, b) -> b.getTimestamp().compareTo(a.getTimestamp()))
                .limit(maxEntries)
                .collect(Collectors.toList());

        String concat = recent.stream()
                .map(j -> "- " + j.getText())
                .collect(Collectors.joining("\n"));

        String system = "Summarize the following journal entries into 3 concise bullet points and suggest 2 small actionable steps the user can take next. Only use one line per bullet point.";

        String summary = groqService.ask(system, userId, concat);

        return (summary == null || summary.isBlank()) ? "Unable to generate summary." : summary;
    }
}