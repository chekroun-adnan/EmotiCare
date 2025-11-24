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
    private MoodEntryRepository moodEntryRepository;
    @Autowired
    private  UserRepository  userRepository;
    @Autowired
    private AuthService authService;

    public MoodEntryService(MoodEntryRepository moodEntryRepository, UserRepository userRepository) {
        this.moodEntryRepository = moodEntryRepository;
        this.userRepository = userRepository;
    }

    public MoodEntry createMood(String mood, Double sentimentScore, String notes) {
        User currentUser = authService.getCurrentUser();
        MoodEntry moodEntry = new MoodEntry();
        moodEntry.setUser(currentUser);
        moodEntry.setMood(mood);
        moodEntry.setSentimentScore(sentimentScore);
        moodEntry.setNotes(notes);
        moodEntry.setDate(LocalDate.now());
        return moodEntryRepository.save(moodEntry);
    }

    public List<MoodEntry> getMoodHistoryByUserId(String userId) {
        return moodEntryRepository.findByUserId(userId);
    }

}
