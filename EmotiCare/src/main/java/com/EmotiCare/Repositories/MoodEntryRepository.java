package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.MoodEntry;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface MoodEntryRepository extends MongoRepository<MoodEntry, String> {

    List<MoodEntry> findByUserIdAndTimestampBetween(
            String userId,
            LocalDateTime start,
            LocalDateTime end
    );

    List<MoodEntry> findByUserId(String userId);

    List<MoodEntry> findByUserIdOrderByTimestampAsc(String userId);
}
