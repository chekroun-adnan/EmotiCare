package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.WeeklySummary;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface WeeklySummaryRepository extends MongoRepository<WeeklySummary, String> {
    List<WeeklySummary> findByUserId(String userId);
}
