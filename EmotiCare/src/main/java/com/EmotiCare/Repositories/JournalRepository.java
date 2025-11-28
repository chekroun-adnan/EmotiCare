package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.JournalEntry;
import com.EmotiCare.Entities.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.time.LocalDateTime;
import java.util.List;

public interface JournalRepository extends MongoRepository<JournalEntry, String> {

    List<JournalEntry> findByUserId(String userId);

    List<JournalEntry> findByUserIdAndTimestampBetween(
            String userId,
            LocalDateTime start,
            LocalDateTime end
    );
}
