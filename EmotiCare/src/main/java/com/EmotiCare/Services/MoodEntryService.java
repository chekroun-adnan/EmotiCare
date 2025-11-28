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
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MoodEntryService {

    private final MoodEntryRepository moodEntryRepository;
    private final UserRepository userRepository;
    private final AuthService authService;

    @Autowired
    public MoodEntryService(
            MoodEntryRepository moodEntryRepository,
            UserRepository userRepository,
            AuthService authService
    ) {
        this.moodEntryRepository = moodEntryRepository;
        this.userRepository = userRepository;
        this.authService = authService;
    }

    public MoodEntry createMood(String mood, Double sentimentScore, String notes) {

        User currentUser = authService.getCurrentUser();

        MoodEntry moodEntry = new MoodEntry();
        moodEntry.setUserId(currentUser.getId());
        moodEntry.setMood(mood);
        moodEntry.setNote(notes); // FIXED
        moodEntry.setTimestamp(LocalDateTime.now());

        return moodEntryRepository.save(moodEntry);
    }

    public List<MoodEntry> getMoodHistory(String userId) {
        return moodEntryRepository.findByUserId(userId);
    }

    public List<MoodEntry> getMoodHistoryByDateRange(LocalDate start, LocalDate end) {
        User currentUser = authService.getCurrentUser();

        return moodEntryRepository.findByUserIdAndTimestampBetween(
                currentUser.getId(),
                start.atStartOfDay(),
                end.plusDays(1).atStartOfDay()
        );
    }
}
