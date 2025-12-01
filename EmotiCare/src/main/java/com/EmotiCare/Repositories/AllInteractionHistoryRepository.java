package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.AllInteractionHistory;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface AllInteractionHistoryRepository extends MongoRepository<AllInteractionHistory, String> {
    List<AllInteractionHistory> findByUserId(String userId);
}
