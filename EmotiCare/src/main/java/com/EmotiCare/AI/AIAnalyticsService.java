package com.EmotiCare.AI;

import com.EmotiCare.Entities.MoodEntry;
import com.EmotiCare.Repositories.MoodEntryRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AIAnalyticsService {
    private final MoodEntryRepository moodRepository;
    public AIAnalyticsService(MoodEntryRepository moodRepository) { this.moodRepository = moodRepository; }

    public String generateWeeklySummary(String userId) {
        List<MoodEntry> moods = moodRepository.findByUserIdOrderByTimestampAsc(userId);
        Map<String, Long> counts = moods.stream().collect(Collectors.groupingBy(MoodEntry::getMood, Collectors.counting()));
        return "This week your moods were: " + counts.toString();
    }
}
