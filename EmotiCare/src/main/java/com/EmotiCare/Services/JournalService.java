package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.Journal;
import com.EmotiCare.Repositories.JournalRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Service
public class JournalService {

    private final JournalRepository journalRepository;
    private final GroqService groqService;
    private final Random random = new Random();

    public JournalService(JournalRepository journalRepository, GroqService groqService) {
        this.journalRepository = journalRepository;
        this.groqService = groqService;
    }

    public Journal createEntry(String userId, String text) {
        Journal j = new Journal();
        j.setUserId(userId);
        j.setText(text);
        j.setTimestamp(LocalDateTime.now());
        return journalRepository.save(j);
    }

    public List<Journal> getEntries(String userId) {
        return journalRepository.findByUserId(userId);
    }

    public void deleteEntry(String id) {
        journalRepository.deleteById(id);
    }

    public Journal getEntry(String id) {
        return journalRepository.findById(id).orElse(null);
    }

    public String generatePrompt(String userId) {
        String[] prompts = {
                "Write about one thing you're grateful for today.",
                "Describe a challenge you faced and how you responded.",
                "What made you smile recently?",
                "Write a letter to your future self about where you'd like to be in a month."
        };
        return prompts[random.nextInt(prompts.length)];
    }

    public String summarizeJournalsWithAI(String userId, int maxEntries) {
        List<Journal> entries = getEntries(userId);
        if (entries.isEmpty()) return "No journal entries available.";

        List<Journal> recent = entries.stream()
                .sorted((a, b) -> b.getTimestamp().compareTo(a.getTimestamp()))
                .limit(maxEntries)
                .collect(Collectors.toList());

        String concat = recent.stream()
                .map(j -> "- " + j.getText())
                .collect(Collectors.joining("\n"));

        String system = "Summarize the following journal entries into 3 concise bullet points and suggest 2 small actions the user can take next.";
        return groqService.ask(system, userId, concat);
    }
}