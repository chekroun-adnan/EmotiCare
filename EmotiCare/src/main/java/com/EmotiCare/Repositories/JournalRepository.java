package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.JournalEntry;
import com.EmotiCare.Entities.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.time.LocalDateTime;
import java.util.List;

public interface JournalRepository extends MongoRepository<JournalEntry, String> {
    List<JournalEntry> findByUser(User user);
    List<JournalEntry> findByUserAndCreatedAt(User user, LocalDateTime createdAt);
}
