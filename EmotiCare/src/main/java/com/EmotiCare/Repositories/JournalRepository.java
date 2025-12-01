package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.Journal;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.time.LocalDateTime;
import java.util.List;

public interface JournalRepository extends MongoRepository<Journal, String> {

    List<Journal> findByUserId(String userId);

    List<Journal> findByUserIdAndTimestampBetween(
            String userId,
            LocalDateTime start,
            LocalDateTime end
    );
}
