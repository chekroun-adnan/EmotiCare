package com.EmotiCare.AI;

import com.EmotiCare.Entities.Mood;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.MoodRepository;
import com.EmotiCare.Services.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AIAnalyticsService {
    @Autowired
    private MoodRepository moodRepository;
    @Autowired
    private AuthService authService;

    public String generateWeeklySummary(User userId) {
        User currentUser = authService.getCurrentUser();
        List<Mood> moods = moodRepository.findByUserIdOrderByTimestampAsc(currentUser.getId());
        Map<String, Long> counts = moods.stream().collect(Collectors.groupingBy(Mood::getMood, Collectors.counting()));
        return "This week your moods were: " + counts.toString();
    }
}
