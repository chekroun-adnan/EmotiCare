package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.*;
import com.EmotiCare.Repositories.HabitRepository;
import com.EmotiCare.Repositories.JournalRepository;
import com.EmotiCare.Repositories.MoodRepository;
import com.EmotiCare.Repositories.WeeklySummaryRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class WeeklySummaryService {

    private final WeeklySummaryRepository weeklySummaryRepository;
    private final MoodRepository moodRepository;
    private final JournalRepository journalRepository;
    private final HabitRepository habitRepository;
    private final GroqService groqService;
    private final AuthService authService;

    public WeeklySummaryService(WeeklySummaryRepository weeklySummaryRepository,
                                MoodRepository moodRepository,
                                JournalRepository journalRepository,
                                HabitRepository habitRepository,
                                GroqService groqService, AuthService authService) {
        this.weeklySummaryRepository = weeklySummaryRepository;
        this.moodRepository = moodRepository;
        this.journalRepository = journalRepository;
        this.habitRepository = habitRepository;
        this.groqService = groqService;
        this.authService = authService;
    }

    public WeeklySummary createWeeklySummary(String userId) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime weekAgo = now.minusDays(7);

        List<Mood> moods = moodRepository.findByUserIdAndTimestampBetween(userId, weekAgo, now);
        List<Journal> journals = journalRepository.findByUserId(userId).stream()
                .filter(j -> j.getTimestamp() != null && j.getTimestamp().isAfter(weekAgo))
                .collect(Collectors.toList());
        List<Habit> habits = habitRepository.findByUserId(userId);

        StringBuilder input = new StringBuilder();
        input.append("Moods (last 7 days):\n");
        for (Mood m : moods) input.append("- ").append(m.getMood()).append(" : ").append(
                m.getNote() == null ? "" : m.getNote()).append("\n");

        input.append("\nJournal snippets:\n");
        for (Journal j : journals) {
            String text = j.getText() == null ? "" : j.getText();
            if (text.length() > 300) text = text.substring(0, 300) + "...";
            input.append("- ").append(text).append("\n");
        }

        input.append("\nHabits snapshot:\n");
        for (Habit h : habits) {
            input.append("- ").append(h.getName())
                    .append(" (completed: ").append(h.isCompleted()).append(")\n");
        }

        String system = "You are EmotiCare AI. Generate a weekly summary containing: 1) short summary of emotional trends, 2) positives, 3) concerns, and 4) 3 practical AI-generated advice items.";
        String aiText = groqService.ask(system, userId, input.toString());

        WeeklySummary ws = new WeeklySummary();
        ws.setUserId(userId);
        ws.setSummaryText(aiText);
        ws.setMoodIds(moods.stream().map(Mood::getId).collect(Collectors.toList()));
        ws.setJournalIds(journals.stream().map(Journal::getId).collect(Collectors.toList()));
        ws.setHabitIds(habits.stream().map(Habit::getId).collect(Collectors.toList()));
        ws.setAiGeneratedAdvice(aiText);

        return weeklySummaryRepository.save(ws);
    }

    public List<WeeklySummary> getSummariesForUser(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }
        return weeklySummaryRepository.findByUserId(userId);
    }

    public Optional<WeeklySummary> getSummaryById(String id) {
        WeeklySummary ws = weeklySummaryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Weekly summary not found"));

        User currentUser = authService.getCurrentUser();
        if (!ws.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        return Optional.of(ws);
    }

    public void deleteSummary(String id) {
        WeeklySummary ws = weeklySummaryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Weekly summary not found"));

        User currentUser = authService.getCurrentUser();
        if (!ws.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        weeklySummaryRepository.deleteById(id);
    }
}
