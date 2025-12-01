package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.CommunityPost;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface CommunityPostRepository extends MongoRepository<CommunityPost, String> {
    List<CommunityPost> findByUserId(String userId);
}
