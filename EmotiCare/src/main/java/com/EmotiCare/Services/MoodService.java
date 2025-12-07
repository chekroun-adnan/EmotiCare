package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.Mood;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.MoodRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class MoodService {

    private final MoodRepository moodRepository;
    private final GroqService groqService;
    private final AuthService authService;

    public MoodService(MoodRepository moodRepository, GroqService groqService, AuthService authService) {
        this.moodRepository = moodRepository;
        this.groqService = groqService;
        this.authService = authService;
    }

    public Mood saveMood(String userId, String moodType, String note) {
        Mood m = new Mood();
        m.setUserId(userId);
        m.setMood(moodType);
        m.setNote(note);
        m.setTimestamp(LocalDateTime.now());
        return moodRepository.save(m);
    }

    public Optional<Mood> getMood(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return Optional.empty();
        }
        return moodRepository.findByUserId(userId);
    }

    public List<Mood> getMoodHistory(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return List.of();
        }
        return moodRepository.findAllByUserId(userId);
    }

    public Map<String, Long> getMoodCountsLastNDays(String userId, int days) {

        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return Collections.emptyMap();
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime start = now.minusDays(days);

        List<Mood> list = moodRepository.findByUserIdAndTimestampBetween(userId, start, now);

        return list.stream()
                .collect(Collectors.groupingBy(Mood::getMood, Collectors.counting()));
    }

    public String predictNextMoodWithAI(String userId) {
        User currentUser = authService.getCurrentUser();

        if (!currentUser.getId().equals(userId)) {
            return "unauthorized";
        }

        List<Mood> history = getMoodHistory(userId);

        if (history.isEmpty()) {
            return "neutral";
        }

        int take = Math.min(20, history.size());
        List<Mood> recent = history.subList(history.size() - take, history.size());

        String moodHistory = recent.stream()
                .map(Mood::getMood)
                .collect(Collectors.joining(", "));

        String system = "You are an assistant that predicts the next mood using past mood history. Return a single-word mood label such as: happy, sad, stressed, anxious, calm, relaxed, neutral.";
        String prompt = "Here is the user's recent mood history: " + moodHistory + ". Predict the next mood.";

        String aiResponse = groqService.ask(system, userId, prompt);

        if (aiResponse == null || aiResponse.isBlank()) {
            return "neutral";
        }

        return aiResponse
                .split("\\s+")[0]
                .replaceAll("[^a-zA-Z_-]", "")
                .toLowerCase();
    }

    public Map<String, Double> moodDistributionPercent(String userId, int days) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            return Collections.emptyMap();
        }

        Map<String, Long> counts = getMoodCountsLastNDays(userId, days);
        long total = counts.values().stream().mapToLong(Long::longValue).sum();

        if (total == 0) return Collections.emptyMap();

        return counts.entrySet().stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        e -> (e.getValue() * 100.0) / total
                ));
    }
}