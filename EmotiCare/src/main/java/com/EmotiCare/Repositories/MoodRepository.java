package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.Mood;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface MoodRepository extends MongoRepository<Mood, String> {

    List<Mood> findByUserIdAndTimestampBetween(
            String userId,
            LocalDateTime start,
            LocalDateTime end
    );

    List<Mood> findByUserId(String userId);

    List<Mood> findByUserIdOrderByTimestampAsc(String userId);
}
