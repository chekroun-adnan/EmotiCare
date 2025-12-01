package com.EmotiCare.AI;

import com.EmotiCare.Entities.Mood;
import com.EmotiCare.Repositories.MoodRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AIPredictionService {
    private final MoodRepository moodRepository;
    public AIPredictionService(MoodRepository moodRepository){ this.moodRepository = moodRepository; }

    public String predictNextMood(String userId){
        List<Mood> moods = moodRepository.findByUserIdOrderByTimestampAsc(userId);
        if(moods.isEmpty()) return "neutral";
        Map<String, Long> counts = moods.stream()
                .collect(Collectors.groupingBy(Mood::getMood,Collectors.counting()));
        return counts.entrySet().stream().max(Map.Entry.comparingByValue()).get().getKey();
    }
}
