package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.SuggestedAction;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface SuggestedActionRepository extends MongoRepository<SuggestedAction, String> {
    List<SuggestedAction> findByUserId(String userId);
}
