package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.AudioMessage;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface AudioMessageRepository extends MongoRepository<AudioMessage, String> {
    List<AudioMessage> findByUserId(String userId);
}
