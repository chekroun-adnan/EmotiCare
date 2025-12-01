package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.TherapySession;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface TherapySessionRepository extends MongoRepository<TherapySession, String> {
    List<TherapySession> findByUserId(String userId);
}
