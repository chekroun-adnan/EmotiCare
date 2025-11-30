package com.EmotiCare.AI;

import com.EmotiCare.Entities.MoodEntry;
import com.EmotiCare.Repositories.MoodEntryRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AIPredictionService {
    private final MoodEntryRepository moodRepository;
    public AIPredictionService(MoodEntryRepository moodRepository){ this.moodRepository = moodRepository; }

    public String predictNextMood(String userId){
        List<MoodEntry> moods = moodRepository.findByUserIdOrderByTimestampAsc(userId);
        if(moods.isEmpty()) return "neutral";
        Map<String, Long> counts = moods.stream()
                .collect(Collectors.groupingBy(MoodEntry::getMood,Collectors.counting()));
        return counts.entrySet().stream().max(Map.Entry.comparingByValue()).get().getKey();
    }
}
