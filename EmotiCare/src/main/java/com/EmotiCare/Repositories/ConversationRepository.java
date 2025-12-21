package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.ConversationMessage;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface ConversationRepository extends MongoRepository<ConversationMessage, String> {
    List<ConversationMessage> findByUserIdOrderByTimestampAsc(String userId);

    List<ConversationMessage> findByUserId(String userId);
    List<ConversationMessage> findByUserIdAndTimestampAfter(String userId, LocalDateTime from);
}
