package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.MoodEntry;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface MoodEntryRepository extends MongoRepository<MoodEntry, String> {
    List<MoodEntry> findByUser_IdAndDateBetween(String userId, LocalDate startDate, LocalDate endDate);
}
