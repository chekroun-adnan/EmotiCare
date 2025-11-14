package com.EmotiCare.Services;

import com.EmotiCare.Entities.MoodEntry;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.MoodEntryRepository;
import com.EmotiCare.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MoodEntryService {

    @Autowired
    private final MoodEntryRepository moodEntryRepository;
    @Autowired
    private final UserRepository  userRepository;

    public MoodEntryService(MoodEntryRepository moodEntryRepository, UserRepository userRepository) {
        this.moodEntryRepository = moodEntryRepository;
        this.userRepository = userRepository;
    }

    public MoodEntry createMoodEntry(String mood, Double sentimentScore, String notes) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(()-> new RuntimeException("User not Found"));
        MoodEntry moodEntry = new MoodEntry();
        moodEntry.setUser(user);
        moodEntry.setMood(mood);
        moodEntry.setSentimentScore(sentimentScore);
        moodEntry.setNotes(notes);
        moodEntry.setDate(LocalDate.now());
        return moodEntryRepository.save(moodEntry);
    }

    public List<MoodEntry> getMoodHistory(String userId,LocalDate startDate, LocalDate endDate){
        return moodEntryRepository.findByUser_IdAndDateBetween(userId, startDate,endDate);
    }

    public Map<LocalDate, String> generateSentimentHeatmap (){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(6);
        List<MoodEntry> moodHistory = getMoodHistory(user.getId(),startDate, endDate);
        Map<LocalDate, String> sentimentHeatmap = new HashMap<>();
        for (MoodEntry moodEntry : moodHistory) {
            Double sentimentScore = moodEntry.getSentimentScore();
            if (sentimentScore == null) {
                sentimentScore = 0.0;
            }
            sentimentHeatmap.put(moodEntry.getDate(), String.format("%.2f", sentimentScore));
        }

        return sentimentHeatmap;
    }

    public void saveForecastResults(User user, Map<LocalDate, String> forecastData){
        forecastData.forEach((date,sentimentScore)->{
            MoodEntry moodEntry = new MoodEntry();
            moodEntry.setUser(user);
            moodEntry.setDate(LocalDate.now());
            moodEntry.setMood(moodEntry.getMood());
            moodEntryRepository.save(moodEntry);
        });
    }
}
