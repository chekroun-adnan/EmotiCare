package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.Mood;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.MoodRepository;
import com.EmotiCare.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class MoodService {

    private final MoodRepository moodRepository;
    private final GroqService groqService;

    public MoodService(MoodRepository moodRepository, GroqService groqService) {
        this.moodRepository = moodRepository;
        this.groqService = groqService;
    }

    public Mood saveMood(String userId, String moodType, String note) {
        Mood m = new Mood();
        m.setUserId(userId);
        m.setMood(moodType);
        m.setNote(note);
        m.setTimestamp(LocalDateTime.now());
        return moodRepository.save(m);
    }

    public Optional<Mood> getMood(String id) {
        return moodRepository.findById(id);
    }

    public List<Mood> getMoodHistory(String userId) {
        return moodRepository.findByUserId(userId);
    }

    public Map<String, Long> getMoodCountsLastNDays(String userId, int days) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime start = now.minus(days, ChronoUnit.DAYS);
        List<Mood> list = moodRepository.findByUserIdAndTimestampBetween(userId, start, now);
        return list.stream().collect(Collectors.groupingBy(Mood::getMood, Collectors.counting()));
    }

    public String predictNextMoodWithAI(String userId) {
        List<Mood> history = getMoodHistory(userId);
        if (history.isEmpty()) return "neutral";

        StringBuilder sb = new StringBuilder();
        int take = Math.min(20, history.size());
        List<Mood> recent = history.subList(Math.max(0, history.size() - take), history.size());
        for (Mood m : recent) {
            sb.append(m.getMood()).append(", ");
        }

        String system = "You are an assistant that predicts mood using past mood history. Return a single-word mood label (e.g., happy, sad, stressed, neutral).";
        String prompt = "User mood history: " + sb.toString();
        String aiResponse = groqService.ask(system, userId, prompt);
        if (aiResponse == null) return "neutral";
        return aiResponse.split("\\s+")[0].replaceAll("[^a-zA-Z_-]", "").toLowerCase();
    }

    public Map<String, Double> moodDistributionPercent(String userId, int days) {
        Map<String, Long> counts = getMoodCountsLastNDays(userId, days);
        long total = counts.values().stream().mapToLong(Long::longValue).sum();
        Map<String, Double> result = new HashMap<>();
        if (total == 0) return result;
        counts.forEach((k, v) -> result.put(k, (v * 100.0) / total));
        return result;
    }
}