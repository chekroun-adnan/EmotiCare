package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.AIResponseFeedback;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface AIResponseFeedbackRepository extends MongoRepository<AIResponseFeedback, String> {
    List<AIResponseFeedback> findByUserId(String userId);
}
