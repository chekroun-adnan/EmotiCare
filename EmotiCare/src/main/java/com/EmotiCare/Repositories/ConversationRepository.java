package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.ConversationMessage;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface ConversationRepository extends MongoRepository<ConversationMessage, String> {
    List<ConversationMessage> findByUserIdOrderByTimestampAsc(String userId);
}
