package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.AIResponseFeedback;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface AIResponseFeedbackRepository extends MongoRepository<AIResponseFeedback,String> {}

