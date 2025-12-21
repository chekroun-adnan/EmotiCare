package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.UserAIMemory;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserAIMemoryRepository extends MongoRepository<UserAIMemory, String> {
}
